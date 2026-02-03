# Progress Report – Loomi Flutter Challenge

Tracking document for the Nortus app development, as requested in the challenge.

---

## 1. Management platform link

**Backlog and activity management:**  
[Trello – Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)

---

## 2. How I organized demands and activities

- **Project structure:** I adopted Clean Architecture by feature (`auth`, `news`, `profile`, `user`), with **data** (datasources, models, repositories), **domain** (entities, use cases), and **presentation** (BLoC, pages, widgets) layers. This helped separate concerns and keep the code testable.
- **Task management:** I used Trello to list required features (Splash, Login/Register, Home, Details, Favorites, Profile) and optional items (favorites list on profile, responsiveness, tests). Each card represented a deliverable or set of related tasks.
- **Async communication:** Technical decisions and scope were recorded in the README, DELIVERY_CHECKLIST.md, and code comments (in English), so reviewers can understand what was done without verbal explanation.

---

## 3. How I prioritized deliveries

1. **First:** Auth flow (Splash, Login, Register, "keep me logged in" with SharedPreferences) and basic navigation (GoRouter), to have the app skeleton and protected routes.
2. **Second:** News API consumption (paginated list, details, related news) and local search, ensuring data was displayed correctly.
3. **Third:** In-memory favorites, integrated with cards and details screen, and visual feedback (balloon/snackbar).
4. **Fourth:** User profile (GET/PATCH for `/user`), edit screen with mocked fields (language, date, timezone), and 3 second delay on "update".
5. **Finally:** UX adjustments (responsiveness, fixed footer, loadings, error handling with Snackbar), documentation (README, CONTRIBUTING, DELIVERY_CHECKLIST), and unit tests on a dedicated branch.

Priority was always to meet the PDF required scope before optional items.

---

## 4. Main difficulties and how I dealt with them

- **Integration with the mocked API:** The JSON structure (e.g. `image.src`, `authors[0].name`, `relatedNews`) required careful mapping in models. Solution: create a flexible `NewsModel.fromJson` and handle optional fields with defaults.
- **Global favorites state:** Keeping favorites consistent across list, details, and profile without tight coupling. Solution: centralize in `NewsBloc` (in-memory list + toggle) and, where applicable, a local service for optional persistence.
- **Responsive layout and footer:** On smaller screens (e.g. keyboard open on search), the footer moved up with the content. Solution: use `LayoutBuilder` + `ConstrainedBox` with min height and show the footer only when the list is ready, keeping the footer at the end of the body or at the bottom of the screen when the list is short.
- **Tests with mocktail:** Using `any()` for parameters like `AuthEntity` and `UserEntity` caused errors due to missing fallback. Solution: `setUpAll` with `registerFallbackValue(entity)` and fixing `const` where the constructor was not const (e.g. `ServerFailure()`, BLoC events).

---

## 5. What I would do differently with more time or in a real project

- **Reporting and metrics:** Keep a changelog or "what was delivered per sprint" document from the start, making the progress report and review easier.
- **Tests:** Cover from the beginning (repositories, use cases, BLoCs) with TDD or in parallel to the feature, instead of concentrating tests at the end.
- **Filters and cache:** Implement category filter on the list and local cache (e.g. news and images) for offline access, as described in the challenge optional items.
- **CI:** In a real project, I would set up a pipeline (e.g. GitHub Actions) to run `flutter analyze` and `flutter test` on every PR.
- **Design system:** Extract colors, typography, and spacing into a single theme (there are already steps in that direction with `Responsive` and `AppColors`) to ease maintenance and alignment with Figma.

---

*This report complements [DELIVERY_CHECKLIST.md](DELIVERY_CHECKLIST.md) and the project [README.md](README.md).*
