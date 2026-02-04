# Checklist de entrega – Desafio Flutter Loomi

Use este document para verificar o que deve ser entregue de acordo com o PDF do desafio.

---

## Prazo e submissão

| Item | Detalhe |
|------|--------|
| **Prazo** | 03/02/2026 às 14:00 |
| **Formato** | Projeto completo como **ZIP** |
| **Enviar para** | Email **processoseletivo@loomi.com.br** |

---

## 1. Relatório de progresso (separate document ou anexo)

**Report document:** [PROGRESS_REPORT.md](PROGRESS_REPORT.md)

Entregar um **Relatório de Progresso** contendo:

- [ ] **Link para a plataforma de gestão** usada para o backlog: [Trello - Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)
- [ ] **Como você organizou** demandas e atividades.
- [ ] **Como você priorizou** entregas.
- [ ] **Principais dificuldades** e como você lidou com elas.
- [ ] **O que você faria diferente** com mais tempo ou em um contexto de projeto real.

---

## 2. Fluxo Git (#Essencial)

| Item | O que fazer |
|------|------------|
| **Versionamento** | Usar Git durante todo o projeto. |
| **Commits** | Mensagens **descritivas** (recomendado: Conventional Commits – veja [CONTRIBUTING.md](CONTRIBUTING.md)). |
| **Branches** | **Uma branch por feature**. |
| **Pull Requests** | Abrir **PR para a branch principal** (ex: `develop` ou `main`) ao finalizar cada feature. |

Antes de enviar o ZIP, verifique:

- [ ] Uso de branches por feature.
- [ ] PR(s) abertos/mergeados para a branch principal (develop ou equivalente).

---

## 3. Entregas técnicas (escopo do desafio)

### Features obrigatórias

| Feature | O que deve ter | Status |
|---------|-------------------|--------|
| **Splash Screen** | Tela inicial simples para carregamento do app. | Concluído |
| **Cadastro e Login** | Criar conta e autenticar; opção **"Manter-me logado"**. | Concluído |
| **Tela inicial** | Lista de notícias com **paginação infinita**; **busca de texto** (local, dados em memória); cada item com **título, imagem e descrição curta**. | Concluído |
| **Tela de detalhes** | **Título, imagem e conteúdo completo**; seção **"Notícias relacionadas"** na parte inferior. | Concluído |
| **Favoritos** | Marcar/desmarcar favorito **em memória** (sem persistência entre execuções). | Concluído (em memória + persistência opcional via SharedPreferences) |
| **Tela de perfil** | Exibir dados do usuário e **editar** (nome, email, etc. — **sem foto**). | Concluído |

### Regras e detalhes importantes

| Regra | Requisito |
|------|-------------|
| **API** | Requisições para uma API WireMock (mockada). **Este projeto usa** `https://le43j.wiremockapi.cloud/` (veja README). |
| **Design** | Seguir o **Figma** fornecido (Nortus). |
| **"Esqueci a senha" / "Continuar sem conta"** | **Não implementar** os fluxos; apenas **ter a opção na tela**. |
| **Idioma / data / timezone** | Lista **mockada** com algumas opções para ilustração. |
| **Busca** | **Apenas local**, em dados já carregados (sem nova requisição). |
| **Edição de perfil** | **Simular** atualização localmente; **atraso de 3 segundos** na "resposta". |
| **Favoritos** | **Em memória** durante o uso; não persistir entre execuções. |
| **Manter-me logado** | Usar **persistência local** (ex: SharedPreferences). |
| **Validação** | **Senha**: pelo menos 8 caracteres, pelo menos uma letra e um número. **Email**: formato válido (ex: user@domain.com). |
| **Erros e loading** | **Snackbar** para erros (estilo similar ao sucesso de favoritos); **loadings** durante requisições; **atraso fixo de 3 segundos** para simular resposta da API. |

### Features opcionais (diferenciais)

- [ ] **Tela apenas de favoritos** (lista de notícias favoritadas apenas) — não implementado.
- [x] **Lista de categorias** — Drawer carrega categorias de `GET /categories` (apenas lista; filtro não aplicado à lista de notícias).
- [x] **Cache local** — **Lista e detalhes de notícias** cacheados com SharedPreferences; **imagens** cacheadas com `cached_network_image`. Melhora a performance percebida e reduz requisições redundantes.

---

## 4. APIs usadas (referência do desafio)

| Método | Rota | Uso |
|--------|------|-----|
| GET | `/news?page={page}` | Lista paginada de notícias. |
| GET | `/news/{id}/details` | Detalhes da notícia. |
| GET | `/categories` | Lista de categorias. |
| POST | `/auth` | Login (ex: `{"login":"desafioLoomi","password":"senha123"}`). |
| GET | `/user` | Dados do usuário. |
| PATCH | `/user` | Atualização de perfil (simular com atraso de 3s). |

**URL base de referência do desafio:** `https://flutter-challenge.wiremockapi.cloud`  
**Este projeto usa:** `https://le43j.wiremockapi.cloud` (configurado em `lib/core/network/` ou DI).

---

## 5. Documentação e comunicação (avaliado)

| Item | Onde no projeto |
|------|----------------------|
| **README** com configuração e principais decisões | [README.md](README.md) |
| **Commits claros** | Padrão em [CONTRIBUTING.md](CONTRIBUTING.md) |
| **Pull Requests claros** | Guia em [CONTRIBUTING.md](CONTRIBUTING.md) |

Recomendações do desafio (já refletidas no projeto):

- Conventional Commits.
- Código em **inglês** (commits, variáveis, comentários).
- Código limpo, legível e bem estruturado.
- Responsividade e boas práticas de UX (paginação, loadings).

---

## 6. Resumo antes de enviar

- [ ] Relatório de Progresso pronto (com link do backlog, priorização, dificuldades e melhorias).
- [ ] Git com commits descritivos, branches por feature e PR(s) para a branch principal.
- [ ] Todas as features obrigatórias implementadas e verificadas.
- [ ] Regras atendidas (API, Figma, validação, atraso de 3s, favoritos em memória, manter-me logado com persistência).
- [ ] README e CONTRIBUTING revisados.
- [ ] Projeto zipado e enviado para **processoseletivo@loomi.com.br** até **03/02/2026 às 14:00**.

---

*Document baseado no "Desafio Flutter | Loomi" (PDF).*
