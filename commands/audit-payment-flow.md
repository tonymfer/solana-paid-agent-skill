# audit-payment-flow

Audit a seller-side paid-agent, paid API, or Paid MCP/x402 flow.

## Inputs to collect

- What is being sold?
- Is it an agent, API, MCP tool, or checkout flow?
- Price, asset, network, recipient/facilitator route.
- Quote expiry and idempotency key strategy.
- Payment proof/reference format.
- Verifier source.
- Access grant scope.
- Usage ledger states.
- Refund/credit/manual-review policy.
- Any wallet/signing/credential touchpoints.

## Audit steps

1. Confirm this is seller-side paid-agent rails. If it is generic checkout, route to official Payments & Commerce / Commerce Kit / Solana Pay. If it is buyer-side payment, route to payer-side x402.
2. Verify quote fields: price, asset, network, payee, expiry, resource hash, idempotency key.
3. Verify proof checks: amount, asset, recipient, network, quote/reference, expiry, confirmation, replay status.
4. Verify ledger states: quoted, payment_pending, paid_unconsumed, running, succeeded_consumed, failed_refundable, expired, refunded_or_credited, manual_review.
5. Verify bounded access: one resource/job/window, no over-broad grants.
6. Apply signing/custody hard rules.
7. List missing tests and blockers.

## Output

- Verdict
- Seller-side positioning check
- Payment verification gaps
- Metering/idempotency gaps
- Signing/custody risks
- Routes to official primitives
- Required fixes before launch
