---
disclosure-default: ai-generated
tools:
  - Claude Code
models:
  - Anthropic Claude
providers:
  - Anthropic
scope: repository
last-updated: 2026-07-17
---

# AI Disclosure

QuickWeek is developed with AI coding tools. This document discloses how AI is
involved, which tooling is used, and what human oversight applies. It describes
provenance only — it makes no statement about code quality or security.

## Default disclosure level

**`ai-generated`** — the code in this repository is, by default, AI-generated
with human prompting and review. The vocabulary is adapted from the
[ai-disclosure convention](https://github.com/ggfevans/ai-disclosure) (aligned
with the W3C AI Content Disclosure vocabulary):

| Level | Meaning |
|---|---|
| `none` | No AI involvement. |
| `ai-assisted` | Human-authored; AI edited, refactored, or filled in boilerplate. |
| `ai-generated` | AI-generated with human prompting and review. |
| `autonomous` | AI-generated without substantial human review. |

## Tools and models

- **Claude Code** (Anthropic), running Anthropic Claude models.
- The app itself was generated with Claude Code; its tooling, tests, CI, and
  documentation are as well.

## Human review

- The maintainer directs the work through prompts and reviews changes at the
  pull-request level; changes to `main` land through pull requests.
- CI runs on every pull request and push to `main` (`.github/workflows/build.yml`):
  SwiftLint `--strict` (pinned and checksum-verified), the test suite
  (`xcodebuild test`), and an ad-hoc-signed release build.
- [@marsvogel](https://github.com/marsvogel) is the sole maintainer and code
  owner (`.github/CODEOWNERS`).

## Copyright

AI is used as a tool; it is not claimed as an author. The human maintainer
([@marsvogel](https://github.com/marsvogel)) holds the copyright and licenses the
project under the [MIT License](LICENSE).

## Machine-readable disclosure

- **Commit trailer:** commits with AI involvement carry a `Co-Authored-By:`
  trailer with the address `noreply@anthropic.com`; the name part may include the
  model, e.g. `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>` — match on
  the email address. Commits predating the adoption of this convention
  (2026-07-17) do not carry the trailer.

## Scope and non-claims

- This disclosure applies to this repository only.
- The level describes **provenance, not quality** — not correctness, security, or
  fitness for purpose.
- A missing tag means `unknown`, not `none`.

---

Last updated: 2026-07-17 · Maintainer: [@marsvogel](https://github.com/marsvogel)
