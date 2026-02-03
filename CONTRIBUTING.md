# Contribution guide

This document defines good practices for **commit messages** and **Pull Requests**, ensuring clarity and consistency in the project history.

---

## Commit messages

### Format

```
type(scope): short description in imperative mood

Optional body with more details, wrap at 72 characters.
```

- **type**: what changed (feat, fix, docs, etc.)
- **scope**: module/area affected (auth, news, profile, core)
- **description**: short phrase, imperative (“add” not “added”)

### Allowed types

| Type       | Use |
|-----------|-----|
| `feat`    | New feature |
| `fix`     | Bug fix |
| `docs`    | Documentation only (README, CONTRIBUTING, comments) |
| `style`   | Formatting, spaces, semicolons (no logic change) |
| `refactor`| Refactor (no new feature or bug fix) |
| `test`    | Adding or updating tests |
| `chore`   | Build, CI, dependencies, config (e.g. pubspec, analysis_options) |

### Suggested scopes

- `auth` – login, splash, authentication
- `news` – feed, details, favorites
- `profile` / `user` – profile and user data
- `core` – router, DI, network, errors, services
- *(omit scope when the change is general, e.g. `docs: update README`)*

### Examples

```text
feat(auth): add login screen with email and "continue without account"
fix(news): avoid duplicate requests when opening details
docs: add project setup and architecture to README
style(login): apply Figma spacing to tab container
refactor(core): extract Dio base URL to app_config
test(auth): add AuthBloc login success and failure cases
chore: upgrade flutter_lints to 5.0.0
```

### What to avoid

- Generic messages: `fix bug`, `update`, `changes`
- Past tense: prefer “add” over “added”
- Mixing several types in one commit: keep commits atomic

---

## Pull Requests

### Title

- Clear and short.
- Can follow the commit pattern: `type(scope): description`.

Examples:

- `feat(auth): login screen per Figma`
- `fix(news): loading state in feed`

### Description

Clearly include:

1. **What** was changed (summary of changes).
2. **Why** (reason/context, link to issue if any).
3. **How to test** (steps for a reviewer to validate).

Example:

```markdown
## What
- New login screen with "Sign in" and "Create account" tabs
- Email field and "Sign in" button with color #1876D2
- "Forgot password" and "Continue without account" links

## Why
Align login screen with Figma design (issue #XX).

## How to test
1. Run `flutter run`
2. On splash, wait for redirect to /login
3. Check layout (Nortus, logo, tabs, blue card)
4. Test "Sign in" with valid email and "Continue without account"
```

### Good practices

- Commits in the PR with messages following the format above.
- One PR per goal (one feature or one fix).
- Update documentation (README, CONTRIBUTING) if the change affects setup or flow.
- Run `flutter analyze` and `flutter test` before opening the PR.

---

## Quick summary

| Item | Rule |
|------|------|
| Commit | `type(scope): description in imperative` |
| PR title | Clear and objective (can use same pattern as commit) |
| PR description | What, why, and how to test |

Following this guide keeps history readable and reviews faster.
