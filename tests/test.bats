#!/usr/bin/env bats
#   bats tests
# For debugging:
#   bats tests --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  # Override this variable for your add-on:
  export GITHUB_REPO=ddev/ddev-php85

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
  run ddev php85 --version
  assert_success
  assert_output --partial "PHP 8.5"

  # Test PHP 8.5 modules
  echo "# Testing PHP 8.5 modules" >&3
  run ddev php85 -m
  assert_success
  assert_output --partial "Core"
  assert_output --partial "json"
  assert_output --partial "mbstring"

  # Test that PHP 8.5 can execute a simple script
  echo "# Testing PHP 8.5 script execution" >&3
  run ddev php85 -r "echo 'PHP 8.5 is working';"
  assert_success
  assert_output --partial "PHP 8.5 is working"

  # Test that phpinfo works
  echo "# Testing PHP 8.5 phpinfo" >&3
  run ddev php85 -r "echo 'PHP Version: ' . PHP_VERSION;"
  assert_success
  assert_output --partial "PHP Version:"
  assert_output --partial "8.5"

  # Test that composer is available in PHP 8.5 container
  echo "# Testing composer in PHP 8.5 container" >&3
  run ddev composer85 --version
  assert_success
  assert_output --partial "Composer"

}

teardown() {
  set -eu -o pipefail
#  echo "# LEAVING ${TESTDIR} for you" >&3
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf "${TESTDIR}"

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

# bats test_tags=local
@test "drupal 11 installation with php85" {
  set -eu -o pipefail
  echo "# Testing Drupal 11 installation with PHP 8.5" >&3

  # Need to delete the project created by setup() and start fresh
  run ddev delete -Oy "${PROJNAME}"
  assert_success

  # Clean up the entire test directory
  cd "${HOME}/tmp"
  rm -rf "${TESTDIR}"
  export TESTDIR="$(mktemp -d "${HOME}/tmp/${PROJNAME}.XXXXXX")"
  cd "${TESTDIR}"

  # Clone Drupal 11 dev version first (into empty directory)
  echo "# Cloning Drupal 11" >&3
  run git clone --depth 1 --single-branch --branch 11.x https://git.drupalcode.org/project/drupal.git .
  assert_success

  # Configure for Drupal 11
  run ddev config --project-type=drupal11
  assert_success

  # Install add-on and start
  run ddev add-on get "${DIR}"
  assert_success
  run ddev start -y
  assert_success

  # Install dependencies with standard composer
  echo "# Installing dependencies with standard composer" >&3
  run ddev composer install
  assert_success

  # Update dependencies with PHP 8.5
  echo "# Updating dependencies with PHP 8.5" >&3
  run ddev composer85 update --with-all-dependencies --ignore-platform-reqs
  assert_success

  # Install Drush with PHP 8.5
  echo "# Installing Drush with PHP 8.5" >&3
  run ddev composer85 require drush/drush --ignore-platform-reqs
  assert_success

  # Test basic PHP 8.5 functionality
  echo "# Testing PHP 8.5 version in Drupal context" >&3
  run ddev php85 --version
  assert_success
  assert_output --partial "PHP 8.5"

  # Install Drupal site with PHP 8.5 using demo_umami
  echo "# Installing Drupal site with drush85" >&3
  run ddev drush sql-drop -y
  assert_success
  run ddev drush85 si -y --account-pass=admin
  assert_success

  run ddev drush85 config:set system.performance css.preprocess 0 -y
  assert_success
  run ddev drush85 config:set system.performance js.preprocess 0 -y
  assert_success

  run ddev drush85 cr
  assert_success

  # Test web access shows installed Drupal site
  echo "# Trying ddev launch" >&3
  run ddev launch
  assert_success
  echo "# curling project" >&3
  run curl -s "$(ddev st -j | jq -r .raw.primary_url)"
  assert_output --regexp "Welcome.*Drush Site"
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}
