# AGENTS.md

This file provides guidance for coding agents working in this repository.

## Quick Context
- App: Movie Knowledge App (SwiftUI + SwiftData, iOS 17+).
- Architecture: MVVM with service layer. App state is `@Observable` (no Combine).
- Design system: See `STYLEGUIDE.md` and `Utilities/Constants/DesignSystem.swift`.

## Workflow
- Use plan mode for non-trivial work (3+ steps or architectural decisions).
- Keep changes minimal and localized.
- Verify behavior when practical (Xcode build or targeted checks).
- If instructions conflict, prioritize: system > repo files > local files.

## Codebase Rules
- Use SwiftUI and SwiftData patterns already in use.
- Prefer `@Environment(\.modelContext)` and inject services after context is ready.
- Avoid introducing Combine or third-party dependencies unless explicitly requested.
- Lottie is present but not configured; avoid executing Lottie paths.

## UI/UX Rules
- Follow the minimal, calm aesthetic from `STYLEGUIDE.md`.
- Use design tokens in `DesignSystem` rather than custom colors/spacing.
- Keep animations subtle (no glows, confetti, or heavy motion).

## File Organization
- Views: `Movie-Knowledge-App/Views/...`
- Models: `Movie-Knowledge-App/Models/...`
- Services: `Movie-Knowledge-App/Services/...`
- Utilities/design tokens: `Movie-Knowledge-App/Utilities/Constants/...`

## Testing & Builds
- No unit tests currently configured.
- Preferred: Xcode build/run; CLI via `xcodebuild` if requested.

## When Unsure
- Ask concise clarification questions.
- State assumptions explicitly before proceeding.
