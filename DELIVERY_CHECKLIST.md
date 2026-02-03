# Delivery checklist – Loomi Flutter Challenge

Use this document to verify what must be delivered according to the challenge PDF.

---

## Deadline and submission

| Item | Detail |
|------|--------|
| **Deadline** | 03/02/2026 at 14:00 |
| **Format** | Full project as **ZIP** |
| **Submit to** | Email **processoseletivo@loomi.com.br** |

---

## 1. Progress report (separate document or attachment)

**Report document:** [PROGRESS_REPORT.md](PROGRESS_REPORT.md)

Deliver a **Progress Report** containing:

- [ ] **Link to the management platform** used for the backlog: [Trello - Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)
- [ ] **How you organized** demands and activities.
- [ ] **How you prioritized** deliveries.
- [ ] **Main difficulties** and how you dealt with them.
- [ ] **What you would do differently** with more time or in a real project context.

---

## 2. Git workflow (#Essential)

| Item | What to do |
|------|------------|
| **Versioning** | Use Git throughout the project. |
| **Commits** | **Descriptive** messages (recommended: Conventional Commits – see [CONTRIBUTING.md](CONTRIBUTING.md)). |
| **Branches** | **One branch per feature**. |
| **Pull Requests** | Open **PR to the main branch** (e.g. `develop` or `main`) when finishing each feature. |

Before sending the ZIP, verify:

- [ ] Use of branches per feature.
- [ ] PR(s) opened/merged to the main branch (develop or equivalent).

---

## 3. Technical deliverables (challenge scope)

### Required features

| Feature | What it must have | Status |
|---------|-------------------|--------|
| **Splash Screen** | Simple initial screen for app loading. | |
| **Register and Login** | Create account and authenticate; **"Keep me logged in"** option. | |
| **Home screen** | News list with **infinite pagination**; **text search** (local, in-memory data); each item with **title, image and short description**. | |
| **Details screen** | **Title, image and full content**; **"Related news"** section at the bottom. | |
| **Favorites** | Mark/unmark favorite **in memory** (no persistence across runs). | |
| **Profile screen** | Display user data and **edit** (name, email, etc. — **no photo**). | |

### Rules and important details

| Rule | Requirement |
|------|-------------|
| **API** | Requests to `https://flutter-challenge.wiremockapi.cloud/` (mocked). |
| **Design** | Follow the provided **Figma** (Nortus). |
| **"Forgot password" / "Continue without account"** | **Do not implement** the flows; only **have the option on screen**. |
| **Language / date / timezone** | **Mocked** list with a few options for illustration. |
| **Search** | **Local only**, on already loaded data (no new request). |
| **Profile edit** | **Simulate** update locally; **3 second delay** on "response". |
| **Favorites** | **In memory** while in use; do not persist across runs. |
| **Keep me logged in** | Use **local persistence** (e.g. SharedPreferences). |
| **Validation** | **Password**: at least 8 characters, at least one letter and one number. **Email**: valid format (e.g. user@domain.com). |
| **Errors and loading** | **Snackbar** for errors (style similar to favorites success); **loadings** during requests; **fixed 3 second delay** to simulate API response. |

### Optional features (differentiators)

The features below were not implemented because the challenge deadline was reached; the required scope was prioritized.

- [ ] **Favorites-only screen** (list of favorited news only).
- [ ] **Category filters** (e.g. Technology, Sports, World).
- [ ] **Local cache** (optional): store news/images for partial offline access.

---

## 4. APIs used (challenge reference)

| Method | Route | Use |
|--------|------|-----|
| GET | `/news?page={page}` | Paginated news list. |
| GET | `/news/{id}/details` | News details. |
| GET | `/categories` | Categories list. |
| POST | `/auth` | Login (e.g. `{"login":"desafioLoomi","password":"senha123"}`). |
| GET | `/user` | User data. |
| PATCH | `/user` | Profile update (simulate with 3s delay). |

Base URL: `https://flutter-challenge.wiremockapi.cloud`

---

## 5. Documentation and communication (evaluated)

| Item | Where in the project |
|------|----------------------|
| **README** with setup and main decisions | [README.md](README.md) |
| **Clear commits** | Standard in [CONTRIBUTING.md](CONTRIBUTING.md) |
| **Clear Pull Requests** | Guide in [CONTRIBUTING.md](CONTRIBUTING.md) |

Challenge recommendations (already reflected in the project):

- Conventional Commits.
- Code in **English** (commits, variables, comments).
- Clean, readable, well-structured code.
- Responsiveness and good UX practices (pagination, loadings).

---

## 6. Summary before submitting

- [ ] Progress Report ready (with backlog link, prioritization, difficulties, and improvements).
- [ ] Git with descriptive commits, branches per feature, and PR(s) to the main branch.
- [ ] All required features implemented and checked.
- [ ] Rules met (API, Figma, validation, 3s delay, in-memory favorites, keep me logged in with persistence).
- [ ] README and CONTRIBUTING reviewed.
- [ ] Project zipped and sent to **processoseletivo@loomi.com.br** by **03/02/2026 at 14:00**.

---

*Document based on the "Desafio Flutter | Loomi" (PDF).*
