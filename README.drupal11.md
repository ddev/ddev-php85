# Drupal 11 with PHP 8.5 Quick Start

This guide shows how to create a Drupal 11 site using PHP 8.5 with DDEV, based on the [DDEV Drupal quickstart](https://docs.ddev.com/en/stable/users/quickstart/#drupal) but modified to use the PHP 8.5 add-on.

## Prerequisites

- DDEV v1.24.8 or later
- Docker running on your system

## Quick Start Steps

### 1. Create Project and Configure DDEV

```bash
mkdir my-drupal11-php85 && cd my-drupal11-php85
ddev config --project-type=drupal11 --docroot=web
```

### 2. Install PHP 8.5 Add-on

```bash
ddev add-on get ddev/ddev-php85
ddev start
```

### 3. Install Drupal 11 Dev Version

```bash
# Clone Drupal 11 dev version
git clone --branch 11.x https://git.drupalcode.org/project/drupal.git .

# Install dependencies with PHP 8.4 (Drupal default)
ddev composer install

# Update dependencies with PHP 8.5 to handle platform requirements
ddev composer85 update --with-all-dependencies --ignore-platform-req=php

# Install Drush with PHP 8.5
ddev composer85 require drush/drush --ignore-platform-req=php
```

### 4. Install Drupal Site

```bash
ddev drush85 si -y --account-pass=admin
```

### 5. Configure for Development

```bash
# Disable CSS and JS aggregation for better debugging with PHP 8.5
ddev drush85 config:set system.performance css.preprocess 0 -y
ddev drush85 config:set system.performance js.preprocess 0 -y
ddev drush85 cr
```

### 6. Launch Your Site

```bash
# Launch the site
ddev launch

# Or automatically log in as admin (if drush85 works)
ddev launch $(ddev drush85 uli)
```

## What You'll Have

- **Drupal 11 development version** running on **PHP 8.5.0RC1**
- Admin login: `admin` / `admin`
- CSS and JS aggregation disabled for easier debugging
- Most Drupal commands using PHP 8.5 via `ddev drush85`

## Available PHP 8.5 Commands

The add-on provides several commands that use PHP 8.5:

```bash
# Check PHP version
ddev php85 --version

# Use Composer with PHP 8.5
ddev composer85 install
ddev composer85 require drupal/module_name

# Use Drush with PHP 8.5
ddev drush85 status
ddev drush85 cr
ddev drush85 uli

# Access PHP 8.5 container directly
ddev ssh -s php85
```

### Drush limitations

* `ddev drush85 sql-cli` doesn't work with some database server versions because of mariadb/mysql compatibility issues. Use `ddev drush sql-cli` to to use the ddev-webserver version.
* `ddev drush85 sql-drop` may not work for the same reason. Use `ddev drush sql-drop` to drop the database.
* 

## Important Notes

- **PHP 8.5 is in Release Candidate status** - not for production use
- **Deprecation warnings** may appear - this is expected with PHP 8.5

## Troubleshooting

### Composer Issues
If Composer has problems with PHP 8.5:
```bash
ddev composer85 install --ignore-platform-req=php
```

## Complete Example Script

```bash
#!/bin/bash
# Complete Drupal 11 + PHP 8.5 setup
set -eu -o pipefail

ADDON=ddev/ddev-php85
# Uncomment to use a local copy of the add-on
#ADDON=~/workspace/ddev-php85
SITENAME=my-drupal11-php85

git clone -depth 1 --single-branch --branch 11.x https://git.drupalcode.org/project/drupal.git ${SITENAME}
cd ${SITENAME}
ddev config --project-type=drupal11
ddev add-on get ${ADDON}
ddev composer install
ddev composer85 update --with-all-dependencies --ignore-platform-reqs
ddev composer85 require drush/drush --ignore-platform-reqs
ddev drush sql-drop -y # drush85 may not work with mariadb
ddev drush85 si -y --account-pass=admin
ddev drush85 config:set system.performance css.preprocess 0 -y
ddev drush85 config:set system.performance js.preprocess 0 -y
ddev drush85 cr
ddev launch $(ddev drush85 uli)

echo "Drupal 11 with PHP 8.5 is ready!"
echo "Login: admin / admin"
```

## Next Steps

- Explore Drupal 11 features with PHP 8.5
- Test modules for PHP 8.5 compatibility
- Report any PHP 8.5 compatibility issues to respective module maintainers
- Monitor PHP error logs for deprecation warnings