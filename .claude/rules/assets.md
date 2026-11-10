---
paths: ["assets/**"]
---

# Assets

`assets/` is organised by **type**: `images/` (png, jpg, webp), `vectors/`
(svg, rendered with `flutter_svg`), `audios/`, `fonts/`.

- **Naming rule:** a file's name is the `snake_case` form of the Dart constant
  that names it in `AppImages` / `AppVectors` / `AppAudios`
  (`lib/core/constants/assets/`) — e.g. `AppImages.appLogo` →
  `assets/images/app_logo.png`. Derive the name from the constant; don't
  invent one ad hoc.
- Every asset path referenced from Dart goes through `core/constants/assets/`
  — never a literal path in a widget (see the `flutter-ui-constants` skill).
- Flutter's asset directory declarations are **not** recursive: a new
  subfolder needs its own line under `flutter: assets:` in `pubspec.yaml`.
- Fonts (Inter 400/500/700, OFL) are declared under `flutter: fonts:` and read
  through the theme (`AppTypography`), never per widget.
- Folder and file names are English.
