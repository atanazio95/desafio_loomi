# Architecture Analysis

Analysis of the project's Clean Architecture implementation and identified issues.

---

## What is correct

1. **Layers and dependencies**
   - **Domain** does not depend on Data or Presentation.
   - **Data** implements domain repositories and uses domain entities (or models extending entities).
   - **Presentation** depends on Domain (entities, use cases) and BLoC; it does not import data layer directly (except via DI in `main`).
   - Use cases depend only on repository interfaces (domain).

2. **Feature structure**
   - Features are well separated: `auth`, `news`, `profile`, `user`.
   - Each feature has clear `data` / `domain` / `presentation` split.
   - Models extend entities (e.g. `NewsModel extends NewsEntity`, `AuthModel extends AuthEntity`).

3. **Dependency injection**
   - GetIt is used consistently; repositories and use cases are injected.
   - BLoCs receive use cases (and in one case `FavoritesManager`), not repositories directly (except `AuthBloc` which also keeps `AuthRepository` for a tip comment).

4. **Routing**
   - GoRouter is configured in `core`; routes are clear and pages receive only necessary data (e.g. `news` for details).

5. **Errors**
   - Use of `dartz` `Either<Failure, T>` and `Failure` in domain/repositories is a common and acceptable pattern.

---

## Issues found

### 1. Critical: Favorites – two sources of truth and no persistence

**Problem**

- **NewsBloc** keeps `savedNews` only in memory and updates it on `ToggleFavoriteHome`. It does **not** use `FavoritesManager`.
- **NewsDetailsBloc** uses **FavoritesManager** (SharedPreferences) to persist favorites, but this bloc is **never provided** in the widget tree. The details page uses only **NewsBloc** for the favorite icon and for `_onFavoriteToggle` (dispatches `ToggleFavoriteHome`).
- So in practice:
  - All favorite toggles (list, details, profile) only update **NewsBloc.savedNews** (in-memory).
  - **FavoritesManager** is never used by the UI; **NewsDetailsBloc** is registered in DI but no screen uses it.
  - Favorites are lost on app restart.

**Recommendation**

- Choose a single source of truth: **FavoritesManager** (persistence).
- Make **NewsBloc** depend on **FavoritesManager**: on init (or when loading news), load `savedNews` from `FavoritesManager.getSavedNews()`; on `ToggleFavoriteHome`, call `FavoritesManager.toggleFavorite(...)` and then update state from it (or reload saved list).
- Optionally remove **NewsDetailsBloc** if you keep using **NewsBloc** for the details screen, or start providing **NewsDetailsBloc** for the details route and use it (and FavoritesManager) there and keep list/profile in sync with the same manager.

---

### 2. Critical: Core depends on a feature

**Problem**

- **FavoritesManager** lives in `core/services/` but imports:
  - `features/news/domain/entities/news_entity.dart`
  - `features/news/data/models/news_model.dart`
- So **core** depends on **features/news**. In Clean Architecture, core should not depend on features.

**Recommendation**

- Move **FavoritesManager** into the **news** feature, e.g.:
  - `lib/features/news/data/datasources/favorites_local_datasource.dart`, or
  - `lib/features/news/domain/services/favorites_service.dart` (interface in domain, implementation in data that uses SharedPreferences and NewsModel/Entity).
- Alternatively, define in core a minimal abstraction (e.g. “storage for favorite IDs” or a generic callback) and let the news feature implement it; that requires a bit more design but keeps core independent.

---

### 3. Medium: AuthRepositoryImpl and SharedPreferences

**Problem**

- **AuthRepositoryImpl** calls `SharedPreferences.getInstance()` inside `login`, `logout`, and `checkAuthStatus` instead of receiving **SharedPreferences** via constructor.
- This makes the repository harder to test (you cannot easily inject a mock) and duplicates access to a global singleton that is already injected into **AuthRemoteDataSourceImpl**.

**Recommendation**

- Inject **SharedPreferences** into **AuthRepositoryImpl** (e.g. from GetIt) and use it instead of `getInstance()`.
- Keep a single place that owns “session” persistence (either repository or datasource), not both with separate `getInstance()` calls.

---

### 4. ~~Minor: UserRepository import style~~ (Fixed)

- **user_repository.dart** now uses package import for `core/errors/failures.dart`.

---

### 5. Minor: NewsDetailsBloc unused

**Problem**

- **NewsDetailsBloc** is registered in GetIt and uses **FavoritesManager** and **GetNewsDetailsUseCase**, but no route or page provides this bloc. The details screen uses only **NewsBloc** and the passed **news** entity.

**Recommendation**

- Either:
  - Use **NewsDetailsBloc** on the details route (e.g. `BlocProvider` in the route builder) and refactor the details page to use it for loading details and favorites, and sync list/profile with **FavoritesManager** via **NewsBloc**, or
  - Remove **NewsDetailsBloc** and **GetNewsDetailsUseCase** if you do not need a separate “details loading” flow and rely only on **NewsBloc** + **FavoritesManager** as above.

---

### 6. Minor: Two Dio instances

**Problem**

- **DioClient** is registered and used by auth and news datasources.
- A raw **Dio** instance is also registered for **UserDataSourceImpl**.
- So there are two different HTTP clients; base URL and interceptors might differ.

**Recommendation**

- Prefer a single HTTP client (e.g. **DioClient** or a single **Dio** instance configured in one place) and inject it into all datasources that need it, including **UserDataSourceImpl**.

---

## Summary table

| Issue                                   | Status   | Layer / component        |
|----------------------------------------|----------|---------------------------|
| Favorites only in memory (by design)   | OK       | News feature / NewsBloc  |
| Core depends on news (FavoritesManager) | Fixed    | FavoritesManager moved to news |
| AuthRepositoryImpl uses getInstance()   | Fixed    | SharedPreferences injected |
| UserRepository relative import         | Fixed    | Package import used      |
| NewsDetailsBloc never provided         | Fixed    | Bloc removed             |
| Two Dio instances                      | Open     | Core DI (DioClient + raw Dio for User) |

**Remaining (optional):** Unify HTTP client: use a single Dio/DioClient for auth, news, and user datasources to avoid different base URLs or interceptors.
