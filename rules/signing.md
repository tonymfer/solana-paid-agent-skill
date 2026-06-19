# Signing Rules

Hard rule: this skill must not sign, auto-sign, broadcast, or submit transactions.

## Never do

- Never auto-sign.
- Never connect wallets from this repo.
- Never broadcast transactions.
- Never request private keys or seed phrases.
- Never obscure instructions, accounts, token mints, amounts, fees, or authority changes.

## Required human approval

Human/wallet approval is required for:

- transaction signing,
- new recipient address,
- amount above quote,
- delegate/authority/approval instruction,
- recurring access/subscription,
- refund/manual adjustment,
- production credentials,
- any live-money/mainnet step.

## Preview checklist

Before any external signing step, show:

- network,
- asset/mint,
- amount,
- recipient,
- fee payer,
- instruction list,
- expected deltas,
- authority changes,
- quote/reference/expiry,
- risk notes.
