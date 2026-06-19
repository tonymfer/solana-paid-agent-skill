# generate-launch-checklist

Generate a launch checklist for a seller-side paid Solana agent/API/MCP tool.

## Checklist sections

### Positioning

- The service being sold is clear.
- The flow is seller-side paid access, not generic checkout or payer-side x402.
- Checkout and QR flows route to official Payments & Commerce / Commerce Kit / Solana Pay.
- Buyer payment automation routes to payer-side x402 skills.

### Payment challenge

- Quote ID exists.
- Price, asset, network, and recipient/facilitator are explicit.
- Expiry is explicit.
- Resource/body hash is bound.
- Idempotency key is present.
- Retry instructions are clear.

### Verification

- Amount, asset, recipient, network, quote/reference, expiry, and confirmation are checked.
- Replayed, duplicate, underpaid, expired, and mismatched proofs are rejected or sent to manual review.
- Verifier downtime has a safe pending/manual-review path.

### Usage and access

- Access is bounded to one job/resource/window.
- Usage is metered.
- Retry returns the same result, not a second charge.
- Refund/credit states are defined.

### Safety

- No private keys, seed phrases, credentials, wallet connection, signing, or transactions are handled by this repo.
- Any live-money step requires human approval outside this repo.
- Transaction previews include network, asset, amount, recipient, instructions, deltas, authority changes, and expiry.

### Routes

- Privacy payments: Token-2022 Confidential Transfers.
- Receipt NFTs/SBTs: Metaplex.
- Facilitator/server route: PayAI or Corbits as appropriate.
- Distribution/catalog route: Pay.sh as appropriate.

### Tests

- Mock 402 challenge.
- Mock proof accepted/rejected.
- Expired quote.
- Duplicate proof replay.
- Idempotent retry.
- Failed job refund/credit.
- No wallet/signing/transaction tests.
