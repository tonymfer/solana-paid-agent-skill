# Submission Questionnaire

Use this to answer a Superteam / Solana AI Kit skill bounty submission form.

## What did you build?

`solana-paid-agent-skill` — seller-side paid-agent rails for Solana AI agents, APIs, and MCP tools. It helps builders design x402-style 402 challenges, payment proof verification, usage metering, bounded access grants, receipt metadata, and signing/custody safety without reimplementing checkout, wallets, or payer-side x402.

## Why should this be added to Solana AI Kit?

Solana AI Kit already routes builders to payments, Token-2022, Metaplex, and x402 primitives. This skill connects those primitives into the missing seller-side workflow: builders getting paid safely for agent/API/MCP work.

It is additive rather than duplicative:

- checkout / QR / Commerce Kit / Solana Pay routes to official Payments & Commerce;
- buyer agents paying services route to payer-side x402 skills;
- private balances route to Token-2022 Confidential Transfers;
- receipt NFT/SBT implementation routes to Metaplex;
- this skill owns quote, proof, metering, access-grant, receipt semantics, and safety gates for the seller side.

## What is the closest competing skill?

Closest competing skill: payer-side x402 / agent payout skills, especially skills that help agents pay for gated services or receive payouts. This submission is different because it focuses on the merchant/server side: a Solana builder exposes a paid API, MCP tool, or agent service and needs safe quote, verification, metering, idempotency, and bounded access patterns.

## Why is this useful?

Solana founders increasingly expose AI tools, APIs, research agents, launch reports, trading tools, and MCP services. The first monetization question is not just “how do I show a checkout button?” It is:

- what exactly is being sold;
- how a 402/payment-required challenge binds price to a resource;
- how payment proof is verified;
- how retries avoid double charging;
- how usage is metered;
- how refunds/credits/manual review work;
- how to prevent agents from touching private keys, signing, custody, or live-money flows.

## What proof of quality is included?

- Progressive `skill/SKILL.md` router.
- Focused modules for architecture, seller-side x402, usage metering, signing safety, and testing.
- Reusable commands and rules.
- Mock Paid MCP example: `examples/paid-mcp-launch-report.md`.
- Copyable JSON planning templates.
- Suggested Solana AI Kit registry entry.
- Safe local-copy installer with dry-run mode.
- Shell and Python validation scripts.
- GitHub Actions validation workflow.

## Safety boundaries

This skill does not connect wallets, sign transactions, broadcast transactions, custody funds, ask for secrets, fetch installer payloads from the network, or run live-money tests. It routes implementation to official primitives and requires human approval for live-money, credentials, signing, or production facilitator steps.
