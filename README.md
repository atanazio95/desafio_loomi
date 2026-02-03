# Nortus (Desafio Loomi Flutter)

Aplicativo Flutter para o desafio Loomi: feed de notícias com autenticação, perfil de usuário e favoritos.

> **Entrega do desafio:** use o checklist em [ENTREGA_DESAFIO.md](ENTREGA_DESAFIO.md) para conferir relatório de progresso, Git, escopo técnico e prazo. **Backlog:** [Trello - Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)

---

## Índice

- [Requisitos](#requisitos)
- [Setup do projeto](#setup-do-projeto)
- [Estrutura do projeto](#estrutura-do-projeto)
- [Principais decisões](#principais-decisões)
- [Rotas](#rotas)
- [Testes](#testes)
- [Commits e Pull Requests](#commits-e-pull-requests)

---

## Requisitos

- **Flutter** 3.8.1 ou superior (`sdk: ^3.8.1`)
- **Dart** 3.x

Verifique a instalação:

```bash
flutter doctor
```

---

## Setup do projeto

### 1. Clonar e instalar dependências

```bash
git clone <url-do-repositorio>
cd desafio_loomi_flutter
flutter pub get
```

### 2. Assets

Certifique-se de que os assets existam em:

- `assets/` e `assets/assets/` (incluindo `logo_shield.png` para a tela de login)

O `pubspec.yaml` já declara:

```yaml
flutter:
  assets:
    - assets/
    - assets/assets/
    - assets/assets/logo_shield.png
```

### 3. Rodar o app

```bash
# Desenvolvimento
flutter run

# Build release (exemplo Android)
flutter build apk
```

### 4. Análise e testes

```bash
flutter analyze
flutter test
```

---

## Estrutura do projeto

O código segue **Clean Architecture** por features, com camadas **data**, **domain** e **presentation**.

```
lib/
├── main.dart                 # Entry point, MultiBlocProvider, MaterialApp.router
├── core/                     # Recursos compartilhados
│   ├── config/               # Configurações (ex.: app_config)
│   ├── di/                   # Injeção de dependências (GetIt)
│   ├── errors/               # Failures e tratamento de erros
│   ├── network/              # Dio client
│   ├── router/               # GoRouter
│   ├── services/             # Serviços (ex.: FavoritesManager)
│   └── presentation/         # Componentes UI reutilizáveis
└── features/
    ├── auth/                 # Login, splash, estado de autenticação
    │   ├── data/             # Datasources, models, repository impl
    │   ├── domain/           # Entities, repository interface, use cases
    │   └── presentation/     # Bloc, pages (Splash, Login)
    ├── news/                 # Feed e detalhes de notícias
    ├── profile/              # Perfil e edição
    └── user/                 # Dados e atualização de usuário
```

Cada feature segue o padrão:

- **data**: implementações concretas (API, cache), models, `*RepositoryImpl`
- **domain**: entidades, contratos de repositório, use cases (regras de negócio)
- **presentation**: BLoC/Cubit, páginas e widgets

---

## Principais decisões

| Decisão | Motivo |
|--------|--------|
| **Clean Architecture por feature** | Separação clara de responsabilidades, testabilidade e evolução por módulo. |
| **BLoC (flutter_bloc)** | Estado previsível, fácil de testar e alinhado com o ecossistema Flutter. |
| **GetIt para DI** | Injeção de dependências leve, sem contexto de build; registros explícitos em `injection_container.dart`. |
| **GoRouter** | Rotas declarativas, deep linking e passagem de parâmetros (ex.: `extra` para `NewsEntity`). |
| **Dio** | Cliente HTTP configurável; instância compartilhada via `DioClient` no core. |
| **SharedPreferences** | Persistência simples para token/sessão e favoritos (FavoritesManager). |
| **dartz** | Uso de `Either<Failure, T>` nos use cases para representar falha ou sucesso de forma tipada. |
| **Equatable** | Igualdade em entities, states e events para evitar rebuilds desnecessários no BLoC. |
| **Splash em Flutter (sem native splash)** | Controle total do layout (texto "Nortus", delay, redirecionamento) e consistência entre plataformas. |
| **Cores e tipografia** | Uso de `google_fonts` (Inter) e cores do design (ex.: `#1876D2` na login). |

---

## Rotas

| Rota | Descrição |
|------|-----------|
| `/` | Splash (verifica auth e redireciona) |
| `/login` | Login (e-mail + fluxo “continuar sem conta”) |
| `/news` | Feed de notícias |
| `/news/details` | Detalhes da notícia (passa `NewsEntity` via `extra`) |
| `/profile` | Perfil do usuário |
| `/edit-profile` | Edição de perfil |

Configuração centralizada em `lib/core/router/router_config.dart`.

---

## Testes

Os testes espelham a estrutura de `lib/`:

- **data**: repositórios e models
- **domain**: use cases
- **presentation**: BLoCs (com `bloc_test` e `mocktail`)

```bash
flutter test
```

---

## Commits e Pull Requests

Para padronizar histórico e revisões, seguimos as convenções abaixo. Detalhes em [CONTRIBUTING.md](CONTRIBUTING.md).

### Mensagens de commit

- **Formato**: `tipo(escopo): descrição curta`
- **Tipos**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **Exemplos**:
  - `feat(auth): add login with email`
  - `fix(news): correct loading state in feed`
  - `docs: update README setup`

### Pull Requests

- Título claro e objetivo (pode seguir o mesmo padrão do commit).
- Descrição com: **o que** mudou, **por quê** e como **testar**.
- Referência a issue/tarefa quando existir.

---

## Referências

- [Flutter](https://docs.flutter.dev/)
- [flutter_bloc](https://bloclibrary.dev/)
- [GoRouter](https://pub.dev/documentation/go_router/latest/)
- [GetIt](https://pub.dev/packages/get_it)
