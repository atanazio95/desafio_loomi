# Checklist de entrega – Desafio Flutter Loomi

Use este documento para conferir o que deve ser entregue conforme o PDF do desafio.

---

## Prazo e envio

| Item | Detalhe |
|------|--------|
| **Data limite** | 03/02/2026 às 14h |
| **Formato** | Projeto completo em **ZIP** |
| **Envio** | E-mail para **processoseletivo@loomi.com.br** |

---

## 1. Relatório de progresso (documento separado ou anexo)

Entregar um **Relatório de Progresso** contendo:

- [ ] **Link da plataforma de gestão** usada para backlog: [Trello - Desafio Loomi](https://trello.com/b/KCoxyq0E/desafio-loomi)
- [ ] **Como organizou** demandas e atividades.
- [ ] **Como priorizou** as entregas.
- [ ] **Principais dificuldades** e como lidou com elas.
- [ ] **O que faria diferente** com mais tempo ou em contexto real de projeto.

---

## 2. Fluxo de Git (#Essencial)

| Item | O que fazer |
|------|-------------|
| **Versionamento** | Usar Git em todo o projeto. |
| **Commits** | Mensagens **descritivas** (recomendado: Conventional Commits – ver [CONTRIBUTING.md](CONTRIBUTING.md)). |
| **Branches** | Uma **branch por feature**. |
| **Pull Requests** | Abrir **PR para a branch principal** (ex.: `develop` ou `main`) ao finalizar cada feature. |

Antes de enviar o ZIP, confira:

- [ ] Histórico de commits claro e descritivo.
- [ ] Uso de branches por feature.
- [ ] PR(s) abertos/mergeados para a branch principal (develop ou equivalente).

---

## 3. Entregáveis técnicos (escopo do desafio)

### Funcionalidades obrigatórias

| Funcionalidade | O que deve ter | Status |
|----------------|----------------|--------|
| **Splash Screen** | Tela inicial simples para carregamento do app. | |
| **Cadastro e Login** | Criar conta e autenticar; opção **“Manter-se logado”**. | |
| **Tela inicial** | Listagem de notícias com **paginação infinita**; **busca por texto** (local, nos dados em memória); cada item com **título, imagem e breve descrição**. | |
| **Tela de detalhes** | **Título, imagem e conteúdo completo**; seção **“Notícias relacionadas”** no rodapé. | |
| **Favoritar** | Marcar/desmarcar favorito **em memória** (sem persistência entre execuções). | |
| **Tela de perfil** | Exibir dados do usuário e **edição** (nome, e-mail, etc. — **sem foto**). | |

### Regras e detalhes importantes

| Regra | Exigência |
|-------|-----------|
| **API** | Requisições em `https://flutter-challenge.wiremockapi.cloud/` (mockada). |
| **Design** | Seguir o **Figma** fornecido (Nortus). |
| **“Esqueci minha senha” / “Continuar sem conta”** | **Não implementar** os fluxos; apenas **ter a opção na tela**. |
| **Idioma / data / fuso** | Lista **mockada** com algumas opções para ilustrar. |
| **Busca** | Apenas **local**, sobre dados já carregados (sem nova requisição). |
| **Edição de perfil** | **Simular** atualização localmente; **delay de 3 segundos** na “resposta”. |
| **Favoritos** | **Em memória** durante o uso; não persistir entre execuções. |
| **Manter-se logado** | Usar **persistência local** (ex.: SharedPreferences). |
| **Validações** | **Senha**: mínimo 8 caracteres, ao menos uma letra e um número. **E-mail**: formato válido (ex.: usuario@dominio.com). |
| **Erros e loading** | **Snackbar** de erro (estilo semelhante à de sucesso de favoritos); **loadings** durante requisições; **delay fixo de 3 segundos** para simular resposta da API. |

### Funcionalidades opcionais (diferenciais)

- [ ] Tela de **notícias favoritadas** (listagem só das favoritas).
- [ ] **Filtros por categoria** (ex.: Tecnologia, Esportes, Mundo).
- [ ] **Cache local** (Pleno – opcional): armazenar notícias/imagens para acesso offline parcial.

---

## 4. APIs utilizadas (referência do desafio)

| Método | Rota | Uso |
|--------|------|-----|
| GET | `/news?page={page}` | Listagem paginada de notícias. |
| GET | `/news/{id}/details` | Detalhes da notícia. |
| GET | `/categories` | Lista de categorias. |
| POST | `/auth` | Login (ex.: `{"login":"desafioLoomi","password":"senha123"}`). |
| GET | `/user` | Dados do usuário. |
| PATCH | `/user` | Atualização do perfil (simular com delay 3s). |

Base URL: `https://flutter-challenge.wiremockapi.cloud`

---

## 5. Documentação e comunicação (avaliado)

| Item | Onde está no projeto |
|------|----------------------|
| **README** com setup e principais decisões | [README.md](README.md) |
| **Clareza em commits** | Padrão em [CONTRIBUTING.md](CONTRIBUTING.md) |
| **Clareza em Pull Requests** | Guia em [CONTRIBUTING.md](CONTRIBUTING.md) |

Recomendações do desafio (já refletidas no projeto):

- Conventional Commits.
- Código em **inglês** (commits, variáveis, comentários).
- Código limpo, legível e bem estruturado.
- Responsividade e boas práticas de UX (paginação, loadings).

---

## 6. Resumo antes de enviar

- [ ] Relatório de Progresso pronto (com link do backlog, priorização, dificuldades e melhorias).
- [ ] Git com commits descritivos, branches por feature e PR(s) para a branch principal.
- [ ] Todas as funcionalidades obrigatórias implementadas e conferidas.
- [ ] Regras (API, Figma, validações, delay 3s, favoritos em memória, manter-se logado com persistência) atendidas.
- [ ] README e CONTRIBUTING revisados.
- [ ] Projeto compactado em **ZIP** e enviado para **processoseletivo@loomi.com.br** até **03/02/2026 às 14h**.

---

*Documento gerado com base no “Desafio Flutter | Loomi” (PDF).*
