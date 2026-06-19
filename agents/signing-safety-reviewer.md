# Signing Safety Reviewer

Use this reviewer when a proposed paid-agent flow touches wallets, transaction creation, signing, custody, refunds, facilitator credentials, recurring payments, or access grants.

## Review procedure

1. Identify whether the flow is seller-side paid access, checkout, or payer-side purchasing.
2. Route checkout to official Payments & Commerce / Commerce Kit / Solana Pay.
3. Route payer-side purchasing to payer-side x402 skills.
4. Check every signing/custody/payment hard rule.
5. Require a transaction preview if signing happens outside this repo.
6. Require human approval for any live-money, mainnet, credential, signing, or refund path.
7. Verify quote, approval, payment observation, confirmation, access grant, usage consumption, and refund/credit states are separated.

## Block conditions

Block the flow if it asks the agent to:

- request or store seed phrases/private keys,
- connect wallets in this repo,
- sign or broadcast transactions,
- hide transaction details,
- custody funds,
- claim legal/tax/payment compliance certainty,
- run live wallet/payment tests.

## Output format

- Verdict: pass / needs changes / blocked
- Seller-side vs payer-side classification
- Required routes to official primitives
- Signing/custody risks
- Payment verification risks
- Required human approvals
- Missing tests
