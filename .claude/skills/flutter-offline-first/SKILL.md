---
name: flutter-offline-first
description: Offline-first persistence for Flutter apps — a local database plus a durable outbox queue as the source of truth, writes saved locally first and synced later with retry and backoff, atomic transactions, and what must survive logout. Use when adding or changing a feature that stores or sends data, touching a local datasource, repository, sync or outbox code, handling no-network behaviour, a login/logout flow, background-isolate writes, a bug where local data was lost, duplicated or reset after a sync, or reviewing a change to storage or sync.
metadata:
  version: "1.0"
  scope: portable
---

# flutter-offline-first

## The rule

The **local database plus the outbox** are the source of truth for the user's own data.

- **Reads** render from the local store.
- **Writes** are saved locally first (in a transaction) and queued; a syncer sends the queue when the network allows.
- Only operations that cannot exist offline (authentication, binding to a resource) require connectivity. **The UI and every calculation never block on the network.**
- **The server is never used to repair local data.** Local writes must be atomic and durable instead. If a deliberate exception exists (for example "the server wins only when it is strictly ahead"), it is written down in the project's gaps log and explicit in the code — never implicit.

Why: a sync that "corrects" local state from the server turns a transient failure (a lost response, a duplicated trigger, a day rollover) into data loss. Making writes durable removes the need to repair.

## Stores, by what they hold

| Store | Holds | Notes |
|---|---|---|
| Local database | feature data and the outbox | every mutation in a transaction |
| Separate database file | positions/events written by a **background isolate** | its own file, so that isolate never stalls the main database's transactions (the outbox included) |
| Preferences | small non-sensitive per-device values: flags, last selections, caches | call `reload()` after another isolate wrote |
| Secure storage | credentials and the session token | keychain / keystore |

## The outbox in one screen

`Outbox.enqueue(type, payload)` writes one entry **in a transaction**, then notifies the scheduler. A feature registers one **handler per `type`**; the syncer sends the pending entries of a type and applies the handler's outcome.

| Outcome | Syncer does |
|---|---|
| `AcceptedAll` | remove every entry in the batch |
| `AcceptedPartial(ids, reason)` | remove the accepted ids; reschedule the rest with backoff |
| `RejectedRetryable(reason)` | reschedule the whole batch with backoff (network, 5xx, any exception thrown by a handler) |
| `RejectedPermanent(reason)` | remove the batch and log an error (a 4xx that is not auth) |

Entry shape, drain and backoff rules, scheduler lifecycle: [references/outbox-contract.md](references/outbox-contract.md).

## What survives logout

Logout runs the "before" callbacks, calls the server, clears the local session, runs every feature's "after" callback (clear caches, stop tracking, stop the scheduler and realtime session). **The local clears always run, even when the server call fails.** **Nothing in logout clears the outbox**: pending entries stay queued until sent. An expired session found at start-up runs the same callbacks without the server call.

## Decimal precision

Quantities that must keep their precision are parsed once and stored without a lossy `double` round-trip (see `dart-result-and-models`).

## Before you change storage or sync code

Run the questions in [references/review-checklist.md](references/review-checklist.md) against the diff.
