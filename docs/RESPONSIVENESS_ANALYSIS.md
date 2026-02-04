# Análise de Responsividade

Análise de como o app se adapta a diferentes tamanhos de tela, densidades e orientações.

---

## O que já está bom

1. **Scroll**
   - O conteúdo principal está dentro de `SingleChildScrollView`, `ListView` ou `ListView.separated`, então conteúdo longo faz scroll em vez de transbordar.
   - `news_page` e `news_details_page` usam `Expanded` + scroll corretamente.

2. **Overflow de texto**
   - Títulos e resumos usam `maxLines` e `overflow: TextOverflow.ellipsis` em vários lugares (cards de notícias, detalhes, footer), o que evita overflow de texto.

3. **Largura flexível**
   - Muitos widgets usam `width: double.infinity` ou estão dentro de `Row`/`Column` com `Expanded`, então o espaço horizontal é usado sem valores fixos de largura total.

4. **Página de login**
   - Usa `MediaQuery.of(context).size` para:
     - Padding superior (`size.height * 0.05`)
     - Posição/tamanho do logo (`size.width * 1.6`, `right: -size.width * 0.45`)
     - Tamanho da fonte do título (`size.width * 0.11`)
   - Usa `SafeArea` para o conteúdo superior.

5. **SafeArea**
   - Usado em **login_page**, **profile_header**, **header**. Ajuda com notch/barra de status em algumas telas.

---

## Problemas e recomendações

### 1. Pouco uso de MediaQuery e tamanho de tela

**Atual:** Apenas a página de login usa `MediaQuery` para layout/tamanho. Outras telas usam valores fixos em pixels.

**Impacto:** Em telefones muito pequenos, paddings fixos (ex: 24px) ocupam uma grande parte da largura; em tablets, os mesmos 24px parecem estreitos e o conteúdo não usa bem o espaço.

**Recomendação:**
- Definir um pequeno conjunto de paddings horizontais a partir da largura da tela, ex: `paddingHorizontal = min(24, MediaQuery.sizeOf(context).width * 0.06)` ou breakpoints (telefone / tablet).
- Opcionalmente escalar alguns espaçamentos (ex: gaps verticais) com altura, sem exagerar.

---

### 2. Grid sempre com 2 colunas

**Atual:** `news_page` e `news_details_page` usam:

```dart
SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 0.65,
)
```

**Impacto:** Em telefones está bom. Em tablets (ex: largura > 600px), 2 colunas deixam muito espaço vazio; em dispositivos muito estreitos, 2 colunas podem parecer apertadas.

**Recomendação:**
- Usar `crossAxisCount` baseado na largura, ex:
  - `width < 400` → 2
  - `400 <= width < 600` → 2
  - `width >= 600` → 3 ou 4
- Opcionalmente ajustar `childAspectRatio` por breakpoint para que os cards não pareçam muito altos ou muito achatados.

---

### 3. Alturas de imagem fixas

**Atual:**
- **news_card**: imagem `height: 200`
- **news_details_page**: imagem hero `height: 250`
- Cards hero de **news_page**: `height: 200`
- Cards grid/recentes de **news_page**: `height: 120`, `height: 80`, etc.

**Impacto:** Mesma altura em pixels em todos os dispositivos. Em telas pequenas a imagem pode dominar; em telas grandes pode parecer pequena. A proporção não está vinculada à tela.

**Recomendação:**
- Usar uma altura máxima e manter proporção, ex: `height: min(250, MediaQuery.sizeOf(context).height * 0.3)` e `fit: BoxFit.cover`, ou usar `AspectRatio` + `BoxFit.cover` para que a imagem se adapte à largura.

---

### 4. Tamanhos de fonte fixos

**Atual:** Tamanhos de fonte são fixos (ex: 10, 11, 12, 14, 16, 18, 20, 22, 24, 28, 48) em `GoogleFonts.inter(...)` / `GoogleFonts.spaceGrotesk(...)`.

**Impacto:** Não respeita o "tamanho de fonte" do sistema (acessibilidade). Usuários que definem texto grande podem ver overflow ou corte.

**Recomendação:**
- Usar `MediaQuery.textScalerOf(context)` ao construir `TextStyle`, ex: `fontSize: 16` com `textScaler: MediaQuery.textScalerOf(context)` (ou passar o scaler para o tema de texto).
- Preferir definir um tema base em `ThemeData` (ex: `textTheme`) e usar `Theme.of(context).textTheme` para que um lugar controle o escalonamento.

---

### 5. SafeArea não usado em todos os lugares

**Atual:** SafeArea é usado em login, header do perfil e header. **Não** é usado em:
- `news_page` (body sob AppBar)
- `news_details_page`
- `edit_profile_page`
- `profile_page` (body)
- `splash_page`
- `custom_footer` (apenas no final do scroll)

**Impacto:** Em dispositivos com notch, cantos arredondados ou áreas de gestos, o conteúdo pode ser desenhado sob a UI do sistema ou ser difícil de tocar perto das bordas.

**Recomendação:**
- Envolver o body principal (ou body do scaffold) com `SafeArea` onde o conteúdo deve ficar abaixo da barra de status e acima do indicador inicial, especialmente em:
  - news_page
  - news_details_page
  - profile_page
  - edit_profile_page
- Splash pode permanecer em tela cheia; o resto do app se beneficia do SafeArea.

---

### 6. Valores de padding fixos

**Atual:** Padding é principalmente fixo, ex: `EdgeInsets.symmetric(horizontal: 24, vertical: 16)`, `padding: 24`, `EdgeInsets.all(20)`.

**Impacto:** Em telas pequenas, 24px horizontal é uma grande fração da largura; em tablets, permanece 24px e não usa o espaço extra.

**Recomendação:**
- Centralizar padding horizontal em um helper ou constante derivada de `MediaQuery.sizeOf(context).width`, ex: `min(24, width * 0.06)` para telefones e um valor maior (ou porcentagem) para tablets.
- Usar a mesma lógica em news, profile e edit-profile para que o comportamento seja consistente.

---

### 7. Orientação

**Atual:** Sem `OrientationBuilder` ou mudanças de layout para paisagem.

**Impacto:** Em paisagem, lista/detalhe e grid mantêm a mesma estrutura; em telefones o conteúdo pode parecer estreito e alto.

**Recomendação (opcional):**
- Para tablets ou ao suportar paisagem no futuro: usar `OrientationBuilder` ou breakpoints de largura para alternar layout (ex: lista + detalhe lado a lado em paisagem, ou mais colunas no grid).

---

### 8. Logo e ícones

**Atual:**  
- **profile_header** / **header**: logo `width: 89, height: 20` (fixo).  
- **custom_home_app_bar**: logo `height: 32`, espaçamentos `SizedBox(width: 32)`, `SizedBox(width: 24)`.

**Impacto:** Mesmo tamanho em todos os dispositivos. Em telas muito pequenas o header pode parecer lotado; em tablets pode parecer pequeno.

**Recomendação:**  
- Opcionalmente escalar tamanho do logo com `MediaQuery.sizeOf(context).width` (ex: clamp entre 70 e 100) e usar espaçamento proporcional para que o header permaneça balanceado.

---

## Tabela resumo

| Tópico              | Estado atual              | Risco / impacto              | Prioridade |
|--------------------|----------------------------|----------------------------|----------|
| MediaQuery / size  | Apenas login usa         | Apertado em pequeno, estreito em tablet | Média   |
| Colunas do grid       | Sempre 2                    | Espaço desperdiçado em tablet     | Média   |
| Alturas de imagem      | Fixas (200, 250, etc.)      | Não se adapta à tela    | Baixa      |
| Escalonamento de fonte       | Tamanhos fixos                | Acessibilidade (texto grande) | Média   |
| SafeArea           | Apenas 3 telas             | Conteúdo sob notch/gestos | Alta     |
| Padding            | Fixo 24/16/20             | Não adaptativo               | Baixa      |
| Orientação        | Sem tratamento especial        | Paisagem não otimizada     | Baixa      |
| Tamanho logo/header   | Fixo                      | Desequilíbrio visual menor     | Baixa      |

---

## Ordem sugerida de trabalho

1. **SafeArea** – Adicionar onde necessário (news, details, profile, edit-profile) para que o conteúdo nunca fique sob a UI do sistema.
2. **Escalonamento de texto** – Usar `MediaQuery.textScalerOf(context)` (ou tema) para que tamanhos de fonte respeitem acessibilidade do sistema.
3. **Padding horizontal** – Um helper baseado em `MediaQuery.sizeOf(context).width` e usá-lo nas telas principais.
4. **Colunas do grid** – Breakpoint por largura (ex: 2 em telefone, 3–4 em tablet).
5. **Altura de imagem / proporção** – Substituir alturas fixas por altura máxima + proporção ou similar.
6. **Orientação / tablet** – Apenas se precisar suportar layouts de paisagem ou tablet explicitamente.

Se quiser, o próximo passo pode ser implementar SafeArea e um dos itens acima (ex: padding responsivo ou grid) no código.
