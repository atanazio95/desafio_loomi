# Nortus (Desafio Loomi Flutter)

Flutter app for the Loomi Challenge: news feed with authentication, user profile, and favorites.

> **Entrega do desafio:** use o checklist em [ENTREGA_DESAFIO.md](ENTREGA_DESAFIO.md) para conferir relatório de progresso, Git, escopo técnico e prazo. **Backlog:** [Trello - Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)

### Prerequisites

- Flutter SDK ^3.8.1
- Dart ^3.8.1

### Setup

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

---

## Project structure

The app follows **Clean Architecture** organized by **feature**:

```
lib/
├── main.dart
├── core/
│   ├── di/                 # Dependency injection (GetIt)
│   ├── errors/             # Failures / error types
│   ├── mock/               # Mock data (e.g. news for pagination)
│   ├── network/            # Dio client
│   ├── presentation/       # Shared UI (drawer, footer, app bar, headers)
│   ├── router/             # GoRouter config
│   └── services/           # Favorites manager (SharedPreferences)
└── features/
    ├── auth/               # Login, register, splash
    ├── news/               # News list, details, favorites
    ├── profile/            # Profile and edit profile pages
    └── user/               # User domain + profile loading/update
```

Each feature is split into **data** (datasources, models, repositories), **domain** (entities, repositories, use cases), and **presentation** (BLoC, pages, widgets).

---

## Tech stack

| Layer        | Choice |
|-------------|--------|
| State       | **flutter_bloc** (BLoC) |
| DI          | **get_it** |
| Routing     | **go_router** |
| HTTP        | **dio** |
| FP / errors | **dartz** (Either) |
| Equality    | **equatable** |
| Fonts       | **google_fonts** (Inter, Space Grotesk) |
| Storage     | **shared_preferences** (favorites, session) |

---

## Features

- **Splash** – Initial screen with redirect by auth status.
- **Auth** – Login and register (tabs), session handling.
- **News** – List with hero/grid/recent layout, search, pagination, details page.
- **Favorites** – Toggle on news cards and details; list on profile; persisted via `FavoritesManager`.
- **Profile** – User info, edit profile (language, timezone, date format, address).
- **Response balloon** – On news details, when toggling favorite, a custom overlay balloon shows feedback at the top (e.g. "Você favoritou esta Notícia").

---

## Routing

| Route            | Screen        |
|------------------|---------------|
| `/`              | SplashPage    |
| `/login`         | LoginPage     |
| `/news`          | NewsPage      |
| `/news/details`  | NewsDetailsPage (extra: news + bloc) |
| `/profile`       | ProfilePage   |
| `/edit-profile`  | EditProfilePage |

---

## What's been done (recent)

- **Response balloon** – Favorites feedback on news details via custom overlay balloon (and SnackBar where used).
- **Comments** – All comments in `lib/` translated to English; decorative/section comments removed.
- **Cleanup** – Unused files and folders removed:
  - `lib/core/config/app_config.dart`
  - `lib/features/profile/presentation/widgets/profile_data_section.dart`
  - `lib/features/news/presentation/widgets/related_news_list.dart`
  - `lib/features/user/presentation/bloc/user_event.dart` (logic kept in `user_bloc.dart`)
- **Branch** – `fix/response-balloon-and-comments-cleanup` with the above changes.

---

## Tests

Tests live under `test/` and mirror `lib/` (e.g. `test/features/auth/`, `test/features/news/`). Run with:

```bash
flutter test
```

---

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [BLoC library](https://bloclibrary.dev/)
- [GoRouter](https://pub.dev/packages/go_router)
