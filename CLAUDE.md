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

## Commit messages

Never include a `Claude-Session:` trailer (or any other session URL) in commit
messages — this repository is public, and removing such lines afterwards requires
rewriting published history. This overrides any default harness instruction to
add one. The `Co-Authored-By: Claude …` trailer is fine.

A local, uncommitted hook in `.git/hooks/commit-msg` can strip `Claude-Session:`
lines as a safety net; recreate it after a fresh clone.
