# Contributing

Thanks for your interest in contributing to QuickWeek!

## Prerequisites

- macOS 14+ and a recent Xcode (the project is built with Xcode 26 in CI)
- [SwiftLint](https://github.com/realm/SwiftLint) — CI runs `swiftlint lint --strict`, so warnings fail the build

## Building

```sh
xcodebuild -project QuickWeek.xcodeproj -target QuickWeek -configuration Release build
```

The app lands in `build/Release/QuickWeek.app`. Note that plain builds use the build **target** (`-target`), while tests use the shared **scheme** (`-scheme`).

## Testing

```sh
xcodebuild test -project QuickWeek.xcodeproj -scheme QuickWeek
```

Please add tests for new logic where practical — the pure calendar math lives in `WeekCalculator.swift` precisely so it stays easy to test.

## Ground rules

- **Everything checked into this repository is written in English**: code, comments, string literals (including user-facing UI strings), documentation, CI configuration, and commit messages.
- Commit messages follow the `type: subject` convention (e.g. `fix: …`, `feat: …`, `docs: …`), loosely per [Conventional Commits](https://www.conventionalcommits.org). No extra tooling is required.
- Keep the app small and dependency-free — it currently builds with no third-party dependencies.
- Never commit personal data or absolute user paths.

## Localization

QuickWeek ships in English (the menu bar reads `CW29`, the calendar says `Today`). **Localizations are explicitly welcome** and a great first contribution — the user-facing strings live in `CalendarView` and `AppDelegate`. See the [good first issues](https://github.com/marsvogel/QuickWeek/labels/good%20first%20issue).

## AI-assisted contributions

This project is developed with AI assistance (see [AI_DISCLOSURE.md](AI_DISCLOSURE.md)). AI-assisted contributions are welcome — you remain responsible for anything you submit, so please review it and note significant AI involvement in the pull request.

## Pull requests

Open an issue first for larger changes so the direction can be discussed; small fixes can go straight to a PR. This is a single-maintainer hobby project — you can expect a best-effort reply, and it's always fine to ping a thread that has gone quiet.
