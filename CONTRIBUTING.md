# Guia de contribuição

Este documento define boas práticas para **mensagens de commit** e **Pull Requests**, garantindo clareza e consistência no histórico do projeto.

---

## Mensagens de commit

### Formato

```
type(scope): descrição curta no modo imperativo

Corpo opcional com mais detalhes, quebrar linha em 72 caracteres.
```

- **type**: o que mudou (feat, fix, docs, etc.)
- **scope**: módulo/área afetada (auth, news, profile, core)
- **description**: frase curta, imperativo ("add" não "added")

### Tipos permitidos

| Tipo       | Uso |
|-----------|-----|
| `feat`    | Nova feature |
| `fix`     | Correção de bug |
| `docs`    | Apenas documentação (README, CONTRIBUTING, comentários) |
| `style`   | Formatação, espaços, ponto e vírgula (sem mudança de lógica) |
| `refactor`| Refatoração (sem nova feature ou correção de bug) |
| `test`    | Adicionar ou atualizar testes |
| `chore`   | Build, CI, dependências, config (ex: pubspec, analysis_options) |

### Escopos sugeridos

- `auth` – login, splash, autenticação
- `news` – feed, detalhes, favoritos
- `categories` – categorias do drawer da API
- `profile` / `user` – perfil e dados do usuário
- `core` – router, DI, network, errors, services
- *(omitir scope quando a mudança for geral, ex: `docs: update README`)*

### Exemplos

```text
feat(auth): add login screen with email and "continue without account"
fix(news): avoid duplicate requests when opening details
docs: add project setup and architecture to README
style(login): apply Figma spacing to tab container
refactor(core): extract Dio base URL to app_config
test(auth): add AuthBloc login success and failure cases
chore: upgrade flutter_lints to 5.0.0
```

### O que evitar

- Mensagens genéricas: `fix bug`, `update`, `changes`
- Passado: preferir "add" em vez de "added"
- Misturar vários tipos em um commit: manter commits atômicos

---

## Pull Requests

### Título

- Claro e curto.
- Pode seguir o padrão do commit: `type(scope): description`.

Exemplos:

- `feat(auth): login screen per Figma`
- `fix(news): loading state in feed`

### Descrição

Incluir claramente:

1. **O que** foi mudado (resumo das mudanças).
2. **Por quê** (motivo/contexto, link para issue se houver).
3. **Como testar** (passos para um revisor validar).

Exemplo:

```markdown
## O que
- Nova tela de login com abas "Entrar" e "Criar conta"
- Campo de email e botão "Entrar" com cor #1876D2
- Links "Esqueci a senha" e "Continuar sem conta"

## Por quê
Alinhar tela de login com design do Figma (issue #XX).

## Como testar
1. Executar `flutter run`
2. No splash, aguardar redirecionamento para /login
3. Verificar layout (Nortus, logo, abas, card azul)
4. Testar "Entrar" com email válido e "Continuar sem conta"
```

### Boas práticas

- Commits no PR com mensagens seguindo o formato acima.
- Um PR por objetivo (uma feature ou uma correção).
- Atualizar documentação (README, CONTRIBUTING) se a mudança afetar configuração ou fluxo.
- Executar `flutter analyze` e `flutter test` antes de abrir o PR.

---

## Resumo rápido

| Item | Regra |
|------|------|
| Commit | `type(scope): descrição no modo imperativo` |
| Título do PR | Claro e objetivo (pode usar mesmo padrão do commit) |
| Descrição do PR | O que, por quê e como testar |

Seguir este guia mantém o histórico legível e revisões mais rápidas.
