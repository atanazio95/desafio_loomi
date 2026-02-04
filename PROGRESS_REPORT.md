# Relatório de Progresso – Desafio Flutter Loomi

Progress report document para o desenvolvimento do app Nortus, conforme solicitado no desafio.

**Repositório:** [https://github.com/atanazio95/desafio_loomi](https://github.com/atanazio95/desafio_loomi)

---

## 1. Link da plataforma de gestão

**Gestão de backlog e atividades:**  
[Trello – Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)

---

## 2. Como organizei demandas e atividades

- **Estrutura do projeto:** Adotei Clean Architecture por feature (`auth`, `news`, `profile`, `user`), com camadas **data** (datasources, models, repositories), **domain** (entities, use cases) e **presentation** (BLoC, pages, widgets). Isso ajudou a separar responsabilidades e manter o código testável.
- **Gestão de tarefas:** Usei Trello para listar features obrigatórias (Splash, Login/Register, Home, Details, Favorites, Profile) e itens opcionais (lista de favoritos no perfil, responsividade, testes). Cada card representava uma entrega ou conjunto de tarefas relacionadas.
- **Comunicação assíncrona:** Decisões técnicas e escopo foram registrados no README, DELIVERY_CHECKLIST.md e comentários no código (em inglês), para que revisores possam entender o que foi feito sem explicação verbal.

---

## 3. Como priorizei entregas

1. **Primeiro:** Fluxo de autenticação (Splash, Login, Register, "manter-me logado" com SharedPreferences) e navegação básica (GoRouter), para ter o esqueleto do app e rotas protegidas.
2. **Segundo:** Consumo da API de notícias (lista paginada, detalhes, notícias relacionadas) e busca local, garantindo que os dados fossem exibidos corretamente.
3. **Terceiro:** Favoritos em memória, integrados com cards e tela de detalhes, e feedback visual (balão/snackbar).
4. **Quarto:** Perfil do usuário (GET/PATCH para `/user`), tela de edição com campos mockados (idioma, data, timezone) e atraso de 3 segundos na "atualização".
5. **Por fim:** Ajustes de UX (responsividade, footer fixo, loadings, tratamento de erros com Snackbar), documentação (README, CONTRIBUTING, DELIVERY_CHECKLIST) e testes unitários em uma branch dedicada.

A prioridade sempre foi atender o escopo obrigatório do PDF antes dos itens opcionais.

---

## 4. Principais dificuldades e como lidar com elas

- **Integração com a API mockada:** A estrutura JSON (ex: `image.src`, `authors[0].name`, `relatedNews`) exigiu mapeamento cuidadoso nos models. Solução: criar um `NewsModel.fromJson` flexível e tratar campos opcionais com defaults.
- **Estado global de favoritos:** Manter favoritos consistentes entre lista, detalhes e perfil sem acoplamento forte. Solução: centralizar em `NewsBloc` (lista em memória + toggle) e, quando aplicável, um serviço local para persistência opcional.
- **Layout responsivo e footer:** Em telas menores (ex: teclado aberto na busca), o footer subia com o conteúdo. Solução: usar `LayoutBuilder` + `ConstrainedBox` com altura mínima e mostrar o footer apenas quando a lista estiver pronta, mantendo o footer no final do body ou na parte inferior da tela quando a lista for curta.
- **Testes com mocktail:** Usar `any()` para parâmetros como `AuthEntity` e `UserEntity` causava erros devido à falta de fallback. Solução: `setUpAll` com `registerFallbackValue(entity)` e corrigir `const` onde o construtor não era const (ex: `ServerFailure()`, eventos do BLoC).

---

## 5. O que faria diferente com mais tempo ou em um projeto real

- **Relatórios e métricas:** Manter um changelog ou document "o que foi entregue por sprint" desde o início, facilitando o relatório de progresso e revisão.
- **Testes:** Cobrir desde o início (repositories, use cases, BLoCs) com TDD ou em paralelo à feature, em vez de concentrar testes no final.
- **Filtros e cache:** Implementar filtro de categoria na lista e cache local (ex: notícias e imagens) para acesso offline, conforme descrito nos itens opcionais do desafio.
- **CI:** Em um projeto real, configuraria um pipeline (ex: GitHub Actions) para executar `flutter analyze` e `flutter test` em cada PR.
- **Design system:** Extrair cores, tipografia e espaçamento em um único tema (já há passos nessa direção com `Responsive` e `AppColors`) para facilitar manutenção e alinhamento com Figma.

---

## 6. Progresso recente (revisão de código e correções)

Após a entrega principal, foram feitos os seguintes ajustes:

- **API:** URL base definida como `https://le43j.wiremockapi.cloud/`. Removido fallback mock para a lista de notícias; em caso de falha da API, o app retorna `ServerFailure`. Detalhes de notícias: `GET /news/{id}/details` é sempre chamado ao abrir uma notícia; a tela é construída inteiramente a partir do corpo da resposta (estados de loading e erro; suporta API mockada que retorna o mesmo objeto para qualquer id). `NewsModel.fromJson` mapeia `newsResume` para o endpoint de detalhes. Categorias: `GET /categories` retorna `{ "data": ["Ciência", "Educação", "Esportes", ...] }`; o drawer é preenchido com essa lista.
- **Cache:** **SharedPreferences** usado para cachear lista e detalhes de notícias (além de "manter-me logado" e favoritos). **cached_network_image** usado para todas as imagens de notícias (lista, detalhes, relacionadas). Sem Hive; apenas SharedPreferences e cache de imagens.
- **Editar perfil:** Adicionado footer no final do scroll (largura total); espaçamento responsivo entre último conteúdo e footer (`Responsive.footerTopSpacing`); campos do formulário e botão cancelar com borda 0.75px #0D478C; cor do texto do input do formulário #666666 (`AppColors.formText`); botão e seta de voltar com Inter Medium 14px, cor #0D478C.
- **Login:** Campo de email com fundo branco e borda cinza de 1px (#B4B4B4); label em cinza; email maxLength 64; contador de caracteres oculto. Campos de senha usam a label apenas como placeholder (hintText), para que a label não flutue acima do campo ao digitar.
- **Notícias:** Aumentado espaçamento entre o último "Ver mais" (LoadMoreButton) e o footer (responsivo); cards da lista de notícias recentes com borda inferior de 1px #B4B4B4.
- **Feature de categorias:** Nova feature para o drawer: `CategoriesRemoteDataSource` (GET /categories), repository, `GetCategoriesUseCase`, `CategoriesCubit`. Drawer carrega categorias ao abrir; mostra indicador de loading, mensagem de erro ou lista de nomes de categorias.
- **Página de detalhes de notícias:** Sempre busca detalhes por id; conteúdo (título, imagem, resumo, descrição, notícias relacionadas, tags) vem apenas da resposta da API. Bloco "Resumo NortusAI" com ícone `icon_details_nortus.png`, título e texto de resumo. Estado inclui `isLoadingDetails`, `detailsError` e opcional `lastRequestedDetailsId`; estado de erro mostra "Tentar novamente" para retry.
- **Testes:** Testes unitários para auth, news, user (repositories, use cases, BLoCs) e core (ex: Responsive). Todas as descrições e nomes de grupos traduzidos para **inglês**. Testes de BLoC reorganizados com subgrupos por evento (ex: GetNewsEvent, LoadNewsDetailsEvent, Login, Register). Testes do NewsBloc atualizados para injetar e mockar `GetNewsDetailsUseCase` e cobrir sucesso e falha de LoadNewsDetails. Grupo de teste do modelo Auth renomeado para AuthModel; testes de Responsive agrupados (horizontalPadding, imageHeights, logo).
- **Código:** Comentários no código revisados e mantidos em inglês (ex: init de detalhes de notícias, bloco Resumo NortusAI, `lastRequestedDetailsId` no estado).
- **Docs:** README e relatório de progresso atualizados; estrutura do projeto inclui feature `categories`; tabela de documentação e índice `docs/` para análises de arquitetura e responsividade. DELIVERY_CHECKLIST atualizado com status das features, nota sobre URL base e itens opcionais (cache e categorias).

---

*Este relatório complementa [DELIVERY_CHECKLIST.md](DELIVERY_CHECKLIST.md) e o [README.md](README.md) do projeto.*
