# Flutter App Template

Modelo para criar novos apps Flutter (Android e iOS) já com toda a fundação
pronta, para que o time só precise programar as telas do produto.

- **Arquitetura:** Clean Architecture por feature (`domain` / `data` /
  `application` / `presentation`), com um `core/` compartilhado.
- **Estado:** só Bloc (`flutter_bloc`). Não usa Cubit, provider nem ChangeNotifier.
- **DI e navegação:** `get_it` e `go_router`, com redirect pela sessão.
- **Erros:** usecases retornam `Result<T>` selado e nunca lançam exceção.
- **Design system:** tokens de cor, espaçamento, raio, tipografia e
  elevação, com tema **claro e escuro**, widgets base, dialogs e snackbars.
- **Telas de exemplo:** splash, entrar, criar conta, início em grade com
  16 demonstrações. São 6 telas (painel, extrato, detalhe, formulário,
  sucesso e estados) e 10 catálogos de componentes (widgets, barra inferior,
  modais, bottom sheets, toasts, gráficos, controles, formulários,
  navegação e conversa e mídia). Há também a aba Configurações,
  com troca de tema e saída. A autenticação e os dados
  são **falsos e locais**, sem backend.
- **Skills de IA:** `.claude/` com skills, rules, hooks e permissões, mais o
  `CLAUDE.md` e o `AGENTS.md`.

## Requisitos

- Flutter 3.41 (stable) / Dart 3.11
- Python 3.9+ (scripts das skills)

## Começando um app novo

1. No GitHub, clique em **Use this template** e clone o novo repositório.
2. Rode `flutter pub get`.
3. Renomeie o app (veja a seção abaixo).
4. Ative o hook de commit: `git config core.hooksPath .githooks`.
5. Rode o app: `bash scripts/run.sh`.

### Renomeando

O template usa o package `flutter_app_template`, o id `com.example.app_template`
e o nome `App Template`.

```bash
# 1. Application id (Android) e bundle id (iOS)
dart run change_app_package_name:main com.suaempresa.seuapp

# 2. Nome exibido no aparelho
dart pub global activate rename
rename setAppName --targets android,ios --value "Seu App"

# 3. Nome do package Dart: troque `name:` no pubspec.yaml e substitua os imports
grep -rl 'package:flutter_app_template/' lib test | xargs sed -i '' 's|package:flutter_app_template/|package:seu_app/|g'
```

No Linux, use `sed -i` (sem as aspas vazias). Por fim, troque também o
`App.title` em `lib/app/app.dart`.

## Estrutura

```
lib/
  main.dart          bootstrap: config, DI, Sentry opcional, rotas, runApp
  app/               App (temas, pt-BR, blocs globais) e navigation/
  core/
    config/          EnvConfig (via --dart-define)
    constants/       assets/ (caminhos), strings/ (textos comuns), keys/ (storage)
    di/              injection_container.dart (composition root)
    error/           AppException, Failure, Result, failure_mapper
    logging/         AppLogger (interface pura) e DebugAppLogger
    monitoring/      Sentry, ligado só se SENTRY_DSN estiver definido
    network/         ApiClient (http + token + erros tipados)
    session/         SessionBloc e SessionPort
    storage/         SecureStorage e PreferencesStorage
    theme/           tokens, paletas claro/escuro, ThemeData, modo de tema
    usecase/         contrato UseCase
    utils/           validators, initials
    widgets/         componentes do design system, dialogs/ e snackbar
  features/
    auth/            splash, entrar, criar conta (FakeAuthRepository)
    examples/        telas de demonstração com dados falsos (descartável)
    home/            shell com navegação inferior e grade de demonstrações
    settings/        configurações: conta, tema, versão e saída
assets/              images/  vectors/  audios/  fonts/ (Inter, OFL)
scripts/             run.sh  build.sh  test.sh  analyze.sh
tool/                resumo de testes e validação das skills
```

## Criando uma feature

1. Crie `lib/features/<feature>/{domain,data,application,presentation}`.
2. Registre as dependências em `<feature>_feature.dart`
   (`void register<Feature>Feature(GetIt sl)`) e chame essa função em
   `setupDependencies` (`lib/core/di/injection_container.dart`).
3. Adicione a rota em `lib/app/navigation/app_routes.dart` e o `GoRoute` em
   `app_router.dart`, criando o Bloc da página com `BlocProvider`.
4. Espelhe os testes em `test/`.

Antes de entregar, rode
`python3 .claude/skills/check-layers/scripts/check_layers.py` e
`python3 .claude/skills/audit-golden-rules/scripts/audit_rules.py`.

### Removendo as telas de exemplo

As demonstrações ficam todas em `lib/features/examples`. Para começar limpo:

1. Apague `lib/features/examples` e `test/features/examples`.
2. Tire `registerExamplesFeature` de `lib/core/di/injection_container.dart`.
3. Em `lib/app/navigation/`, remova as rotas de exemplo (`_exampleRoutes`,
   `_openDemo`, `transferDone`) e os caminhos marcados em `app_routes.dart`.
4. Troque o conteúdo de `HomePage` (e apague `home_demo.dart`).

### Usando um backend real

Implemente `AuthRepository` com o `ApiClient` e registre essa implementação em
`registerAuthFeature` no lugar do `FakeAuthRepository`. Nada mais precisa mudar.

## Tema e tokens

```dart
final c = context.colors;                       // paleta do modo ativo
Text('Olá', style: AppTypography.title.copyWith(color: c.textPrimary));
const SizedBox(height: AppSpacing.lg);          // escala: xs 4 … x4l 40
BorderRadius r = AppRadius.brMd;                // xs 6 … xl 22, full
```

- As cores ficam em `lib/core/theme/app_colors.dart`, em `AppColors.light` e
  `AppColors.dark`, com os mesmos nomes de papel nos dois modos. Para trocar a
  marca, basta trocar os valores.
- O modo segue o sistema por padrão. Em Configurações dá para forçar claro ou escuro,
  e a escolha fica salva.
- Nunca use cores, medidas, textos ou caminhos de asset literais nos widgets:
  use os tokens, os `*_strings.dart` e as classes em `core/constants/assets/`.

## Assets

Coloque cada arquivo na pasta do seu tipo e crie a constante correspondente:

```dart
// lib/core/constants/assets/app_images.dart
static const appLogo = '$_base/app_logo.png';   // assets/images/app_logo.png
```

## Configuração

O template não usa flavors. A configuração opcional vem por `--dart-define`:

| Chave | Padrão | Uso |
|---|---|---|
| `API_BASE_URL` | `https://api.example.com` | base do `ApiClient` |
| `SENTRY_DSN` | vazio | vazio desliga o Sentry |

Copie `.env.example.json` para `.env.json` (que está no gitignore). Os
scripts `run.sh` e `build.sh` leem esse arquivo automaticamente.

## Comandos

```bash
bash scripts/run.sh            # flutter run (+ .env.json)
bash scripts/analyze.sh        # formatação + análise estática
bash scripts/test.sh           # testes + resumo por feature
bash scripts/build.sh apk      # apk | appbundle | ipa
```

## Skills de IA

As skills ficam em `.claude/skills/` e os valores do projeto em
`.claude/skill-config/`.

| Skill | Quando usar |
|---|---|
| `flutter-clean-architecture` | criar ou mover uma feature, ligar DI |
| `flutter-bloc-state` | escrever um Bloc, evento ou estado |
| `dart-result-and-models` | usecases, repositórios, modelos e JSON |
| `flutter-ui-constants` | telas e widgets (textos, cores, espaçamentos, assets) |
| `flutter-testing-conventions` | escrever ou corrigir testes |
| `flutter-offline-first` | persistência local e sync (adicione sembast/sqflite antes) |
| `git-commit-conventions` | commits (Conventional, em português, sem trailer de IA) |
| `check-layers` | conferir as fronteiras entre camadas |
| `audit-golden-rules` | conferir as regras que o analyzer não pega |

O `CLAUDE.md` traz as regras de ouro e o passo a passo, e o `AGENTS.md` é um
resumo para outras ferramentas.

## Próximos componentes

O que o design system ainda tem e não virou widget fica em
[`docs/design-system-backlog.md`](docs/design-system-backlog.md), com a
prioridade de cada item.

## Licenças

A fonte Inter está sob a SIL Open Font License (`assets/fonts/OFL.txt`).
