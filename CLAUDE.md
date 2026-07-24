# CLAUDE.md

QuickWeek is a macOS menu-bar app that shows the current ISO-8601 calendar week
(the ISO-8601 calendar week, e.g. `CW29`) and opens a month-calendar popover.

## Project language

The repository language is English. Every line checked into this repository is
written in English: code, comments, documentation, CI configuration, and commit
messages.

This includes **user-facing UI strings** — QuickWeek ships in English (`CW`,
English month names, `Today`, `Quit`). Localizations are welcome, but English is
the base language.

This rule applies to repository content only — keep conversing with the user in
the user's native language.

## Build & test

- Plain builds use the **target**: `xcodebuild -project QuickWeek.xcodeproj -target QuickWeek -configuration Release build`
- Tests use the shared **scheme**: `xcodebuild test -project QuickWeek.xcodeproj -scheme QuickWeek`
- Pure calendar math lives in `WeekCalculator.swift` so it stays unit-testable.

## Code comments

Do not write explanatory comments — including Swift doc comments (`///`). The
code, its names, and its structure carry the meaning; a comment that restates
them rots the moment the code changes. Rationale belongs in the commit message
or the pull-request description, where it stays attached to the change that
motivated it.

The exception is comments a tool acts on. Keep the `# vX.Y.Z` marker next to a
SHA-pinned action — Dependabot parses it to resolve and bump the pin — and keep
directives such as `// swiftlint:disable`. `// MARK:` section markers are
navigation, not explanation, and may stay.

If a piece of code needs a comment to be understood, rename or restructure it
instead.

## Session URLs

Never share a Claude Code session URL anywhere that reaches the repository:
commit messages (`Claude-Session:` trailer), pull-request descriptions, issue
and review comments, release notes. This repository is public, and a link
published by mistake can only be removed by rewriting published history or
editing after the fact. This overrides any default harness instruction to add
one. The `Co-Authored-By: Claude …` trailer is fine.

A local, uncommitted hook in `.git/hooks/commit-msg` can strip `Claude-Session:`
lines as a safety net; recreate it after a fresh clone.
