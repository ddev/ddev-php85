#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests/test.bats
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  # Override this variable for your add-on:
  export GITHUB_REPO=ddev/ddev-php8.5

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p "${HOME}/tmp"
  export TESTDIR="$(mktemp -d "${HOME}/tmp/${PROJNAME}.XXXXXX")"
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
  run ddev start -y
  assert_success
}

health_checks() {
  # Test that PHP 8.5 service is available and working
  echo "# Testing PHP 8.5 version" >&3
  run ddev exec -s php8.5 php --version
  assert_success
  assert_output --partial "PHP 8.5"

  # Test PHP 8.5 modules
  echo "# Testing PHP 8.5 modules" >&3
  run ddev exec -s php8.5 php -m
  assert_success
  assert_output --partial "Core"
  assert_output --partial "json"
  assert_output --partial "mbstring"

  # Test that PHP 8.5 can execute a simple script
  echo "# Testing PHP 8.5 script execution" >&3
  run ddev exec -s php8.5 php -r "echo 'PHP 8.5 is working';"
  assert_success
  assert_output --partial "PHP 8.5 is working"

  # Test that phpinfo works
  echo "# Testing PHP 8.5 phpinfo" >&3
  run ddev exec -s php8.5 php -r "echo 'PHP Version: ' . PHP_VERSION;"
  assert_success
  assert_output --partial "PHP Version:"
  assert_output --partial "8.5"

  # Test that composer is available in PHP 8.5 container
  echo "# Testing composer in PHP 8.5 container" >&3
  run ddev exec -s php8.5 composer --version
  assert_success
  assert_output --partial "Composer"

}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1
  # Persist TESTDIR if running inside GitHub Actions. Useful for uploading test result artifacts
  # See example at https://github.com/ddev/github-action-add-on-test#preserving-artifacts
  if [ -n "${GITHUB_ENV:-}" ]; then
    [ -e "${GITHUB_ENV:-}" ] && echo "TESTDIR=${HOME}/tmp/${PROJNAME}" >> "${GITHUB_ENV}"
  else
    [ "${TESTDIR}" != "" ] && rm -rf "${TESTDIR}"
  fi
}

# bats test_tags=local
@test "install from directory" {
  set -eu -o pipefail
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}


# bats test_tags=local
@test "web functionality with custom docroot" {
  set -eu -o pipefail
  echo "# Testing web functionality with custom docroot" >&3

  # Create docroot directory and index.php
  mkdir -p docroot
  cat > docroot/index.php << 'EOF'
<?php
phpinfo();
EOF

  # Configure project to use custom docroot
  run ddev config --docroot=docroot
  assert_success

  # Install add-on
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success

  # Test web access via curl
  echo "# Testing web access to phpinfo" >&3
  run ddev exec curl -s http://localhost
  assert_success
  assert_output --partial "PHP Version"
  assert_output --partial "8.5"
  assert_output --partial "phpinfo()"

  # Also test CLI functionality
  health_checks
}
