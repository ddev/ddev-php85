# Copilot Instructions for ddev-php8.5

## Repository Overview

This repository is a DDEV add-on for PHP 8.5 support, currently based on the DDEV add-on template. DDEV is a Docker-based local development environment tool that simplifies setting up development environments for web applications.

## Current State

**Note**: This repository is currently in development and contains template files that need to be customized for PHP 8.5 support. The repository still contains references to "addon-template" that should be replaced with "php8.5" specific configurations.

## Purpose

Once fully developed, this add-on will extend DDEV to support PHP 8.5, allowing developers to:
- Test their applications against PHP 8.5
- Develop applications that require PHP 8.5 features
- Ensure compatibility with the latest PHP version

## Key Files and Components

### Core Add-on Files
- `install.yaml` - Defines how the add-on is installed (currently contains template values that need customization)
- `docker-compose.addon-template.yaml` - Docker Compose configuration (needs to be renamed and customized for PHP 8.5)
- `README.md` - Main documentation (currently contains template content)

### Files Needing Customization
The following files still contain template references and need to be updated for PHP 8.5:
- `install.yaml` - Change name from "addon-template" to "php8.5"
- `docker-compose.addon-template.yaml` - Rename to `docker-compose.php8.5.yaml` and configure for PHP 8.5
- `tests/test.bats` - Update GITHUB_REPO reference from template to actual repository
- `README.md` - Replace template content with PHP 8.5 specific documentation
- Various files containing "ddev/ddev-addon-template" references

### Testing Infrastructure
- `tests/test.bats` - Bats test suite that validates the add-on functionality
- `tests/testdata/` - Test data and configurations
- `.github/workflows/tests.yml` - GitHub Actions workflow for automated testing

### GitHub Configuration
- `.github/ISSUE_TEMPLATE/` - Issue templates for bug reports and feature requests
- `.github/PULL_REQUEST_TEMPLATE.md` - Pull request template
- `.github/scripts/` - Helper scripts for repository management

## Development Workflow

### Adding Features
1. Modify the appropriate configuration files (`install.yaml`, Docker Compose files)
2. Update tests in `tests/test.bats` to validate new functionality
3. Update documentation in `README.md`
4. Test locally using `ddev add-on get /path/to/local/addon`
5. Create pull request with descriptive changes

### Testing
- Tests use the Bats testing framework for Bash
- Tests validate that the add-on can be installed and functions correctly
- Two test scenarios: local installation and release installation
- Tests run automatically on pull requests and daily via GitHub Actions

### File Conventions
- All DDEV-managed files should include `#ddev-generated` comment for proper cleanup
- Use DDEV environment variables for templating (e.g., `${DDEV_SITENAME}`, `${DDEV_APPROOT}`)
- Follow semantic versioning for releases

## DDEV-Specific Considerations

### Environment Variables
Common DDEV environment variables available:
- `DDEV_SITENAME` - Project name
- `DDEV_APPROOT` - Application root directory
- `DDEV_DOCROOT` - Document root
- `DDEV_PROJECT_TYPE` - Project type (drupal, wordpress, etc.)

### Add-on Structure
- `project_files` - Files copied to project's `.ddev` directory
- `global_files` - Files copied to user's global `~/.ddev` directory
- `pre_install_actions` - Commands run before installation
- `post_install_actions` - Commands run after installation
- `removal_actions` - Commands run when add-on is removed

### Docker Services
- Services should be prefixed with add-on name to avoid conflicts
- Use appropriate labels for DDEV discovery
- Follow Docker Compose best practices for service definitions

## PHP 8.5 Implementation Tasks

To complete this add-on, the following tasks need to be completed:

### 1. Template Customization
- [ ] Run the first-time setup script or manually update template references
- [ ] Rename `docker-compose.addon-template.yaml` to `docker-compose.php8.5.yaml`
- [ ] Update `install.yaml` name field from "addon-template" to "php8.5"
- [ ] Update project_files to reference the renamed docker-compose file
- [ ] Update GITHUB_REPO in `tests/test.bats` to "ddev/ddev-php8.5"

### 2. PHP 8.5 Configuration
- [ ] Configure Docker service to use PHP 8.5 image
- [ ] Add PHP 8.5 specific extensions and configurations
- [ ] Set up proper volume mounts for PHP application code
- [ ] Configure PHP-FPM or CLI as needed
- [ ] Add environment variables for PHP 8.5 configuration

### 3. Testing and Documentation
- [ ] Update health_checks() function in test.bats for PHP 8.5 validation
- [ ] Write comprehensive README with PHP 8.5 usage instructions
- [ ] Document any PHP 8.5 specific features or limitations
- [ ] Add examples of how to use the add-on

## PHP 8.5 Specifics

Once implemented, this add-on should:
- Provide PHP 8.5 runtime environment
- Include common PHP extensions needed for web development
- Be compatible with various PHP frameworks and CMSs
- Support both CLI and web server usage
- Handle version-specific configurations and optimizations
- Provide proper integration with DDEV's existing PHP infrastructure

## Code Style and Standards

- Follow existing patterns in DDEV add-ons
- Use descriptive comments in configuration files
- Maintain backward compatibility when possible
- Document any breaking changes clearly
- Follow Docker and YAML best practices

## Troubleshooting Common Issues

- Ensure Docker images are publicly accessible
- Test add-on with different DDEV versions (stable and HEAD)
- Validate that all required environment variables are available
- Check for conflicts with other add-ons
- Verify proper cleanup on add-on removal

## Release Process

1. Update version constraints in `install.yaml`
2. Update `README.md` with new features/changes
3. Create GitHub release with semantic version
4. Test installation via `ddev add-on get ddev/ddev-php8.5`
5. Announce in DDEV community channels

## Related Resources

- [DDEV Documentation](https://ddev.readthedocs.io/)
- [DDEV Add-on Development Guide](https://ddev.readthedocs.io/en/stable/users/extend/additional-services/)
- [DDEV Add-on Registry](https://addons.ddev.com/)
- [Bats Testing Framework](https://bats-core.readthedocs.io/)
- [PHP 8.5 Release Notes](https://www.php.net/releases/8.5/en.php)

## Contributing Guidelines

When contributing to this repository:
1. Follow the DDEV add-on conventions and best practices
2. Test your changes with both local and release installation methods
3. Update documentation for any new features or configuration options
4. Ensure compatibility with different operating systems and DDEV versions
5. Add or update tests for new functionality
6. Use descriptive commit messages and PR descriptions

## Repository Maintenance

- Monitor for PHP 8.5 updates and security patches
- Keep base Docker images updated
- Respond to community issues and pull requests
- Maintain compatibility with DDEV releases
- Update documentation as needed
- Review and merge pull requests promptly
- Tag releases following semantic versioning