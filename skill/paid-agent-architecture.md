# Paid Agent Architecture

## Purpose

Define seller-side architecture for a Solana-aware agent, API, or MCP tool that gets paid safely.

This skill is for builders selling agent work. It is not generic checkout and not a buyer/payer x402 client.

## Reference architecture

- Client/user agent: asks for protected work.
- Paid API/MCP server: returns payment-required metadata when proof is missing.
- Quote/challenge layer: creates price, asset, network, payee, expiry, resource hash, and idempotency key.
- External payment path: user or payer-side skill handles checkout/payment outside this skill.
- Payment verifier: checks amount, asset, recipient, network, quote, expiry, and confirmation state.
- Usage ledger: records quote, proof hash, job status, consumed units, and receipt metadata.
- Access grant layer: grants bounded access to one resource/job/window.
- Job runner: executes paid work once per idempotency key.
- Audit log: records decisions without secrets or private keys.

## State machine

1. Request arrives without valid paid access.
2. Seller creates quote/challenge.
3. User approves/pays outside custody boundary.
4. Seller observes or receives payment proof.
5. Seller verifies proof.
6. Seller grants bounded access.
7. Seller runs job once and meters usage.
8. Seller returns result or refund/credit/manual-review state.

## Monetization patterns

- Per-call Paid MCP tool: recommended v1 demo.
- Paid API endpoint.
- Prepaid credits.
- Subscription/pass gating.
- Paid heavy compute job.

## Route instead of reimplementing

- Checkout UI, buttons, QR, Solana Pay: official Payments & Commerce / Commerce Kit / Solana Pay.
- Payer-side x402: payer-side x402 skill.
- Confidential Transfers: Token-2022 Confidential Transfers.
- Receipt NFTs/SBTs: Metaplex.

## Architecture decision record template

- Product being charged for:
- User/resource identifier:
- Price/asset/network:
- Quote expiry:
- Payee/facilitator route:
- Verifier source:
- Ledger store:
- Access grant boundary:
- Idempotency key strategy:
- Refund/credit/manual-review path:
- Human approval requirements:
- Compliance/legal qualified-review items:

## Out of scope

- Concrete wallet integration code.
- Transaction signing or broadcasting.
- Custodial account design.
- Legal/tax/payment compliance certainty.

## Acceptance quality

A builder can produce a one-page architecture for a paid agent without inventing unsafe custody or signing boundaries.
