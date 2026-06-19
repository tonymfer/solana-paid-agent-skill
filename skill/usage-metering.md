# Usage Metering

## Purpose

Design deterministic paid-agent usage ledgers, accounting states, idempotency, refunds, and retry behavior.

## Metering models

- Per request.
- Per successful result.
- Per token/compute estimate.
- Per job stage.
- Prepaid credits.

## Ledger primitives

- account/customer identifier,
- quote ID,
- idempotency key,
- request body/resource hash,
- payment reference/proof hash,
- resource/tool name,
- requested units,
- authorized units,
- consumed units,
- access grant scope,
- status,
- timestamps,
- receipt metadata.

Do not store seed phrases, private keys, raw credentials, or sensitive prompts/results in public/on-chain receipt data.

## Job states

- quoted
- payment_pending
- paid_unconsumed
- running
- succeeded_consumed
- failed_refundable
- failed_consumed_partial
- expired
- refunded_or_credited
- disputed_manual_review

## Idempotency rules

- Same idempotency key plus same request body returns the same job/result state.
- Same proof cannot buy unrelated work.
- Duplicate payment creates credit/manual review, not silent loss.
- Retry after success returns cached result/receipt metadata without double charging.
- Retry while running returns current job state, not a second job.

## Refund/credit prompts

- Did the job fail before compute started?
- Did it fail after partial compute?
- Was the result delivered but the user retried?
- Was the verifier unavailable?
- Was the quote expired but funds still arrived?
- Is the duplicate payment linked to a known user and safe to credit?

## Abuse prevention

- Quote expiry.
- Rate limits before and after payment.
- Resource/body hash binding.
- Bounded access windows.
- Audit logs.
- Manual review for ambiguous payment states.

## Out of scope

- Financial accounting compliance guarantees.
- Tax reporting.
- Custodial balance management.

## Acceptance quality

A builder can specify a deterministic paid-job ledger and QA can test duplicate, retry, failure, expiry, and refund paths.
