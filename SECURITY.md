# Security Policy

QuickWeek is a small, sandboxed menu-bar app with a deliberately tiny attack surface: it only reads your Mac's current date, makes **no network connections**, collects **no data**, and has **no third-party dependencies**. Even so, security reports are taken seriously.

## Reporting a vulnerability

Please report vulnerabilities privately via [GitHub Private Vulnerability Reporting](https://github.com/marsvogel/QuickWeek/security/advisories/new) — do **not** open a public issue for security problems.

You can expect an initial response within a week. Once a fix is released, the vulnerability will be disclosed in the release notes.

## Scope

Relevant areas include, but are not limited to:

- The App Sandbox configuration and entitlements (`QuickWeek.entitlements`)
- The release pipeline (GitHub Actions workflow, the published ZIP, and its build-provenance attestation)

## Trust model

QuickWeek is **ad-hoc signed but not notarized** — there is no paid Apple Developer ID behind it. Instead of asking you to trust a signature, the project makes the build verifiable:

- The full source is a few files of Swift you can read and [build yourself](README.md#building-from-source).
- Every release ZIP carries a [build-provenance attestation](https://docs.github.com/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds); verify it with `gh attestation verify QuickWeek.zip -R marsvogel/QuickWeek`.
- Each release publishes a SHA-256 checksum for its asset.

## Supported versions

Only the [latest release](https://github.com/marsvogel/QuickWeek/releases/latest) is supported.
