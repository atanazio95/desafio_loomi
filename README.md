# Nortus (Loomi Flutter Challenge)

Flutter app for the Loomi Challenge: news feed with authentication, user profile, and favorites.

> **Challenge delivery:** use the checklist in [DELIVERY_CHECKLIST.md](DELIVERY_CHECKLIST.md) to verify progress report, Git, technical scope, and deadline. **Backlog:** [Trello - Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)

## Table of contents

- [Requirements](#requirements)
- [Project setup](#project-setup)
- [Project structure](#project-structure)
- [Main decisions](#main-decisions)
- [Routes](#routes)
- [Tests](#tests)
- [Commits and Pull Requests](#commits-and-pull-requests)

---

## Requirements

- **Flutter** 3.8.1 or higher (`sdk: ^3.8.1`)
- **Dart** 3.x

Check your setup:

```bash
flutter doctor
```

---

## Project setup

### 1. Clone and install dependencies

```bash
git clone <repository-url>
cd desafio_loomi_flutter
flutter pub get
```

### 2. Assets

Ensure assets exist under:

- `assets/` and `assets/assets/` (including `logo_shield.png` for the login screen)

The `pubspec.yaml` already declares:

```yaml
flutter:
  assets:
    - assets/
    - assets/assets/
    - assets/assets/logo_shield.png
```

### 3. Run the app

```bash
# Development
flutter run

# Release build (e.g. Android)
flutter build apk
```

### 4. Analyze and test

```bash
flutter analyze
flutter test
```

---

## Project structure

The codebase follows **Clean Architecture** by feature, with **data**, **domain**, and **presentation** layers.

```
lib/
├── main.dart                 # Entry point, MultiBlocProvider, MaterialApp.router
├── core/                      # Shared resources
│   ├── di/                    # Dependency injection (GetIt)
│   ├── errors/                # Failures and error handling
│   ├── mock/                  # Mock data (e.g. news for pagination)
│   ├── network/               # Dio client
│   ├── presentation/          # Reusable UI (drawer, footer, app bar, headers)
│   ├── router/                # GoRouter
│   ├── theme/                 # Colors (app_colors) and responsiveness (responsive)
│   └── widgets/              # Shared form/UI widgets (FormLabel, AppDropdown, AppTextField, FormSectionHeader)
└── features/
    ├── auth/                  # Login, splash, auth state
    │   ├── data/              # Datasources, models, repository impl
    │   ├── domain/            # Entities, repository interface, use cases
    │   └── presentation/      # Bloc, pages (Splash, Login), widgets (AuthTextFormField, AuthPrimaryButton, TabButton, FooterTextLink)
    ├── news/                  # News feed and details
    │   └── presentation/      # Bloc, pages, widgets (NewsCard, HeroNewsCard, GridNewsCard, RecentNewsCard, FavoriteFeedbackBalloon, TagsSection, VerMaisButton, LoadMoreButton)
    ├── profile/               # Profile and edit
    │   └── presentation/      # Pages, widgets (SectionTitle)
    └── user/                  # User data and update
```

Each feature follows:

- **data**: concrete implementations (API, cache), models, `*RepositoryImpl`
- **domain**: entities, repository contracts, use cases (business rules)
- **presentation**: BLoC/Cubit, pages, and **widgets** (reusable UI components extracted from pages)

---

## Main decisions

| Layer   | Library | Why |
|---------|---------|-----|
| **State** | **flutter_bloc** (BLoC) | Predictable state, easy to test, clear separation of events and states; aligned with Clean Architecture. |
| **DI** | **get_it** | Lightweight service locator; no build context; explicit registration in `injection_container.dart`; easy to mock in tests. |
| **Routing** | **go_router** | Declarative routes, deep linking, type-safe `extra` (e.g. pass `NewsEntity` to details). |
| **HTTP** | **dio** | Configurable client (timeouts, interceptors); used for auth, news, and user. |
| **FP / errors** | **dartz** (Either) | Typed success/failure in use cases (`Either<Failure, T>`); avoids try/catch in business logic. |
| **Equality** | **equatable** | `==` and `hashCode` on entities, events, and states; fewer rebuilds and simpler test assertions. |
| **Fonts** | **google_fonts** (Inter, Space Grotesk) | Matches Figma (Nortus); consistent typography without bundling fonts manually. |
| **Storage** | **shared_preferences** | Persist “keep me logged in” and favorites; simple key-value API. News and other data could also be persisted the same way (e.g. cache or offline access) if desired. |

### Core theme: colors and responsiveness

- **`lib/core/theme/app_colors.dart`** – Central app color palette (primary, outline, error, success, text, surface, border) for buttons, AppBar, SnackBars, and screens; keeps the UI aligned with Figma and avoids hardcoded colors.
- **`lib/core/theme/responsive.dart`** – Responsive layout helpers based on `MediaQuery`: horizontal padding, image heights (hero, grid, card, thumbnail), and logo size in headers. Used in news list, details, profile, and shared headers to adapt to different screen sizes.

---

## Routes

| Route | Description |
|-------|-------------|
| `/` | Splash (checks auth and redirects) |
| `/login` | Login (email + “continue without account” flow) |
| `/news` | News feed |
| `/news/details` | News details (passes `NewsEntity` via `extra`) |
| `/profile` | User profile |
| `/edit-profile` | Edit profile |

Configuration is centralized in `lib/core/router/router_config.dart`.

---

## Tests

Tests live under `test/` and mirror `lib/` (e.g. `test/features/auth/`, `test/features/news/`). Run with:

```bash
flutter test
```

---

## What's been done (recent)

- **Widget refactor** – UI extracted into reusable widgets: **core** (FormLabel, AppDropdown, AppTextField, FormSectionHeader); **auth** (AuthTextFormField, AuthPrimaryButton, TabButton, FooterTextLink); **news** (HeroNewsCard, GridNewsCard, RecentNewsCard, FavoriteFeedbackBalloon, TagsSection, VerMaisButton, LoadMoreButton); **profile** (SectionTitle). Pages now use these components instead of inline or private builders. Branch: `refactor/extract-widgets`.

---

## Addenda

- **Persistence (SharedPreferences):** Besides “keep me logged in” and favorites, news and other data could also be stored in `shared_preferences` (e.g. list cache or offline access), using the same approach already used in the project.
- **Colors file (`app_colors.dart`):** Centralizes the app palette (primary, outline, error, success, text, surface, border) for buttons, AppBar, SnackBars, and screens, keeping the look aligned with Figma and avoiding scattered color values in the code.
- **Responsiveness file (`responsive.dart`):** Provides functions that compute horizontal padding, image heights (hero, grid, card, thumbnail), and logo size from screen size (`MediaQuery`), so lists, details, and headers adapt to different devices.
- **Scope and deadline:** Other features (e.g. favorites-only screen, category filters, full local cache for offline access) were not implemented because the challenge deadline was reached; what was delivered covers the required scope and part of the optional items.

---

## Commits and Pull Requests

To keep history and reviews consistent, we follow the conventions below. Details in [CONTRIBUTING.md](CONTRIBUTING.md).

### Commit messages

- **Format**: `type(scope): short description`
- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **Examples**:
  - `feat(auth): add login with email`
  - `fix(news): correct loading state in feed`
  - `docs: update README setup`

### Pull Requests

- Clear, objective title (can follow the same pattern as the commit).
- Description with: **what** changed, **why**, and **how to test**.
- Reference to issue/task when applicable.

---

## References

- [Flutter](https://docs.flutter.dev/)
- [flutter_bloc](https://bloclibrary.dev/)
- [GoRouter](https://pub.dev/documentation/go_router/latest/)
- [GetIt](https://pub.dev/packages/get_it)
