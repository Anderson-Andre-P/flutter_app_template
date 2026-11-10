# Outbox contract

## Entry

`id`, `type`, `payload`, `createdAt`, `attempts`, `nextAttemptAt` (epoch ms; `0` = eligible now), `lastError`.

- `id` is **client-generated** (`microsecondsSinceEpoch-random`) and doubles as the **server-side dedupe key**, so a resend after a lost response is harmless.
- `payload` is **self-contained**: it carries the session and context (user, account, device…) captured **at enqueue time**, so sending later never depends on current state.

## Enqueue

One transaction writes the entry; after it commits, `onEnqueued` notifies the scheduler, which triggers a drain. A feature never writes to the server directly from a user action.

## Handlers

A feature registers one `OutboxHandler` per `type` in its DI step. `send(entries)` receives **every pending entry of its type** and returns an outcome (`AcceptedAll`, `AcceptedPartial`, `RejectedRetryable`, `RejectedPermanent`; see SKILL.md). An exception thrown by a handler counts as `RejectedRetryable`.

## Drain

`drainOnce()`:

1. does nothing when offline (a connectivity gate) and **never runs twice at once**;
2. for each handler, reads pending entries **ordered by `createdAt`**, limited per batch (for example 100), only those whose `nextAttemptAt` has passed;
3. sends them and applies the outcome;
4. removes **only the ids the send confirmed**, so an entry enqueued while a batch is in flight is never dropped.

## Backoff

Example: `5 s × 2^attempts`, capped at `5 min`, plus up to `1 s` of jitter; clamp `attempts` before the shift (for example to 20) so the shift cannot overflow. The numbers are a starting point; keep the shape (exponential, capped, jittered).

## Scheduler

Drains on a timer (for example every 10 s) while started and on `syncNow()` (rate-limited, for example one per second). It starts after login reaches the home screen and stops at logout; it is foreground-only. Features may register `beforeTick` hooks for local periodic maintenance; the drain never waits for them.

## Background isolates

An isolate has its own memory: it cannot share the main isolate's open database or in-memory caches. Give it its own database file for what it writes, open it there, and let the main isolate read or forward from it. Re-sync cached preferences (`reload()`) after another isolate wrote.
