---
name: solana-paid-agent-skill
description: Seller-side paid-agent rails for Solana AI agents, APIs, and MCP tools: x402-style 402 flows, usage metering, payment verification, access control, and signing safety.
version: 0.1.0
license: MIT
---

# Solana Paid Agent Skill

Use this skill when designing or reviewing a Solana-aware agent, API, or MCP tool that needs to charge users safely. This is seller-side: it helps the service provider expose paid access. It does not implement wallet checkout, custody, auto-signing, or payer-side purchasing agents.

Existing skills help agents pay. Official commerce skills help humans check out. This skill helps Solana builders get paid safely for their own agents, APIs, and MCP tools.

## Routing table

| User asks for | Load | Goal |
|---|---|---|
| Overall architecture for a paid Solana agent/API/MCP tool | `paid-agent-architecture.md` | Choose payment boundary, state machine, access model, and non-custodial responsibilities. |
| Paid MCP, paid API, HTTP 402, x402 seller flow, payment-required responses | `seller-side-x402.md` | Design seller-side 402 challenge, payment verification, retry, replay protection, and access grant. |
| Usage credits, per-call billing, job billing, metering, refunds, duplicate requests | `usage-metering.md` | Design ledger, idempotency keys, job states, credit consumption, and failure/refund behavior. |
| Wallet safety, transaction approval, custody, signing UX, risk review | `safety-and-signing.md` | Enforce no-custody/no-auto-signing rules and human-readable transaction risk gates. |
| Devnet/local testing, simulation, mock payment flows, validation script, QA checklist | `testing-and-simulation.md` | Test without live funds or real wallet signing; validate file structure and state transitions. |

## Route away from this skill

- Checkout, payment buttons, QR payments, Commerce Kit, or Solana Pay: use official Payments & Commerce / Commerce Kit / Solana Pay.
- Buyer agent paying someone else: use payer-side x402 skills.
- Private balances: use Token-2022 Confidential Transfers.
- Receipt NFTs/SBT implementation: use Metaplex.

## Always apply rules

- `rules/custody.md`
- `rules/signing.md`
- `rules/payments.md`

## Safety hard rules

1. Never ask for, store, log, transmit, or infer seed phrases/private keys.
2. Never auto-sign transactions or imply the agent can approve wallet actions for the user.
3. Never hide transaction instructions, accounts, token mints, amounts, fees, or authority changes.
4. Never custody user funds or design flows that require custody unless explicitly approved later.
5. Never run live wallet connections, signing, or transactions in tests or demos for this repo.
6. Separate quote creation, user approval, payment observation, confirmation, access granting, usage consumption, and refund/credit handling.
7. Bind payment proofs to a quote/resource/idempotency key; reject replayed or mismatched proofs.
8. Use explicit expiry for quotes and bounded access windows for grants.
9. Treat duplicate payments, expired quotes, failed jobs, and verifier downtime as first-class states.
10. Do not present legal, tax, payment, or compliance claims as certainty; mark them for qualified review.

## Default workflow

1. Start with `paid-agent-architecture.md` unless the user names a narrower flow.
2. For Paid MCP/x402, load `seller-side-x402.md` first, then `usage-metering.md`, then `testing-and-simulation.md`.
3. For any transaction or wallet concern, load `safety-and-signing.md` and all rules before proposing implementation details.
4. If exact protocol fields are required, verify current upstream docs before writing code.
