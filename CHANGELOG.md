# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Because QuickWeek has no public API, versions are read as: MAJOR = a notable
behavior or UX change (or a dropped macOS version), MINOR = a new feature,
PATCH = a fix.

## [Unreleased]

### Added

- Menu-bar item showing the current ISO-8601 calendar week, e.g. `CW29`.
- Popover month calendar with a week-number column, current-week and today
  highlighting, month navigation, and a Today button.
- Automatic refresh at midnight and when the Mac wakes from sleep.
- Unit tests for the calendar math (`WeekCalculator`).
- Continuous integration: SwiftLint (`--strict`), tests, CodeQL, and an OpenSSF
  Scorecard analysis.
- Automated, ad-hoc-signed release builds published as a ZIP with a SHA-256
  checksum and a build-provenance attestation.
- Community health files, English documentation, and an AI-development disclosure.

[Unreleased]: https://github.com/marsvogel/QuickWeek/commits/main
