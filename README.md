# Nortus (Loomi Flutter Challenge)

Aplicativo Flutter para o Desafio Loomi: feed de notícias com autenticação, perfil de usuário e favoritos.

**Repositório:** [https://github.com/atanazio95/desafio_loomi](https://github.com/atanazio95/desafio_loomi)

> **Entrega do desafio:** use a checklist em [DELIVERY_CHECKLIST.md](DELIVERY_CHECKLIST.md) para verificar relatório de progresso, Git, escopo técnico e prazo. **Backlog:** [Trello - Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)

## Índice

- [Requisitos](#requisitos)
- [Configuração do projeto](#configuração-do-projeto)
- [Estrutura do projeto](#estrutura-do-projeto)
- [Principais decisões](#principais-decisões)
- [Rotas](#rotas)
- [Testes](#testes)
- [Documentação](#documentação)
- [Commits e Pull Requests](#commits-e-pull-requests)

---

## Requisitos

- **Flutter** 3.8.1 ou superior (`sdk: ^3.8.1`)
- **Dart** 3.x

Verifique sua configuração:

```bash
flutter doctor
```

---

## Configuração do projeto

### 1. Clonar e instalar dependências

```bash
git clone https://github.com/atanazio95/desafio_loomi.git
cd desafio_loomi_flutter
flutter pub get
```

### 2. Assets

Certifique-se de que os assets existem em:

- `assets/` e `assets/assets/` (ex: `logo_shield.png` para login, `icon_details_nortus.png` para detalhes de notícias, `menu_loomi.png`, `nortus.png`)

O `pubspec.yaml` já declara:

```yaml
flutter:
  assets:
    - assets/
    - assets/assets/
    - assets/assets/logo_shield.png
```

### 3. Executar o app

```bash
# Desenvolvimento
flutter run

# Build de release (ex: Android)
flutter build apk
```

### 4. Analisar e testar

```bash
flutter analyze
flutter test
```

---

## Estrutura do projeto

O código segue **Clean Architecture** por feature, com camadas **data**, **domain** e **presentation**.

```
lib/
├── main.dart                 # Ponto de entrada, MultiBlocProvider, MaterialApp.router
├── core/                      # Recursos compartilhados
│   ├── di/                    # Injeção de dependências (GetIt)
│   ├── errors/                # Failures e tratamento de erros
│   ├── network/               # Cliente Dio
│   ├── presentation/          # UI reutilizável (drawer, footer, app bar, headers)
│   ├── router/                # GoRouter
│   ├── theme/                 # Cores (app_colors) e responsividade (responsive, footerTopSpacing)
│   └── widgets/              # Widgets compartilhados de formulário/UI (FormLabel, AppDropdown, AppTextField, FormSectionHeader)
└── features/
    ├── auth/                  # Login, splash, estado de autenticação
    │   ├── data/              # Datasources, models, repository impl
    │   ├── domain/            # Entities, interface do repository, use cases
    │   └── presentation/      # Bloc, pages (Splash, Login), widgets (AuthTextFormField, AuthPrimaryButton, TabButton, FooterTextLink)
    ├── categories/            # Categorias do drawer da API
    │   ├── data/              # Datasource, repository impl
    │   ├── domain/            # Interface do repository, use case
    │   └── presentation/      # Cubit, state (usado pelo CustomDrawer)
    ├── news/                  # Feed de notícias e detalhes
    │   └── presentation/      # Bloc, pages, widgets (NewsCard, HeroNewsCard, GridNewsCard, RecentNewsCard, TagsSection, VerMaisButton, LoadMoreButton)
    ├── profile/               # Perfil e edição
    │   └── presentation/      # Pages, widgets (SectionTitle)
    └── user/                  # Dados do usuário e atualização
```

Cada feature segue:

- **data**: implementações concretas (API, cache), models, `*RepositoryImpl`
- **domain**: entities, contratos de repository, use cases (regras de negócio)
- **presentation**: BLoC/Cubit, pages e **widgets** (componentes de UI reutilizáveis extraídos das pages)

---

## Principais decisões

| Camada   | Biblioteca | Por quê |
|---------|---------|-----|
| **State** | **flutter_bloc** (BLoC) | Estado previsível, fácil de testar, separação clara de eventos e estados; alinhado com Clean Architecture. |
| **DI** | **get_it** | Service locator leve; sem build context; registro explícito em `injection_container.dart`; fácil de mockar em testes. |
| **Routing** | **go_router** | Rotas declarativas, deep linking, `extra` type-safe (ex: passar `NewsEntity` para detalhes). |
| **HTTP** | **dio** | Cliente configurável (timeouts, interceptors); usado para auth, news e user. |
| **FP / errors** | **dartz** (Either) | Sucesso/falha tipado em use cases (`Either<Failure, T>`); evita try/catch na lógica de negócio. |
| **Equality** | **equatable** | `==` e `hashCode` em entities, events e states; menos rebuilds e asserções de teste mais simples. |
| **Fonts** | **google_fonts** (Inter, Space Grotesk) | Compatível com Figma (Nortus); tipografia consistente sem bundling manual de fontes. |
| **Storage** | **shared_preferences** | Persistir "manter-me logado", favoritos e **cache de notícias** (lista e detalhes). API simples de chave-valor; cache evita requisições redundantes e melhora a performance percebida. |
| **Images** | **cached_network_image** | Carregar e cachear imagens de rede para notícias (lista, detalhes, relacionadas). Reduz largura de banda e acelera visitas repetidas. |

### Tema core: cores e responsividade

- **`lib/core/theme/app_colors.dart`** – Paleta de cores central do app (primary, outline, error, success, text, surface, border) para botões, AppBar, SnackBars e telas; mantém a UI alinhada com Figma e evita cores hardcoded.
- **`lib/core/theme/responsive.dart`** – Helpers de layout responsivo baseados em `MediaQuery`: padding horizontal, alturas de imagem (hero, grid, card, thumbnail) e tamanho do logo em headers. Usado em lista de notícias, detalhes, perfil e headers compartilhados para adaptar a diferentes tamanhos de tela.

---

## Rotas

| Rota | Descrição |
|-------|-------------|
| `/` | Splash (verifica auth e redireciona) |
| `/login` | Login (email + fluxo "continuar sem conta") |
| `/news` | Feed de notícias |
| `/news/details` | Detalhes da notícia (passa `NewsEntity` via `extra`) |
| `/profile` | Perfil do usuário |
| `/edit-profile` | Editar perfil |

A configuração está centralizada em `lib/core/router/router_config.dart`.

---

## Testes

Os testes ficam em `test/` e espelham `lib/` (ex: `test/features/auth/`, `test/features/news/`, `test/features/user/`, `test/core/`). **As descrições e nomes de grupos dos testes estão em inglês.** A estrutura inclui:

- **Bloc/Cubit:** subgrupos por evento (ex: GetNewsEvent, LoadNewsDetailsEvent, Login, Register).
- **Use cases e repositories:** um grupo por classe; descrições indicam o resultado esperado (ex: "returns Right when … succeeds").
- **Models:** comportamento de fromJson/toJson e subclasse de entity.

Execute todos os testes:

```bash
flutter test
```

Execute um arquivo específico (ex: `news_bloc_test.dart`):

```bash
flutter test test/features/news/presentation/bloc/news_bloc_test.dart
```

---

## Documentação

| Documento | Descrição |
|----------|-------------|
| [CONTRIBUTING.md](CONTRIBUTING.md) | Convenções de commit e PR. |
| [DELIVERY_CHECKLIST.md](DELIVERY_CHECKLIST.md) | Checklist de entrega do desafio (prazo, escopo, APIs). |
| [PROGRESS_REPORT.md](PROGRESS_REPORT.md) | Relatório de progresso (backlog, priorização, dificuldades). |
| [docs/](docs/) | Análises adicionais: [Arquitetura](docs/ARCHITECTURE_ANALYSIS.md), [Responsividade](docs/RESPONSIVENESS_ANALYSIS.md). |

---

## O que foi feito (recente)

- **Refatoração de widgets** – UI extraída em widgets reutilizáveis: **core** (FormLabel, AppDropdown, AppTextField, FormSectionHeader, FeedbackBalloon); **auth** (AuthTextFormField, AuthPrimaryButton, TabButton, FooterTextLink); **news** (HeroNewsCard, GridNewsCard, RecentNewsCard, TagsSection, VerMaisButton, LoadMoreButton); **profile** (SectionTitle). As pages usam esses componentes em vez de builders inline ou privados.
- **API** – URL base: `https://le43j.wiremockapi.cloud/`. Lista e detalhes de notícias da API; sem fallback mock. Erros retornam `ServerFailure`. Detalhes de notícias: `GET /news/{id}/details`; o corpo da resposta é usado para construir a tela completa de detalhes (estados de loading e erro; funciona com API mockada que retorna o mesmo objeto para qualquer id). Categorias: `GET /categories` retorna `{ "data": ["Ciência", "Educação", ...] }` e preenche o drawer.
- **Cache** – **SharedPreferences** para lista e detalhes de notícias (reduz chamadas repetidas à API). **cached_network_image** para todas as imagens de notícias (lista, detalhes, relacionadas). Sem Hive ou outro banco local; apenas SharedPreferences + cache de imagens.
- **Editar perfil** – Footer no final do scroll (largura total); espaçamento responsivo acima do footer (`Responsive.footerTopSpacing`); bordas e cor do texto do formulário (#0D478C, #666666 em `AppColors`); botão/seta de voltar Inter Medium 14px #0D478C.
- **Login** – Campo de email: fundo branco, borda cinza de 1px (#B4B4B4), label em cinza; maxLength 64 para email; contador de caracteres oculto. Campos de senha: label apenas como placeholder (hintText), sem label flutuante.
- **Notícias** – Espaçamento responsivo entre "Ver mais" / LoadMoreButton e footer; cards de notícias recentes com borda inferior de 1px #B4B4B4.
- **Categorias (drawer)** – Feature: datasource, repository, use case, `CategoriesCubit`. Drawer carrega categorias da API ao abrir; mostra loading/erro ou lista de nomes de categorias.
- **Detalhes de notícias** – Sempre busca `GET /news/{id}/details` ao abrir uma notícia; a tela é construída apenas a partir da resposta da API. Bloco "Resumo NortusAI" com ícone `icon_details_nortus.png`, título e resumo. Notícias relacionadas e tags da resposta.
- **Testes** – Testes unitários para auth, news, user (repositories, use cases, BLoCs), além de core (ex: Responsive). Descrições e nomes de grupos em **inglês**; testes de BLoC agrupados por evento (GetNewsEvent, LoadNewsDetailsEvent, etc.). Testes do NewsBloc incluem mock de `GetNewsDetailsUseCase` e casos de sucesso/falha de LoadNewsDetails.
- **Código** – Comentários no código mantidos em inglês.

---

## Adendos

- **Persistência e cache:** "Manter-me logado" e favoritos usam **SharedPreferences**. Lista e detalhes de notícias também são cacheados em SharedPreferences para reduzir chamadas à API. Imagens de rede são cacheadas com **cached_network_image** (sem Hive ou outro banco local).
- **Colors file (`app_colors.dart`):** Centraliza a paleta do app (primary, outline, error, success, text, surface, border) para botões, AppBar, SnackBars e telas, mantendo o visual alinhado com Figma e evitando valores de cor espalhados no código.
- **Responsiveness file (`responsive.dart`):** Fornece funções que calculam padding horizontal, alturas de imagem (hero, grid, card, thumbnail) e tamanho do logo a partir do tamanho da tela (`MediaQuery`), para que listas, detalhes e headers se adaptem a diferentes dispositivos.
- **Escopo e prazo:** Outras features (ex: tela apenas de favoritos, filtros de categoria, cache local completo para acesso offline) não foram implementadas porque o prazo do desafio foi atingido; o que foi entregue cobre o escopo obrigatório e parte dos itens opcionais.

---

## Commits e Pull Requests

Para manter histórico e revisões consistentes, seguimos as convenções abaixo. Detalhes em [CONTRIBUTING.md](CONTRIBUTING.md).

### Mensagens de commit

- **Formato**: `type(scope): descrição curta`
- **Tipos**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **Exemplos**:
  - `feat(auth): add login with email`
  - `fix(news): correct loading state in feed`
  - `docs: update README setup`

### Pull Requests

- Título claro e objetivo (pode seguir o mesmo padrão do commit).
- Descrição com: **o que** mudou, **por quê** e **como testar**.
- Referência a issue/tarefa quando aplicável.

---

## Referências

- [Flutter](https://docs.flutter.dev/)
- [flutter_bloc](https://bloclibrary.dev/)
- [GoRouter](https://pub.dev/documentation/go_router/latest/)
- [GetIt](https://pub.dev/packages/get_it)
