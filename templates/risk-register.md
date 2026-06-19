# Risk Register

Use this when reviewing a seller-side paid-agent flow.

| Risk | Severity | Why it matters | Mitigation |
|---|---:|---|---|
| Agent requests seed phrase/private key | Critical | Irreversible account compromise | Block; route wallet approval outside agent; never collect secrets |
| Agent auto-signs or broadcasts transactions | Critical | User loses approval control | Human wallet approval only; show transaction preview |
| Payment proof replay | High | One payment unlocks multiple jobs | Bind proof to quote, resource hash, and idempotency key |
| Underpayment / wrong asset / wrong network | High | Seller grants access without correct payment | Verify amount, asset, network, recipient, confirmation |
| Duplicate payment | Medium | User can be overcharged or support burden rises | Credit/manual-review state; idempotent retry semantics |
| Verifier outage | Medium | Access can be incorrectly denied or granted | Safe pending/manual-review path; no optimistic fulfillment unless explicitly designed |
| Over-broad access grant | High | One purchase unlocks more than priced | Bound access to one resource/job/window |
| Sensitive receipt metadata | Medium | Prompts/results or private balances can leak | Hash payment reference; avoid sensitive on-chain/public receipt fields |
| Compliance certainty claims | Medium | Legal/tax/payment statements can mislead users | Mark for qualified review; no definitive legal claims |
| Checkout duplication | Low | Reimplements official skills and bloats package | Route checkout/QR/Commerce Kit/Solana Pay to official Payments & Commerce |
