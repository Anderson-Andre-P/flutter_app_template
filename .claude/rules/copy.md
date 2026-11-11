---
paths: ["lib/**/*_strings.dart", "lib/core/constants/strings/**"]
---

# User-facing copy

Every user-facing string is pt-BR and lives in a `*_strings.dart` class
(golden rule 4). This file says **how it reads**: the design system's voice
(section 31) and the rules for state messages (section 24).

## Voice: clear, direct, human

- **Clear.** Short sentences, everyday words, one idea per message.
- **Direct.** Say what happened and what to do next. A button starts with a
  verb and names the thing: `Salvar OS`, not `Submeter`.
- **Human.** Address the person as *você*. No blame, no technical jargon, no
  exclamation marks in errors.

| Situation | Avoid | Prefer |
|---|---|---|
| Save button | `Submeter` | `Salvar OS` |
| Network error | `Erro 500: falha na requisição` | `Sem conexão. Tente de novo em instantes.` |
| Empty list | `Nenhum dado encontrado` | `Nenhuma OS por aqui. Crie a primeira.` |
| Deletion | `Tem certeza?` | `Excluir esta OS? Não dá para desfazer.` |

## Empty, error and offline states

Every list and detail screen plans what to show with no data, on a failure
and without a connection (`AppEmptyView`, `AppErrorView`, `AppOfflineView`):

- **Title:** at most five words, saying what happened (`Não foi possível
  carregar`).
- **Message:** one sentence with the next step, no jargon. An error code the
  user can quote goes in `code:` (`ERR-503`), not in the title.
- **One main action.** A secondary action is a link below it
  (`secondaryLabel:`), never a second button of the same weight.
- **Never blame the user.** The system owns the failure: `Não conseguimos
  salvar`, not `Você preencheu errado`. Field errors say how to fix it
  (`Informe um e-mail válido`).
- **Offline:** say that the work is safe on the device and syncs later, and
  how much is waiting (`CommonStrings.pendingChanges`).

## Toasts and dialogs

- A toast title is the outcome in a few words (`Alterações salvas`); the
  description, if any, is the consequence or next step.
- A destructive dialog names the action and the object in the title and the
  consequence in the message; the confirm button repeats the verb
  (`Excluir`), never `OK`/`Sim`.
