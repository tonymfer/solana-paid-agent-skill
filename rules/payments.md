# Payment Rules

Hard rule: this skill provides seller-side paid-agent architecture and review. It does not process payments, connect wallets, sign, or act as a facilitator.

## Required payment separation

Keep these states separate:

1. quote creation,
2. user approval outside this repo,
3. payment observation/proof receipt,
4. verification/confirmation,
5. bounded access grant,
6. usage consumption,
7. refund/credit/manual review.

## Required quote fields

- quote ID,
- price,
- asset,
- network,
- payee/facilitator route,
- expiry,
- resource/body hash,
- idempotency key.

## Required verification checks

- amount,
- asset,
- recipient,
- network,
- quote/reference,
- expiry,
- confirmation state,
- replay/duplicate state.

## Route instead of reimplementing

- Official Payments & Commerce / Commerce Kit / Solana Pay for checkout.
- Token-2022 Confidential Transfers for privacy payments.
- Metaplex for receipt NFTs/SBTs.
- Payer-side x402 skills for buyers.
- PayAI or Corbits for seller-side x402 facilitator/proxy implementation routes.

## Never claim

- guaranteed legal compliance,
- guaranteed tax compliance,
- guaranteed payment compliance,
- production readiness without qualified review.
