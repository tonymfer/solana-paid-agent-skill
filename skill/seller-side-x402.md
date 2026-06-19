# Seller-Side x402

## Purpose

Specify seller-side x402-style paid API/MCP flows without reimplementing a full protocol library.

## Verified positioning

- Solana x402 is for web services charging for API/content access.
- PayAI merchant docs validate the server role: advertise payment requirements, verify payments, fulfill requests, settle payments.
- Corbits validates a hosted proxy route for adding x402 payments to existing APIs.
- Payer-side skills help agents pay; this module helps builders get paid.

## Seller-side flow

1. Request arrives without valid payment proof or access token.
2. Server returns a 402/payment-required challenge with:
   - quote ID,
   - price,
   - asset/network,
   - pay-to target or facilitator route,
   - expiry,
   - resource identifier/body hash,
   - idempotency key,
   - retry instructions.
3. Payer completes payment externally through wallet, checkout, facilitator, or payer-side skill.
4. Client retries with payment reference/proof.
5. Seller verifies amount, asset, recipient, network, reference/idempotency key, expiry, and confirmation state.
6. Seller grants bounded access and records usage.

## Paid MCP first-class pattern

- MCP tool call returns a structured `payment_required` response instead of hidden wallet work.
- Follow-up call includes payment reference/proof.
- Tool returns receipt metadata, consumed units, and remaining access scope.
- Protected output is not leaked before payment verification.

## Verification concepts

Reject proofs that are:

- mismatched to quote/resource/body hash,
- expired,
- replayed,
- underpaid,
- wrong asset/network/recipient,
- over-broad for the requested access,
- already consumed.

## Protocol field caution

Exact x402 header and field names change by implementation. Verify current upstream docs before writing code. Use placeholders in planning docs until exact fields are verified.

## Error states

- payment_required
- payment_pending
- invalid_proof
- expired_quote
- already_consumed
- underpaid
- verifier_unavailable
- duplicate_payment_manual_review

## Out of scope

- Building a payer-side purchasing agent.
- Signing transactions.
- Holding private keys.
- Shipping a facilitator/proxy clone.

## Acceptance quality

A builder can design a 402 challenge/verify/grant loop for an MCP tool or API and know where protocol-specific verification remains.
