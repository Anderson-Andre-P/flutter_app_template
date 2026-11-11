# Backlog do design system

Componentes e padrões do design system (arquivo FigCraft, páginas
**DS Light · Componentes** e **DS Light · Padrões**) que ainda não existem em
`lib/core/widgets`. Use esta lista para criar cada um no futuro e marque o
item quando ele estiver pronto.

**Como criar um item:**

1. Abra a seção indicada no FigCraft e meça o componente (alturas, raios,
   cores, estados).
2. Escreva o teste primeiro (`test/core/widgets/`), nos dois temas
   (`testBothThemes`).
3. Use só tokens de `core/theme`, sem valores literais.
4. Mostre o componente numa tela de demonstração de `lib/features/examples`.

Prioridades: **P1** é o que quase todo app usa, **P2** é útil mas mais
específico e **Web** é o que o DS indica só para web e tablet (no celular
vira outra coisa).

---

## Divergências do que já existe

São itens já implementados que não batem com o DS. Vale corrigir antes de
criar componentes novos.

- [x] **P1 · Toasts** (Padrões, seção 29): o DS pede título, descrição e
  ação, no topo da tela abaixo da barra de topo, com no máximo dois
  empilhados e o mais novo por cima. Duração de 4s; erros ficam até serem
  dispensados; `role=status`, e `role=alert` para erros. Hoje o
  `AppSnackbar` é uma linha única que aparece embaixo.
- [x] **P1 · Diálogo destrutivo** (Padrões, seção 19): ícone no topo, botão
  destrutivo em largura total e Cancelar embaixo. Conferir o `AppDialog`.
- [x] **P1 · Estados de interação** (Padrões, seções 22 e 30): conferir
  padrão, pressionado (escurece 8%), foco (anel de 2px afastado 2px),
  desabilitado e erro (contorno de 2px e mensagem) em botão primário e
  secundário, campo de texto, chip, switch, checkbox e linha de lista.
  Feito em botão, chip, campo e linha de lista (`AppInteractive`); switch e
  checkbox seguem o mesmo padrão quando forem criados (seção Controles).
- [x] **P2 · Rosca** (Padrões, seção 18): anel de 26px (hoje são 18px), no
  mínimo 3 arcos e rótulo central sempre presente.
- [ ] **Decisão · Contraste da paleta** (Padrões, seção 23): o teste
  `test/core/theme/contrast_test.dart` mostra pares abaixo do AA, listados
  em `knownLow`. Texto (4,5:1): `textMuted` sobre `screen` (claro, 4,35),
  sobre `field` (claro 4,47, escuro 4,27) e sobre `primarySubtle` (4,1 nos
  dois); `success` sobre `successSubtle` (claro, 4,07). Ícones e bordas
  (3:1): `alert` sólido sobre `card` (claro, 2,28) e `borderStrong` sobre
  `card` (1,28 claro, 1,68 escuro), que é a borda dos campos. Ajustar a
  paleta e tirar o par da lista.
- [ ] **Decisão · Botão primário** (Componentes, seção 09): o DS diz 52px; o
  `AppSizes.buttonLg` está em 48px, que é a altura das telas de exemplo.

## Controles (Componentes, seção 09)

- [x] P1 · Switch (toggle) do DS
- [x] P1 · Checkbox do DS
- [x] P1 · Radio do DS
- [x] P1 · Controle segmentado (Low / Medium / High / Critical)
- [x] P1 · FAB redondo e FAB estendido ("+ Novo")
- [x] P1 · Banda de atenção ("Action required": ícone, título e texto em
  fundo de perigo suave)
- [x] P2 · Tile de status (número grande com barra colorida à esquerda)
- [x] P2 · Botão de sucesso (verde, "Sucesso · concluir")
- [x] P2 · Botão tracejado "+ Adicionar item"
- [x] P2 · Campo somente leitura com o selo "READ-ONLY"

## Botões (Componentes, seção 10)

- [x] P2 · Tamanhos xs (ação dentro de linha de tabela) e xl (chamada
  isolada, onboarding)
- [x] P2 · Contornos neutro, destrutivo e de sucesso (o neutro é o
  `secondary` e o destrutivo, o `destructive`; o de sucesso é o
  `outlineSuccess`)
- [x] P1 · Botão só de ícone (com rótulo para leitor de tela)
- [x] P2 · Botão com ícone à direita ("Avançar →")
- [x] P1 · Grupos de botões: duplo 50/50 (secundário à esquerda), triplo (o
  primário ganha mais largura) e empilhado (obrigatório quando há ação
  destrutiva)
- [x] P2 · Button group segmentado (Lista / Grade / Mapa / Calendário) e só
  com ícones
- [x] P2 · Split button (ação padrão com menu de variações)
- [x] P2 · Login social ("Continuar com Google/Apple/Microsoft/SSO", 48px,
  ícone em caixa neutra)
- [x] P2 · Botões de biometria (Touch ID / Face ID)
- [x] P2 · Seletor de forma de pagamento (card com radio, borda primária e
  fundo tonal quando selecionado; o botão de pagar repete o valor)

## Cards (Componentes, seção 12)

Raio de 14 a 18px, borda e sombra de 1px; a imagem sangra até a borda; o
padding interno nunca fica abaixo de 14px.

- [ ] P2 · Card básico com rodapé de metadados
- [ ] P2 · Card com imagem e selo ("OPERATIONAL")
- [ ] P2 · Card com barra de progresso e botão
- [ ] P2 · Card com link "Ver tudo →"
- [ ] P2 · Card horizontal com miniatura, selo, avatar do responsável e data
- [ ] P2 · Card com campo, unidade, faixa de ajuda e anexo obrigatório
- [ ] P2 · Card de produto (selo de desconto, favorito, avaliação em
  estrelas, preço com valor riscado, stepper de quantidade, "Adicionar")
- [ ] P2 · Card de chamada para ação (fundo primário, botão branco e link)
- [ ] P2 · Card de preços (selo "Mais escolhido", preço por período, lista de
  itens com check)

## Formulários (Componentes, seção 14; Padrões, seções 25 a 27)

- [x] P1 · Área de texto com contador (0/400)
- [x] P1 · Select fechado e aberto, com estados padrão, erro e desabilitado;
  até 7 opções (acima disso, busca na lista); item atual com tinta e marcador
- [x] P1 · Campo de data e campo de hora (DD/MM/AAAA, 24h HH:MM), com
  estados de erro ("Data no passado.") e "definido pelo sistema"
- [x] P1 · Calendário do DS: mês com navegação e datas passadas bloqueadas.
  No celular abre em bottom sheet de altura total, com Cancelar e Aplicar
- [x] P2 · Lista de horários (13:00, 13:30…) — no bottom sheet do
  `AppTimeField`
- [x] P1 · Slider contínuo com o valor ao lado do rótulo e estados
  pressionado e desabilitado; área de toque de 44px
- [x] P2 · Slider de faixa (dois pontos, trilho preenchido entre eles)
- [x] P2 · Slider com passos nomeados (Baixa / Média / Alta / Crítica)
- [x] P1 · Stepper numérico (− 3 +) com mínimo e máximo; até 99 (acima disso,
  campo numérico)
- [x] P2 · Campo com prefixo ("ID-")
- [x] P2 · Campo validado (check verde)
- [x] P2 · Campo desabilitado com cadeado
- [x] P2 · Campo de tags com seleção múltipla ("Marina Alves ×")
- [x] P2 · Upload: botão de envio (no celular vira um botão de linha única,
  a área de soltar é só para web)
- [x] P2 · Lista de anexos com tipo (PDF/JPG/XLS), progresso de envio e
  status (enviado, enviando, aguardando sincronização)
- [x] P2 · Grade de fotos capturadas com remover e o botão "Capturar"

## Menus e sobreposições (Padrões, seções 21 e 25)

- [x] P1 · Menu de contexto ancorado num botão ("Mais ações"): até 6 itens,
  ação destrutiva por último, separada por divisor e em vermelho
- [ ] P2 · Modal com ícone e botão de fechar (largura máxima de 340px no
  celular)
- [ ] P2 · Tooltip ("Bloqueado após iniciar")
- [ ] P2 · Coach mark (dica de primeira execução, dispensada com um toque)
- [ ] P2 · Cabeçalho de bottom sheet com a ação "Limpar" (seção 19)
- [ ] Web · Drawer lateral (no celular, usar o bottom sheet)

## Navegação e estrutura (Padrões, seções 17, 18 e 20)

- [x] P1 · Abas sublinhadas com contador (Visão geral 3 / Histórico /
  Documentos 12)
- [x] P1 · Abas segmentadas (Semana / Mês / Trimestre) — o
  `AppSegmentedControl` no estilo `tinted`
- [x] P1 · Accordion (um painel aberto por vez; para conteúdo secundário)
- [x] P1 · Stepper horizontal de 3 a 5 etapas (concluída, atual, futura)
- [ ] P2 · Stepper vertical (o que já aconteceu, sem interação)
- [x] P2 · Progresso por etapas compacto ("2 de 5" com barra e pontos)
- [x] P1 · "Carregar mais" no fim de listas (no celular, substitui a
  paginação)
- [ ] P2 · Barra de topo com marca, sino com contador e avatar
- [ ] P2 · Variações da barra de topo: voltar com título e ação; menu com
  marca e selo "Novo"; barra escura de visualizador ("× Visualizador 2 de 4")
- [ ] P2 · Busca com botão de limpar, botão de filtros com contador e botão
  de ordenar
- [ ] P2 · Item reordenável com alça de arrastar e selos
- [ ] Web · Breadcrumb (a partir do terceiro nível; no celular, "← Voltar
  para…")
- [ ] Web · Paginação numerada com "por página"
- [ ] Web · Sidebar expandida e recolhida (no celular, a barra inferior)

## Dados e progresso (Componentes, seções 15 e 16; Padrões, seção 18)

- [ ] P2 · Timeline (ponto com halo, título, data e autor)
- [ ] P2 · Barra de progresso segmentada (várias cores numa barra só)
- [x] P1 · Progresso circular determinado (anel com percentual; o spinner só
  quando não há percentual)
- [x] P1 · Skeleton com shimmer que repete a forma do conteúdo (círculo para
  avatar, linhas, bloco). Shimmer de 1,2s em loop; nunca um spinner genérico
  em lista
- [ ] P2 · Placeholders de mídia (imagem, diagrama, anexo) e ícones por tipo
  de arquivo (38 a 44px, raio de 10px)
- [ ] P2 · Visualizador em tela cheia com indicador de páginas
- [ ] Web · Tabela com cabeçalho, seleção, prioridade, status, responsável,
  prazo e ações (no celular, vira card de lista)
- [ ] Web · Tabela zebrada com rodapé de totais e coluna de conclusão
- [ ] Web · Estados de tabela (skeleton e vazio com "Limpar filtros")

## Feedback e estados (Padrões, seções 17 e 24)

- [x] P1 · Estado offline ("Você está offline") com "N alterações
  pendentes"
- [x] P1 · Link secundário no estado de erro ("Reportar problema") e código
  do erro no texto
- [x] P1 · Alerta em bloco dentro da tela ("Bloqueio inline: campo
  obrigatório ausente")
- [x] P2 · Toast neutro com ação ("Desfazer")

## Badges, chips e avatares (Padrões, seção 28)

- [x] P1 · Contadores (3, 12, 99+ como teto) e ponto de novidade
- [x] P2 · Chip desabilitado
- [x] P1 · Chip removível com × ("Bomba 02 ×")
- [x] P2 · Avatar com indicador de status ("Disponível")
- [x] P2 · Grupo de avatares sobrepostos com "+4"

## Conversa (Componentes, seção 16)

- [ ] P2 · Balões de chat: os próprios à direita em azul; os dos outros à
  esquerda em cinza, com avatar e nome só na primeira mensagem da sequência;
  separador de dia; hora e "lido". Cantos de 4px no lado de quem falou
- [ ] P2 · Campo de mensagem com anexo e botão de enviar
- [ ] P2 · Anexo em mensagem com estados enviado, enviando (progresso e
  cancelar), falha ("Remover") e aguardando conexão

## Regras que podem virar automação

- [x] P1 · Teste de contraste AA (Padrões, seção 23): 4,5:1 para texto e
  3:1 para ícones e bordas, entre os pares de cores dos temas claro e escuro.
  O texto desabilitado (2,3:1) é só decorativo.
- [x] P1 · Teste de alvo de toque: pelo menos 44 × 44px em todo controle,
  mesmo quando o ícone tem 24px.
- [ ] P2 · Texto escala até 200% sem cortar nem sobrepor: teste com
  `textScaler` 2.0 nas telas de exemplo.
- [ ] P2 · Tom de voz (Padrões, seção 31: claro, direto, humano; fazer e
  evitar) em `.claude/rules/`, para a IA escrever os textos das telas nesse
  tom.
- [ ] P2 · Regras de mensagem dos estados (seção 24): título de até 5
  palavras, uma frase com o próximo passo, uma ação principal, nunca culpar o
  usuário.
