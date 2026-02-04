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

## 6. Recent progress (code review and corrections)

After the main delivery, the following adjustments were made:

- **API:** Base URL set to `https://le43j.wiremockapi.cloud/`. Removed mock fallback for the news list; on API failure the app returns `ServerFailure`. News details: `GET /news/{id}/details` is always called when opening a news item; the screen is built entirely from the response body (loading and error states; supports mocked API that returns the same object for any id). `NewsModel.fromJson` maps `newsResume` for the details endpoint. Categories: `GET /categories` returns `{ "data": ["Ciência", "Educação", "Esportes", ...] }`; the drawer is filled with this list.
- **Cache:** **SharedPreferences** used to cache the news list and news details (in addition to “keep me logged in” and favorites). **cached_network_image** used for all news images (list, details, related). No Hive; only SharedPreferences and image cache.
- **Edit profile:** Added footer at the end of the scroll (full-width); responsive spacing between last content and footer (`Responsive.footerTopSpacing`); form fields and cancel button with border 0.75px #0D478C; form input text color #666666 (`AppColors.formText`); back button and arrow with Inter Medium 14px, color #0D478C.
- **Login:** Email field with white background and 1px gray border (#B4B4B4); label in gray; email maxLength 64; character counter hidden. Password fields use the label only as placeholder (hintText), so the label does not float above the field when typing.
- **News:** Increased spacing between the last “Ver mais” (LoadMoreButton) and the footer (responsive); recent-news list cards with bottom border 1px #B4B4B4.
- **Categories feature:** New feature for the drawer: `CategoriesRemoteDataSource` (GET /categories), repository, `GetCategoriesUseCase`, `CategoriesCubit`. Drawer loads categories on open; shows loading indicator, error message, or list of category names.
- **News details page:** Always fetches details by id; content (title, image, summary, description, related news, tags) comes only from the API response. "Resumo NortusAI" block with icon `icon_details_nortus.png`, title and summary text. State includes `isLoadingDetails`, `detailsError` and optional `lastRequestedDetailsId`; error state shows "Tentar novamente" to retry.
- **Tests:** Unit tests for auth, news, user (repositories, use cases, BLoCs) and core (e.g. Responsive). All test descriptions and group names translated to **English**. BLoC tests reorganized with subgroups by event (e.g. GetNewsEvent, LoadNewsDetailsEvent, Login, Register). NewsBloc tests updated to inject and mock `GetNewsDetailsUseCase` and to cover LoadNewsDetails success and failure. Auth model test group renamed to AuthModel; Responsive tests grouped (horizontalPadding, imageHeights, logo).
- **Code:** In-code comments reviewed and kept in English (e.g. news details init, Resumo NortusAI block, `lastRequestedDetailsId` in state).
- **Docs:** README and progress report updated; project structure includes `categories` feature; documentation table and `docs/` index for architecture and responsiveness analyses. DELIVERY_CHECKLIST updated with feature status, base URL note, and optional items (cache and categories).

---

*This report complements [DELIVERY_CHECKLIST.md](DELIVERY_CHECKLIST.md) and the project [README.md](README.md).*
