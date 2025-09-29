[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/ddev/ddev-php8.5/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ddev/ddev-php8.5/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-php8.5)](https://github.com/ddev/ddev-php8.5/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-php8.5)](https://github.com/ddev/ddev-php8.5/releases/latest)

# DDEV PHP 8.5 Add-on <!-- omit in toc -->

This add-on provides experimental PHP 8.5 support for DDEV projects using pre-release PHP 8.5 images.

* [What is DDEV PHP 8.5 Add-on?](#what-is-ddev-php-85-add-on)
* [Installation](#installation)
* [Usage](#usage)
* [Limitations](#limitations)
* [Contributing](#contributing)

## What is DDEV PHP 8.5 Add-on?

This add-on allows DDEV users to experiment with PHP 8.5 while it's in Release Candidate (RC) status. PHP 8.5 is expected to be released in November 2024, and you can track its progress at [PHP 8.5.0 Release](https://www.php.net/index.php#2025-09-25-3).

This add-on provides a separate PHP 8.5 service that can be used alongside the main web service.

Since PHP 8.5 is not yet available from the official deb.sury.org repository, this add-on uses the official PHP Docker images to provide early access to PHP 8.5 features.

**Note:** This is a temporary solution. Once PHP 8.5 becomes stable and is available through official repositories, DDEV will provide native PHP 8.5 support, making this add-on obsolete.

## Installation

```bash
ddev add-on get ddev/ddev-php8.5
ddev restart
```

## Usage

After installation, you can access PHP 8.5 in two ways:

### Using the php8.5 service directly:

```bash
# Check PHP 8.5 version
ddev exec -s php8.5 php --version

# Run PHP 8.5 scripts
ddev exec -s php8.5 php -r "echo 'Hello from PHP 8.5!';"

# Use Composer with PHP 8.5
ddev exec -s php8.5 composer install

# Access the PHP 8.5 container directly
ddev ssh -s php8.5
```

### Using the convenient php8.5 command:

This add-on provides a custom `ddev php8.5` command for easier access:

```bash
# Check PHP 8.5 version (shorthand)
ddev php8.5 --version

# Run PHP 8.5 scripts (shorthand)
ddev php8.5 -r "echo 'Hello from PHP 8.5!';"

# Use with any PHP flags or arguments
ddev php8.5 -i  # Show phpinfo
```

The PHP 8.5 service has the same codebase mounted at `/var/www/html` as the main web container.

## Limitations

This add-on has several important limitations:

- **Release Candidate**: PHP 8.5 is in Release Candidate status and may have bugs or compatibility issues
- **No Xdebug**: The current setup does not include Xdebug support
- **Limited Extensions**: Only includes basic PHP extensions (see `php8.5-build/Dockerfile` for the full list)
- **No Development Tools**: Some development tools that integrate with DDEV's main web service may not work with the PHP 8.5 service
- **Performance**: Building the custom PHP 8.5 image may take additional time during project startup
- **Stability**: Release Candidate PHP versions may have unexpected behavior
- **PHP Version Setting**: The `php_version` setting in DDEV configuration has no effect when using this add-on, as it provides a separate PHP 8.5 service alongside the main web container
- **Performance Mode**: This add-on sets `performance_mode: none` to avoid conflicts between mutagen (used by the main web container) and bind-mounts (used by the PHP 8.5 container). This may impact file sync performance.

## Contributing

Contributions are welcome! Please:

1. Test any changes thoroughly
2. Update tests in `tests/test.bats` for new functionality
3. Update this README if you add new features or change behavior
4. Follow the existing code style and patterns

**Contributed and maintained by the DDEV team**
