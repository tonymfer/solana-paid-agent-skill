# Safety and Signing

## Purpose

Centralize safety boundaries for wallet, signing, custody, credentials, and transaction UX.

## Non-negotiable rules

1. Never ask for, store, log, transmit, or infer seed phrases/private keys.
2. Never auto-sign transactions or imply the agent can approve wallet actions for the user.
3. Never hide transaction instructions, accounts, token mints, amounts, fees, or authority changes.
4. Never custody user funds or design flows that require custody unless explicitly approved later.
5. Never run live wallet connections, signing, or transactions in tests or demos for this repo.
6. Do not present legal, tax, payment, or compliance claims as certainty.

## Human approval gates

Require explicit human/wallet approval for:

- any transaction signing,
- any new recipient address,
- higher-than-quoted amount,
- authority/delegate/approval instruction,
- recurring access/subscription,
- refund/manual adjustment,
- production facilitator credentials,
- mainnet/live-money steps.

## Transaction preview requirements

Before a user signs elsewhere, show:

- network,
- asset/mint,
- amount,
- recipient,
- fee payer,
- instruction list,
- expected token/SOL deltas,
- authority changes,
- quote/reference/expiry,
- risk notes and compliance qualified-review items.

## Safe agent behavior

Agents may:

- prepare explanations,
- inspect unsigned transaction descriptions,
- simulate or mock flows when authorized,
- produce checklists,
- route to official primitives.

Agents must not:

- connect wallets in this repo,
- sign or broadcast,
- store credentials,
- hide risks,
- normalize private-key pasting.

## Failure modes

- malicious payment proof,
- mismatched recipient,
- wrong cluster/network,
- fake token mint,
- replayed reference,
- overpayment/underpayment,
- user sends funds without quote,
- verifier unavailable,
- facilitator credential misconfiguration.

## Out of scope

- Code that signs or broadcasts live transactions.
- Custodial key management.
- Legal compliance certification.

## Acceptance quality

Any generated architecture or implementation checklist applies these rules before suggesting wallet/payment logic.
