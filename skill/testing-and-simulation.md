# Testing and Simulation

## Purpose

Validate this skill repo and proposed paid-agent flows without live wallet mutation or funds.

## Structure validation

Run:

```sh
bash tests/validate_structure.sh
```

The script checks required files, exact lean structure, executable installer, Claude/Solana AI Kit install path, dry-run installer behavior, key positioning phrases, output templates, example artifacts, registry entry shape, safety phrases, and obvious placeholder markers in core docs.

## Flow simulation targets

Use mocks or written state tables for:

- mock 402 challenge,
- mock payment proof accepted,
- mock payment proof rejected,
- expired quote,
- duplicate proof replay,
- idempotent retry,
- failed job refund/credit state,
- verifier unavailable.

## No-live-funds rule

Validation must not:

- connect a wallet,
- sign,
- broadcast,
- submit transactions,
- use credentials,
- call production facilitator APIs.

Devnet examples are allowed only after explicit authorization. Mainnet live funds are never part of this repo validation.

## QA checklist

- Required files exist.
- README top says seller-side paid-agent rails.
- README distinguishes existing agent-payment skills, official checkout skills, and this builder-get-paid skill.
- Paid MCP/x402 is first demo.
- Safety hard rules appear in README, SKILL, and rules.
- Route to official Payments & Commerce, Token-2022 Confidential Transfers, Metaplex, and payer-side x402 rather than reimplementing.

## Out of scope

- Live network payment tests.
- Real wallet interaction.
- Credentials or facilitator production setup.

## Acceptance quality

QA can run one deterministic shell script and review state transitions without connecting a wallet or making network transactions.
