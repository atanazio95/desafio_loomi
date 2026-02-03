# Guia de contribuição

Este documento define boas práticas para **mensagens de commit** e **Pull Requests**, garantindo clareza e consistência no histórico do projeto.

---

## Mensagens de commit

### Formato

```
tipo(escopo): descrição curta em imperativo

Corpo opcional com mais detalhes, quebra de linha em 72 caracteres.
```

- **tipo**: o que mudou (feat, fix, docs, etc.)
- **escopo**: módulo/área afetada (auth, news, profile, core)
- **descrição**: frase curta, no imperativo (“add” e não “added”)

### Tipos permitidos

| Tipo       | Uso |
|-----------|-----|
| `feat`    | Nova funcionalidade |
| `fix`     | Correção de bug |
| `docs`    | Apenas documentação (README, CONTRIBUTING, comentários) |
| `style`   | Formatação, espaços, ponto e vírgula (sem mudança de lógica) |
| `refactor`| Refatoração (sem nova feature nem correção de bug) |
| `test`    | Inclusão ou ajuste de testes |
| `chore`   | Tarefas de build, CI, dependências, config (ex.: pubspec, analysis_options) |

### Escopos sugeridos

- `auth` – login, splash, autenticação
- `news` – feed, detalhes, favoritos
- `profile` / `user` – perfil e dados do usuário
- `core` – router, DI, network, errors, services
- *(omitir escopo quando a mudança for geral, ex.: `docs: update README`)*

### Exemplos

```text
feat(auth): add login screen with email and "continuar sem conta"
fix(news): avoid duplicate requests when opening details
docs: add project setup and architecture to README
style(login): apply Figma spacing to tab container
refactor(core): extract Dio base URL to app_config
test(auth): add AuthBloc login success and failure cases
chore: upgrade flutter_lints to 5.0.0
```

### O que evitar

- Mensagens genéricas: `fix bug`, `update`, `changes`
- Passado: preferir “add” em vez de “added”
- Misturar vários tipos em um único commit: fazer commits atômicos

---

## Pull Requests

### Título

- Objetivo e curto.
- Pode seguir o padrão de commit: `tipo(escopo): descrição`.

Exemplos:

- `feat(auth): tela de login conforme Figma`
- `fix(news): estado de loading no feed`

### Descrição

Inclua de forma clara:

1. **O que** foi alterado (resumo das mudanças).
2. **Por que** (motivo/contexto, link para issue se houver).
3. **Como testar** (passos para um revisor validar).

Exemplo:

```markdown
## O que
- Nova tela de login com abas "Acessar conta" e "Não tenho conta"
- Campo de e-mail e botão "Entrar" com cor #1876D2
- Links "Esqueci a senha" e "Continuar sem conta"

## Por que
Alinhar a tela de login ao design do Figma (issue #XX).

## Como testar
1. Rodar `flutter run`
2. Na splash, aguardar redirecionamento para /login
3. Verificar layout (Nortus, logo, tabs, card azul)
4. Testar "Entrar" com e-mail válido e "Continuar sem conta"
```

### Boas práticas

- Commits no PR com mensagens no padrão acima.
- Um PR por objetivo (uma feature ou um fix).
- Atualizar documentação (README, CONTRIBUTING) se a mudança impactar setup ou fluxo.
- Rodar `flutter analyze` e `flutter test` antes de abrir o PR.

---

## Resumo rápido

| Item | Regra |
|------|--------|
| Commit | `tipo(escopo): descrição no imperativo` |
| PR título | Claro e objetivo (pode usar o mesmo padrão do commit) |
| PR descrição | O que, por que e como testar |

Seguir esse guia mantém o histórico legível e as revisões mais rápidas.
