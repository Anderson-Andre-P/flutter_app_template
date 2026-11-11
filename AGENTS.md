# AGENTS.md

Short cross-tool summary for AI coding agents. Claude Code reads `CLAUDE.md`
(the full version) and the skills in `.claude/skills/`.

- **What:** a Flutter template (Android + iOS) — feature-first Clean
  Architecture, Bloc only, get_it, go_router, light/dark design system, fake
  auth (no backend), no flavors.
- **Layers:** `domain` is pure Dart; `data` implements `domain`;
  `presentation` never imports `data`; features never import each other or
  `lib/app`; `core/` never imports features except `core/di`.
- **State:** Bloc for everything — no Cubit, provider or ChangeNotifier.
- **Errors:** usecases return `Result<T>` and never throw.
- **UI:** no string, colour, spacing, size or asset literals in widgets — use
  `*_strings.dart`, `core/theme` tokens and `core/constants/assets`; build
  screens from `core/widgets`; check both themes. Sizes scale with the
  screen through `flutter_screenutil_plus`, only inside the tokens (360 × 690
  design size): widgets write `AppSpacing.lg`, never `16.w`.
- **JSON:** hand-written `fromJson`/`toJson`, no code generation.
- **Language:** code and docs in English, UI copy in pt-BR, commits in
  Portuguese (`tipo(escopo): mensagem`), never an attribution trailer.
- **Done means:** `bash scripts/analyze.sh` and `bash scripts/test.sh` pass,
  `check-layers` and `audit-golden-rules` report nothing new.
- **Never:** push, create branches, run emulators/devices, or add a
  dependency without asking.
