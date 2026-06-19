# Custody Rules

Hard rule: this skill must not custody user funds.

## Never do

- Never ask for seed phrases/private keys.
- Never store or transmit signing material.
- Never design a flow where this repo controls user funds.
- Never imply the agent can approve spending on behalf of the user.
- Never hide who receives funds or what access is granted.

## Required design boundary

Seller-side paid-agent rails should separate:

1. quote creation,
2. external user approval/payment,
3. payment observation,
4. verification/confirmation,
5. access granting,
6. usage consumption,
7. refund/credit/manual review.

## Allowed

- Document non-custodial architecture.
- Route to official wallets, Commerce Kit, Solana Pay, PayAI, Corbits, Token-2022 Confidential Transfers, or Metaplex.
- Require human approval and qualified compliance review.
