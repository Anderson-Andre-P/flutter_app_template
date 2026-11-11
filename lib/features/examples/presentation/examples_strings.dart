import '../domain/entities/transfer.dart';

/// User-facing copy of the example screens (pt-BR). Fake data, no backend.
abstract final class ExamplesStrings {
  /// The activity the "Detalhe" demo card opens.
  static const sampleActivityId = 'mercado-bela';

  /// The receipt the "Sucesso" demo card shows.
  static TransferReceipt sampleReceipt(DateTime now) => TransferReceipt(
    amountCents: 35000,
    recipient: 'Ana Souza',
    protocol: 'T48-1120-5521',
    issuedAt: now,
  );

  // Painel
  static const dashboardTitle = 'Painel';
  static const goalOverline = 'Meta do mês';
  static const goalValue = '7.420';
  static const goalCaption = 'de 10.000 pontos';
  static const goalProgress = .742;
  static const goalFooter = '74% concluído · faltam 2.580';
  static const highlightOverline = 'Ação rápida';
  static const highlightTitle = 'Nova transferência';
  static const highlightCaption = 'Valor, destinatário e resumo';
  static const highlightAction = 'Começar';
  static const weekTitle = 'Esta semana';
  static const weekValues = [3.0, 5.0, 2.0, 7.0, 4.0, 2.0, 6.0];
  static const weekLabels = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

  // Extrato
  static const statementTitle = 'Extrato';
  static const searchHint = 'Buscar movimentações';
  static const filterAll = 'Tudo';
  static const filterIncome = 'Entradas';
  static const filterExpense = 'Saídas';
  static const emptyTitle = 'Nada encontrado';
  static const emptyMessage = 'Tente outra busca ou outro filtro.';
  static const loadErrorTitle = 'Não foi possível carregar';
  static const retry = 'Tentar novamente';

  // Detalhes
  static const detailTitle = 'Detalhes';
  static const statusDone = 'Concluída';
  static const infoTitle = 'Informações';
  static const rowDate = 'Data';
  static const rowMethod = 'Pagamento';
  static const rowCategory = 'Categoria';
  static const rowProtocol = 'Protocolo';
  static const shareReceipt = 'Compartilhar comprovante';
  static const dispute = 'Contestar';
  static const comingSoon = 'Disponível em breve.';

  // Transferir
  static const transferTitle = 'Transferir';
  static const amountLabel = 'Valor da transferência';
  static const amountPresets = [5000, 10000, 20000, 35000];
  static const recipientLabel = 'Para';
  static const recipientHint = 'Nome ou CPF';
  static const descriptionLabel = 'Descrição';
  static const descriptionHint = 'Opcional';
  static const summaryTitle = 'Resumo';
  static const rowAmount = 'Valor';
  static const rowFee = 'Taxa';
  static const rowTotal = 'Total';
  static const transferContinue = 'Continuar';

  // Comprovante
  static const successTitle = 'Transferência enviada';
  static String successSubtitle(String amount, String recipient) =>
      '$amount para $recipient';
  static const receiptTitle = 'Comprovante';
  static const rowRecipient = 'Destinatário';
  static const backHome = 'Voltar ao início';

  // Estados
  static const statesTitle = 'Estados';
  static const stateLoading = 'Carregando';
  static const stateEmpty = 'Vazio';
  static const stateError = 'Erro';
  static const stateEmptyTitle = 'Nada por aqui ainda';
  static const stateEmptyMessage = 'Quando houver itens, eles aparecem aqui.';
  static const stateEmptyAction = 'Criar item';
  static const stateErrorTitle = 'Algo deu errado';
  static const stateErrorMessage = 'Verifique sua conexão e tente de novo.';

  // Toasts
  static const toastsTitle = 'Toasts';
  static const toastsTones = 'Tons';
  static const toastsVariants = 'Variações';
  static const toastSuccess = 'Sucesso';
  static const toastWarning = 'Atenção';
  static const toastError = 'Erro';
  static const toastInfo = 'Info';
  static const toastWithAction = 'Com ação';
  static const toastTitleOnly = 'Só título';
  static const toastStacked = 'Empilhar dois';
  static const toastSuccessMessage = 'Alterações salvas';
  static const toastSuccessDescription = 'Enviadas para revisão do gestor.';
  static const toastWarningMessage = 'Sem conexão estável';
  static const toastWarningDescription =
      'Salvamos no aparelho; sincroniza depois.';
  static const toastErrorMessage = 'Não foi possível salvar';
  static const toastErrorDescription = 'Verifique os campos e tente de novo.';
  static const toastRetry = 'Tentar';
  static const toastInfoMessage = 'Nova versão disponível';
  static const toastInfoDescription = 'Atualize para ver as melhorias.';
  static const toastActionMessage = 'Item arquivado';
  static const toastActionDescription = 'Ele saiu da sua lista.';
  static const toastActionLabel = 'Desfazer';
  static const toastUndone = 'Ação desfeita';
  static const toastFirst = 'Primeiro aviso';
  static const toastSecond = 'Segundo aviso';
  static const toastStackDescription =
      'O mais novo entra por cima; cabem dois.';

  // Modais
  static const modalsTitle = 'Modais';
  static const modalConfirm = 'Confirmação';
  static const modalConfirmHint = 'Duas opções, a principal à direita';
  static const modalDestructive = 'Destrutivo';
  static const modalDestructiveHint = 'Ação irreversível em vermelho';
  static const modalAlert = 'Alerta';
  static const modalAlertHint = 'Só informa, um botão';
  static const modalConfirmTitle = 'Salvar alterações?';
  static const modalConfirmMessage = 'Você pode editar de novo depois.';
  static const modalConfirmLabel = 'Salvar';
  static const modalDestructiveTitle = 'Excluir item?';
  static const modalDestructiveMessage = 'Essa ação não pode ser desfeita.';
  static const modalDestructiveLabel = 'Excluir';
  static const modalAlertTitle = 'Tudo certo';
  static const modalAlertMessage = 'Seus dados foram atualizados.';
  static const modalConfirmed = 'Você confirmou.';
  static const modalCancelled = 'Você cancelou.';

  // Bottom sheets
  static const sheetsTitle = 'Bottom sheets';
  static const sheetOptions = 'Lista de opções';
  static const sheetOptionsHint = 'Escolha uma; a atual tem check';
  static const sheetActions = 'Ações';
  static const sheetActionsHint = 'Com uma ação destrutiva';
  static const sheetContent = 'Conteúdo livre';
  static const sheetContentHint = 'Texto, campos e botões';
  static const sortTitle = 'Ordenar por';
  static const sortRecent = 'Mais recentes';
  static const sortOldest = 'Mais antigos';
  static const sortHighest = 'Maior valor';
  static String sortChosen(String label) => 'Ordenando por: $label';
  static const actionsTitle = 'Mercado Bela';
  static const actionEdit = 'Editar';
  static const actionShare = 'Compartilhar';
  static const actionDelete = 'Excluir';
  static String actionChosen(String label) => 'Você escolheu: $label';
  static const contentTitle = 'Novo lembrete';
  static const contentMessage = 'Um sheet pode ter qualquer conteúdo.';
  static const contentField = 'Título';
  static const contentFieldHint = 'Ex.: pagar a conta de luz';
  static const contentSave = 'Salvar lembrete';

  // Barra inferior
  static const navTitle = 'Barra inferior';
  static const navSpec =
      '64px sem área do sistema. Com home indicator ou barra do Android, as '
      'abas ficam com 48px e a área do sistema entra embaixo. Cantos '
      'superiores arredondados; aba ativa em azul.';
  static String navTabs(int count) => '$count abas';
  static const navLabels = ['Início', 'Busca', 'Pedidos', 'Mensagens', 'Conta'];

  // Widgets
  static const widgetsTitle = 'Widgets';
  static const buttons = 'Botões';
  static const buttonSizes = 'Tamanhos';
  static const buttonPrimary = 'Primário';
  static const buttonSecondary = 'Secundário';
  static const buttonOutline = 'Contorno';
  static const buttonOutlineSuccess = 'Contorno de sucesso';
  static const buttonSuccess2 = 'Sucesso';
  static const buttonTonal = 'Tonal';
  static const buttonGhost = 'Texto';
  static const buttonDestructive = 'Destrutivo';
  static const buttonDestructiveTonal = 'Destrutivo suave';
  static const buttonDisabled = 'Desabilitado';
  static const buttonLoading = 'Carregando';
  static const sizeXl = 'Extra grande';
  static const sizeLg = 'Grande';
  static const sizeMd = 'Médio';
  static const sizeSm = 'Pequeno';
  static const sizeXs = 'Mínimo';
  static const buttonIcons = 'Ícones';
  static const buttonIconsCaption = 'À esquerda, à direita ou só o ícone';
  static const buttonIconLeft = 'Novo pedido';
  static const buttonIconRight = 'Avançar';
  static const buttonIconOnly = 'Editar';
  static const buttonGroups = 'Grupos';
  static const buttonGroupsCaption =
      'Duplo 50/50, triplo e empilhado quando há ação destrutiva';
  static const groupDiscard = 'Descartar';
  static const groupSave = 'Salvar';
  static const groupBack = 'Voltar';
  static const groupSkip = 'Pular';
  static const groupContinue = 'Continuar';
  static const groupDelete = 'Excluir este registro';
  static const groupKeep = 'Manter';
  static const buttonGroupSegmented = 'Button group';
  static const buttonGroupSegmentedCaption =
      'Segmentos unidos; o ativo fica marcado';
  static const views = ['Lista', 'Grade', 'Mapa', 'Calendário'];
  static const viewList = 'Lista';
  static const viewGrid = 'Grade';
  static const viewMap = 'Mapa';
  static const splitExport = 'Exportar';
  static const splitMore = 'Outros formatos';
  static const socialTitle = 'Login social';
  static const socialCaption =
      'Ícone em caixa neutra e rótulo sempre "Continuar com"';
  static const socialProviders = [
    ('G', 'Continuar com Google'),
    ('A', 'Continuar com Apple'),
    ('M', 'Continuar com Microsoft'),
    ('S', 'Continuar com SSO corporativo'),
  ];
  static const touchId = 'Touch ID';
  static const faceId = 'Face ID';
  static const paymentTitle = 'Pagamento';
  static const paymentCaption =
      'O método escolhido ganha borda primária; o botão repete o valor';
  static const paymentMethods = [
    ('Cartão de crédito', 'Visa •••• 4021 · venc. 09/29'),
    ('Pix', 'Confirmação imediata'),
    ('Boleto bancário', 'Vence em 3 dias úteis'),
  ];
  static const payAmount = 'Pagar R\$ 828,00';
  static const fields = 'Campos';
  static const fieldName = 'Nome';
  static const fieldNameHint = 'Seu nome completo';
  static const fieldEmail = 'E-mail';
  static const fieldEmailError = 'Informe um e-mail válido';
  static const fieldPassword = 'Senha';
  static const fieldSearch = 'Buscar';
  static const chips = 'Chips';
  static const chipLabels = ['Todos', 'Abertos', 'Fechados', 'Arquivados'];
  static const badges = 'Badges';
  static const badgeLabels = [
    'Neutro',
    'Primário',
    'Sucesso',
    'Atenção',
    'Erro',
    'Info',
  ];
  static const avatars = 'Avatares';
  static const avatarInitials = 'AS';
  static const icons = 'Caixas de ícone';
  static const lists = 'Listas';
  static const listItems = [
    ('Notificações', 'Alertas e lembretes'),
    ('Privacidade', 'Quem vê seus dados'),
  ];
  static const cards = 'Cards';
  static const cardTitle = 'Card tocável';
  static const cardBody = 'Toda superfície de conteúdo é um card.';
  static const tapped = 'Tocou.';

  // Gráficos
  static const chartsTitle = 'Gráficos';
  static const chartBars = 'Barras';
  static const chartBarsCaption = 'Atividade por dia; hoje em destaque';
  static const chartLine = 'Linha';
  static const chartLineCaption = 'Evolução nos últimos 6 meses';
  static const chartLineValues = [
    1200.0,
    1850.0,
    1600.0,
    2400.0,
    2100.0,
    2950.0,
  ];
  static const chartLineLabels = ['Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov'];
  static const chartDonut = 'Rosca';
  static const chartDonutCaption = 'Divisão do orçamento';
  static const chartDonutCenter = '68%';
  static const chartDonutCenterCaption = 'do orçamento';
  static const chartDonutSegments = [
    ('Moradia', 40.0),
    ('Mercado', 18.0),
    ('Transporte', 10.0),
  ];
  static const chartProgress = 'Progresso';
  static const chartProgressCaption = 'Metas em andamento';
  static const goals = [
    ('Viagem', .62),
    ('Reserva de emergência', .78),
    ('Notebook novo', .12),
  ];
  static String percent(double v) => '${(v * 100).round()}%';

  // Controles
  static const controlsTitle = 'Controles';
  static const controlsToggles = 'Switch';
  static const controlsTogglesCaption = 'Liga e desliga na hora, sem salvar';
  static const toggleNotifications = 'Notificações';
  static const toggleLocation = 'Localização';
  static const toggleDisabled = 'Bloqueado';
  static const controlsCheckboxes = 'Checkbox';
  static const controlsCheckboxesCaption = 'Várias escolhas independentes';
  static const checkTerms = 'Li e aceito os termos';
  static const checkNews = 'Quero receber novidades';
  static const checkDisabled = 'Indisponível';
  static const controlsRadios = 'Radio';
  static const controlsRadiosCaption = 'Uma escolha entre poucas opções';
  static const payments = ['Pix', 'Cartão de crédito', 'Boleto'];
  static const controlsSegmented = 'Controle segmentado';
  static const controlsSegmentedCaption = 'Até quatro opções exclusivas';
  static const priorities = ['Baixa', 'Média', 'Alta', 'Crítica'];
  static const controlsFab = 'Ação flutuante';
  static const controlsFabCaption = 'A ação de criar principal da tela';
  static const fabNew = 'Novo';
  static const controlsBand = 'Banda de atenção';
  static const controlsBandCaption = 'Pede uma ação antes de seguir';
  static const bandTitle = 'Ação necessária';
  static const bandMessage =
      'Confirme o endereço de entrega para liberar o pedido.';
  static const bandAlertTitle = 'Revise antes de enviar';
  static const bandAlertMessage = 'Dois campos ainda estão em branco.';
  static const controlsTiles = 'Tiles de status';
  static const controlsTilesCaption = 'Contagens que pedem atenção';
  static const tileOpenValue = '24';
  static const tileOpen = 'Em aberto';
  static const tileLateValue = '3';
  static const tileLate = 'Em atraso';
  static const controlsMoreButtons = 'Outros botões';
  static const controlsMoreButtonsCaption =
      'Concluir com sucesso e acrescentar um item';
  static const buttonSuccess = 'Concluir pedido';
  static const addItem = 'Adicionar item';
  static const controlsReadOnly = 'Somente leitura';
  static const controlsReadOnlyCaption = 'Valor definido pelo sistema';
  static const readOnlyLabel = 'Código do pedido';
  static const readOnlyValue = 'PED-1042';

  // Formulários
  static const formsTitle = 'Formulários';
  static const formsText = 'Área de texto';
  static const formsTextCaption = 'Com contador de caracteres';
  static const formsDescription = 'Descrição';
  static const formsDescriptionHint = 'Contexto e instruções...';
  static const formsSelect = 'Select';
  static const formsSelectCaption =
      'Até 7 opções abrem logo abaixo; acima disso, com busca';
  static const formsPriority = 'Prioridade';
  static const formsCity = 'Cidade';
  static const cities = [
    'Belém',
    'Belo Horizonte',
    'Brasília',
    'Curitiba',
    'Florianópolis',
    'Goiânia',
    'Manaus',
    'Porto Alegre',
    'Recife',
    'Rio de Janeiro',
    'Salvador',
    'São Paulo',
  ];
  static const formsDateTime = 'Data e hora';
  static const formsDateTimeCaption = 'Aceitam digitação; o prazo não volta';
  static const formsDeadline = 'Prazo';
  static const formsDeadlinePast = 'Data no passado.';
  static const formsTime = 'Hora';
  static const formsSystemDate = 'Criado em';
  static const formsSystemDateHint = 'Definido pelo sistema';
  static const formsSliders = 'Slider';
  static const formsSlidersCaption = 'O valor fica sempre ao lado do rótulo';
  static const formsVolume = 'Volume de alertas';
  static const formsTolerance = 'Tolerância do parâmetro';
  static String units(double v) => '${v.round()} un';
  static String percent0(double v) => '${v.round()}%';
  static const formsStepper = 'Stepper numérico';
  static const formsStepperCaption = 'Quantidades pequenas e exatas, até 99';
  static const formsQuantity = 'Quantidade';
  static const formsFieldVariants = 'Variações de campo';
  static const formsFieldVariantsCaption = 'Prefixo, validado e desabilitado';
  static const formsIdLabel = 'Número do registro';
  static const formsIdPrefix = 'ID-';
  static const formsIdValue = '2026-0042';
  static const formsCpf = 'CPF';
  static const formsCpfValue = '123.456.789-09';
  static const formsLocked = 'Responsável';
  static const formsLockedValue = 'Definido pelo gestor';
  static const formsTags = 'Destinatários';
  static const formsTagsHelper = 'Vários cabem; toque em × para tirar';
  static const formsInitialTags = ['Marina Alves'];
  static const formsDeadlineRange = 'Prazo (dias)';
  static String days(double v) => '${v.round()}';
  static const formsStepsSlider = 'Prioridade (passos)';
  static const formsAttachments = 'Anexos';
  static const formsAttachmentsCaption =
      'No celular, um botão de envio; a área de soltar é só na web';
  static const formsUpload = 'Enviar documento';
  static const formsUploadHint = 'PDF, PNG ou XLSX até 25 MB';
  static const formsFiles = [
    ('Relatorio_agosto.pdf', '1,8 MB · enviado hoje'),
    ('Anexo_referencia.jpg', 'Enviando · 72%'),
    ('Dados_semana34.xlsx', '420 KB · aguardando sincronização'),
    ('Foto_painel.png', 'Falha no envio'),
  ];
  static const formsPhotos = 'Fotos capturadas';
  static const formsPhotosCaption = 'Dá para remover antes de sincronizar';

  // Navegação
  static const navigationTitle = 'Navegação';
  static const navigationTabs = 'Abas';
  static const navTabsCaption =
      'Sublinhadas para conteúdos diferentes; segmentadas para recortes';
  static const navTabItems = [
    ('Visão geral', 3),
    ('Histórico', null),
    ('Documentos', 12),
  ];
  static const navTabBodies = [
    'Resumo do registro e dos responsáveis.',
    'Tudo o que aconteceu, do mais recente ao mais antigo.',
    'Contratos, fotos e anexos do registro.',
  ];
  static const navPeriods = ['Semana', 'Mês', 'Trimestre'];
  static const navAccordion = 'Accordion';
  static const navAccordionCaption = 'Um painel aberto por vez';
  static const navFaq = [
    (
      'Como criar um novo registro?',
      'Toque em Novo no canto da tela e preencha os campos obrigatórios.',
    ),
    (
      'Por que o roteiro travou?',
      'Depois que a execução começa, o roteiro é congelado para corresponder ao que foi feito.',
    ),
    (
      'Funciona sem internet?',
      'Sim. As alterações ficam no aparelho e sincronizam quando a conexão voltar.',
    ),
  ];
  static const navStepper = 'Stepper';
  static const navStepperCaption = 'De 3 a 5 etapas; dá para voltar';
  static const navSteps = ['Detalhes', 'Prioridade', 'Responsável', 'Agenda'];
  static const navStepBack = 'Voltar';
  static const navStepNext = 'Avançar';
  static const navMenu = 'Menu de contexto';
  static const navMenuCaption = 'Até 6 ações; a destrutiva por último';
  static const navMenuItem = 'OS-2041 · Troca de bomba';
  static const navMenuActions = ['Editar', 'Duplicar', 'Atribuir a...'];
  static const navMenuDelete = 'Excluir';
  static const modalIcon = 'Modal com ícone';
  static const modalIconHint = 'Ícone ao lado do título e botão de fechar';
  static const modalIconTitle = 'Aplicar modelo?';
  static const modalIconMessage =
      'O conteúdo atual será substituído pelo Modelo padrão v2.1. Itens já '
      'respondidos serão perdidos.';
  static const modalIconConfirm = 'Aplicar';
  static const sheetFilters = 'Filtros';
  static const sheetFiltersHint = 'Cabeçalho com a ação Limpar';
  static const sheetFiltersClear = 'Limpar';
  static const sheetFiltersStatus = ['Pendente', 'Pausada', 'Concluída'];
  static const sheetFiltersApply = 'Aplicar';
  static const sheetFiltersCleared = 'Filtros limpos';
  static const navBars = 'Barras de topo';
  static const navBarsCaption = 'Marca e sino, voltar com ação, visualizador';
  static const navBrand = 'Triplicate';
  static const navBarTitle = 'Título da tela';
  static const navBarEdit = 'Editar';
  static const navViewer = 'Visualizador';
  static const navViewerPosition = '2 de 4';
  static const navNewBadge = 'Novo';
  static const navMenuButton = 'Menu';
  static const navFilterBar = 'Busca e filtros';
  static const navFilterBarCaption = 'Limpar a busca, filtros ativos e ordenar';
  static const navFilterHint = 'Buscar ordens';
  static const navHints = 'Tooltip e coach mark';
  static const navHintsCaption =
      'Explicam sem bloquear; o coach mark sai com um toque';
  static const navLocked = 'Bloqueado após iniciar';
  static const navCoachTitle = 'Arraste para reordenar';
  static const navCoachMessage = 'Segure a alça à direita e mova o item.';
  static const counters = 'Contadores';
  static const countersCaption = '99+ como teto; o ponto avisa sem número';
  static const counterValues = [3, 12, 140];
  static const newDotLabel = 'Ponto: há novidade';
  static const chipsMore = 'Chips desabilitado e com remoção';
  static const chipArchived = 'Arquivadas';
  static const inputChips = ['Bomba 02', 'Marina Alves', 'Setor B'];
  static const avatarsMore = 'Avatar com status e grupo';
  static const avatarStatusInitials = 'JM';
  static const avatarStatusLabel = 'Disponível';
  static const avatarGroup = ['AE', 'JM', 'RS', 'LP', 'TC', 'MV', 'GB'];
  static const stateOffline = 'Sem conexão';
  static const stateErrorCode = 'ERR-503';
  static const stateReport = 'Reportar problema';
  static const stateInline = 'Alerta em bloco';
  static const stateInlineMessage = 'Bloqueio: campo obrigatório ausente';
  static const stateSkeleton = 'Carregando lista';
  static const stateSkeletonCaption = 'Skeleton na forma do conteúdo';
  static const chartRing = 'Progresso circular';
  static const chartRingCaption =
      'Quando há percentual; o spinner é para quando não há';
  static const chartRingItems = [
    ('Envio', .72),
    ('Sincronia', .35),
    ('Backup', 1.0),
  ];
  static const toastNeutral = 'Neutro';
  static const toastNeutralMessage = 'Item arquivado';
  static const navLoadMore = 'Carregar mais';
  static const navLoadMoreCaption = 'No celular, no lugar da paginação';
  static String navLoadMoreLabel(int n) => 'Carregar mais $n';
  static String navShowing(int shown, int total) =>
      'Mostrando $shown de $total';
}
