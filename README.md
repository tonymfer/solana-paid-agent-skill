# solana-paid-agent-skill

Seller-side paid-agent rails for Solana AI agents, APIs, and MCP tools.
It helps builders charge for agent work with x402-style 402 responses, payment verification, usage metering, access control, and safety gates.
It complements checkout/payment and payer-side x402 skills; it does not reimplement wallet checkout, custodial payments, or transaction signing.

Existing skills help agents pay. Official commerce skills help humans check out. This skill helps Solana builders get paid safely for their own agents, APIs, and MCP tools.

## What this is

This is a lean documentation/agent-skill router for builders designing seller-side paid access. It is not a payment processor, facilitator, wallet, checkout UI, or generic payer-side x402 client.

Use it when you are exposing a paid Solana-aware API, MCP tool, or agent service and need a safe architecture for:

- HTTP 402/x402-style seller flows.
- Paid MCP tool calls.
- Quote, payment observation, verification, access granting, metering, and refund/credit state separation.
- Safety review around wallet, signing, custody, credentials, and transaction previews.

## What this routes to instead of reimplementing

- Checkout, payment buttons, QR payment requests, Commerce Kit, and Solana Pay: route to official Payments & Commerce / Commerce Kit / Solana Pay docs and skills.
- Buyer/payer agents paying x402-gated services: route to payer-side x402 skills such as second-state/x402-skill or official x402 client docs.
- Private payment balances: route to Token-2022 Confidential Transfers.
- Receipt NFTs/SBTs or access NFTs: route implementation to Metaplex; this skill only covers receipt semantics and privacy cautions.
- Facilitators/proxies: consider PayAI merchant/server middleware or Corbits hosted proxy where appropriate; do not clone them here.

Verified references used from the Research report:

- Solana Skills page lists Payments & Commerce: "Build checkout flows, payment buttons, and QR-based payment requests using Commerce Kit and Solana Pay." https://solana.com/skills
- Solana x402 page says x402 lets web services charge for API/content access without accounts or subscriptions. https://solana.com/x402
- PayAI merchant docs say x402 lets merchants monetize HTTP APIs/content while keeping an existing server stack. https://docs.payai.network/x402/servers/introduction
- Corbits docs describe adding x402 payments to existing APIs via hosted proxy configuration. https://docs.corbits.dev/
- second-state/x402-skill is payer/client-oriented: agents seamlessly pay for x402-gated services. https://github.com/second-state/x402-skill
- Solana Skills page lists Confidential Transfers for Token-2022 private encrypted balances. https://solana.com/skills
- Solana Skills page lists Metaplex Skill for NFT/token metadata development. https://solana.com/skills

## Safety hard rules

These are non-negotiable:

1. Never ask for, store, log, transmit, or infer seed phrases/private keys.
2. Never auto-sign transactions or imply the agent can approve wallet actions for the user.
3. Never hide transaction instructions, accounts, token mints, amounts, fees, or authority changes.
4. Never custody user funds or design flows that require custody unless a future explicitly approved scope changes the product.
5. Never run live wallet connections, signing, or transactions in tests or demos for this repo.
6. Separate quote creation, user approval, payment observation, confirmation, access granting, usage consumption, and refund/credit handling.
7. Bind payment proofs to a quote/resource/idempotency key; reject replayed or mismatched proofs.
8. Use explicit expiry for quotes and bounded access windows for grants.
9. Treat duplicate payments, expired quotes, failed jobs, and verifier downtime as first-class states.
10. Do not present legal, tax, payment, or compliance claims as certainty; mark them for qualified review.
11. Use mocks/simulation by default; devnet examples only if explicitly authorized; mainnet live funds never in validation.
12. If a requested implementation would require violating these rules, stop and mark blocked rather than continuing.

## Demo scenarios

### Demo 1: Paid MCP/x402 tool call

A builder exposes an MCP tool such as `generate_agent_launch_report`.

1. User calls the MCP tool without payment proof.
2. Tool returns a structured `payment_required` response with quote ID, price, asset/network, recipient placeholder, expiry, resource hash, and retry instructions.
3. User pays externally using a wallet, official checkout primitive, or payer-side x402 skill.
4. User retries the tool with a payment reference/proof.
5. Server verifies amount, asset, recipient, network, quote, expiry, and idempotency binding.
6. Server runs the job once, stores the result, meters usage, and returns receipt metadata.
7. Retry returns the same result/receipt metadata without double charging.

### Demo 2: Paid API endpoint

HTTP endpoint `/v1/agent/report` returns a 402 challenge first, then grants one bounded report after proof verification. Focus: resource-bound quotes, proof replay rejection, and access/result cache.

### Demo 3: Prepaid credits

User buys credits externally, then spends them on bounded agent jobs. Focus: ledger states, duplicate payments, failed-job credit restoration, and manual review.

### Demo 4: Signing safety review

Builder proposes a flow where an agent signs or refunds automatically. Expected result: block auto-signing, require human wallet approval, produce a transaction preview checklist, and flag legal/compliance claims for qualified review.

## Install

Run:

```sh
bash install.sh --target ~/.hermes/skills/solana-paid-agent-skill
```

The installer performs only local file copies. It does not fetch from the network, connect wallets, sign, broadcast, or touch credentials.

## Validate

```sh
bash tests/validate_structure.sh
```
