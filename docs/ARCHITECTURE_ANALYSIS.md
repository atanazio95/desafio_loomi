# Análise de Arquitetura

Análise da implementação de Clean Architecture do projeto e problemas identificados.

---

## O que está correto

1. **Camadas e dependências**
   - **Domain** não depende de Data ou Presentation.
   - **Data** implementa repositories do domain e usa entities do domain (ou models que estendem entities).
   - **Presentation** depende de Domain (entities, use cases) e BLoC; não importa a camada data diretamente (exceto via DI em `main`).
   - Use cases dependem apenas de interfaces de repository (domain).

2. **Estrutura de features**
   - Features estão bem separadas: `auth`, `news`, `profile`, `user`.
   - Cada feature tem divisão clara de `data` / `domain` / `presentation`.
   - Models estendem entities (ex: `NewsModel extends NewsEntity`, `AuthModel extends AuthEntity`).

3. **Injeção de dependências**
   - GetIt é usado consistentemente; repositories e use cases são injetados.
   - BLoCs recebem use cases (e em um caso `FavoritesManager`), não repositories diretamente (exceto `AuthBloc` que também mantém `AuthRepository` para um comentário de dica).

4. **Roteamento**
   - GoRouter está configurado em `core`; rotas são claras e pages recebem apenas dados necessários (ex: `news` para detalhes).

5. **Erros**
   - Uso de `dartz` `Either<Failure, T>` e `Failure` em domain/repositories é um padrão comum e aceitável.

---

## Problemas encontrados

### 1. Crítico: Favoritos – duas fontes de verdade e sem persistência

**Problema**

- **NewsBloc** mantém `savedNews` apenas em memória e atualiza em `ToggleFavoriteHome`. **Não** usa `FavoritesManager`.
- **NewsDetailsBloc** usa **FavoritesManager** (SharedPreferences) para persistir favoritos, mas este bloc **nunca é fornecido** na árvore de widgets. A página de detalhes usa apenas **NewsBloc** para o ícone de favorito e para `_onFavoriteToggle` (dispara `ToggleFavoriteHome`).
- Então na prática:
  - Todos os toggles de favorito (lista, detalhes, perfil) apenas atualizam **NewsBloc.savedNews** (em memória).
  - **FavoritesManager** nunca é usado pela UI; **NewsDetailsBloc** está registrado em DI mas nenhuma tela o usa.
  - Favoritos são perdidos ao reiniciar o app.

**Recomendação**

- Escolher uma única fonte de verdade: **FavoritesManager** (persistência).
- Fazer **NewsBloc** depender de **FavoritesManager**: no init (ou ao carregar notícias), carregar `savedNews` de `FavoritesManager.getSavedNews()`; em `ToggleFavoriteHome`, chamar `FavoritesManager.toggleFavorite(...)` e então atualizar estado a partir dele (ou recarregar lista salva).
- Opcionalmente remover **NewsDetailsBloc** se continuar usando **NewsBloc** para a tela de detalhes, ou começar a fornecer **NewsDetailsBloc** para a rota de detalhes e usá-lo (e FavoritesManager) lá e manter lista/perfil sincronizados com o mesmo manager.

---

### 2. Crítico: Core depende de uma feature

**Problema**

- **FavoritesManager** vive em `core/services/` mas importa:
  - `features/news/domain/entities/news_entity.dart`
  - `features/news/data/models/news_model.dart`
- Então **core** depende de **features/news**. Em Clean Architecture, core não deve depender de features.

**Recomendação**

- Mover **FavoritesManager** para a feature **news**, ex:
  - `lib/features/news/data/datasources/favorites_local_datasource.dart`, ou
  - `lib/features/news/domain/services/favorites_service.dart` (interface em domain, implementação em data que usa SharedPreferences e NewsModel/Entity).
- Alternativamente, definir em core uma abstração mínima (ex: "storage para IDs de favoritos" ou um callback genérico) e deixar a feature news implementá-la; isso requer um pouco mais de design mas mantém core independente.

---

### 3. Médio: AuthRepositoryImpl e SharedPreferences

**Problema**

- **AuthRepositoryImpl** chama `SharedPreferences.getInstance()` dentro de `login`, `logout` e `checkAuthStatus` em vez de receber **SharedPreferences** via construtor.
- Isso torna o repository mais difícil de testar (não é possível injetar um mock facilmente) e duplica acesso a um singleton global que já é injetado em **AuthRemoteDataSourceImpl**.

**Recomendação**

- Injetar **SharedPreferences** em **AuthRepositoryImpl** (ex: do GetIt) e usá-lo em vez de `getInstance()`.
- Manter um único lugar que possui persistência de "sessão" (seja repository ou datasource), não ambos com chamadas separadas de `getInstance()`.

---

### 4. ~~Menor: Estilo de import de UserRepository~~ (Corrigido)

- **user_repository.dart** agora usa import de package para `core/errors/failures.dart`.

---

### 5. Menor: NewsDetailsBloc não usado

**Problema**

- **NewsDetailsBloc** está registrado em GetIt e usa **FavoritesManager** e **GetNewsDetailsUseCase**, mas nenhuma rota ou page fornece este bloc. A tela de detalhes usa apenas **NewsBloc** e a entity **news** passada.

**Recomendação**

- Ou:
  - Usar **NewsDetailsBloc** na rota de detalhes (ex: `BlocProvider` no route builder) e refatorar a página de detalhes para usá-lo para carregar detalhes e favoritos, e sincronizar lista/perfil com **FavoritesManager** via **NewsBloc**, ou
  - Remover **NewsDetailsBloc** e **GetNewsDetailsUseCase** se não precisar de um fluxo separado de "carregamento de detalhes" e confiar apenas em **NewsBloc** + **FavoritesManager** como acima.

---

### 6. Menor: Duas instâncias de Dio

**Problema**

- **DioClient** está registrado e usado por datasources de auth e news.
- Uma instância bruta de **Dio** também está registrada para **UserDataSourceImpl**.
- Então há dois clientes HTTP diferentes; URL base e interceptors podem diferir.

**Recomendação**

- Preferir um único cliente HTTP (ex: **DioClient** ou uma única instância de **Dio** configurada em um lugar) e injetá-lo em todos os datasources que precisam dele, incluindo **UserDataSourceImpl**.

---

## Tabela resumo

| Problema                                   | Status   | Camada / componente        |
|----------------------------------------|----------|---------------------------|
| Favoritos apenas em memória (por design)   | OK       | Feature news / NewsBloc  |
| Core depende de news (FavoritesManager) | Corrigido    | FavoritesManager movido para news |
| AuthRepositoryImpl usa getInstance()   | Corrigido    | SharedPreferences injetado |
| Import relativo de UserRepository         | Corrigido    | Import de package usado      |
| NewsDetailsBloc nunca fornecido         | Corrigido    | Bloc removido             |
| Duas instâncias de Dio                      | Aberto     | Core DI (DioClient + Dio bruto para User) |

**Restante (opcional):** Unificar cliente HTTP: usar um único Dio/DioClient para datasources de auth, news e user para evitar URLs base ou interceptors diferentes.
