# Seller-Side x402

## Purpose

Specify seller-side x402-style paid API/MCP flows without reimplementing a full protocol library.

## Verified positioning

- Solana x402 is for web services charging for API/content access.
- PayAI merchant docs validate the server role: advertise payment requirements, verify payments, fulfill requests, settle payments.
- Corbits validates a hosted proxy route for adding x402 payments to existing APIs.
- Payer-side skills help agents pay; this module helps builders get paid.

## Seller-side flow

1. Request arrives without valid payment proof or access token.
2. Server returns a 402/payment-required challenge with:
   - quote ID,
   - price,
   - asset/network,
   - pay-to target or facilitator route,
   - expiry,
   - resource identifier/body hash,
   - idempotency key,
   - retry instructions.
3. Payer completes payment externally through wallet, checkout, facilitator, or payer-side skill.
4. Client retries with payment reference/proof.
5. Seller verifies amount, asset, recipient, network, reference/idempotency key, expiry, and confirmation state.
6. Seller grants bounded access and records usage.

## Paid MCP first-class pattern

- MCP tool call returns a structured `payment_required` response instead of hidden wallet work.
- Follow-up call includes payment reference/proof.
- Tool returns receipt metadata, consumed units, and remaining access scope.
- Protected output is not leaked before payment verification.

## Concrete planning schema

Use this as a product/agent planning schema, not a claim that every x402 implementation uses these exact field names. Before writing protocol code, verify the current upstream package/facilitator docs.

### 402 / payment-required response

```json
{
  "type": "payment_required",
  "quote_id": "quote_2026_001",
  "resource": "mcp.generate_agent_launch_report",
  "resource_hash": "sha256:request-body-or-tool-args",
  "price": {
    "amount": "1.00",
    "asset": "USDC",
    "network": "solana"
  },
  "recipient": "merchant_or_facilitator_identifier",
  "expires_at": "2026-01-01T00:05:00Z",
  "idempotency_key": "idem_user_resource_quote",
  "retry_with": {
    "payment_reference": "transaction_or_facilitator_reference"
  }
}
```

### Payment proof retry

```json
{
  "quote_id": "quote_2026_001",
  "idempotency_key": "idem_user_resource_quote",
  "payment_reference": "transaction_or_facilitator_reference",
  "resource_hash": "sha256:request-body-or-tool-args"
}
```

### Success response

```json
{
  "status": "succeeded_consumed",
  "result_ref": "result_or_cache_key",
  "receipt": {
    "quote_id": "quote_2026_001",
    "payment_reference_hash": "sha256:payment-reference",
    "consumed_units": 1,
    "access_scope": "single_tool_call"
  }
}
```

## Verification matrix

| Check | Accept when | Reject/manual-review when |
|---|---|---|
| Quote binding | quote ID, resource hash, and idempotency key match | missing, mismatched, or reused for different resource |
| Amount/asset/network | exact quoted amount, supported asset, expected network | underpaid, wrong token, wrong network |
| Recipient/facilitator | expected merchant/facilitator route | unexpected payee or ambiguous route |
| Expiry | payment observed before quote expiry | expired quote or unclear timestamp |
| Replay | proof not previously consumed | proof already consumed or duplicate retry with different body |
| Confirmation | verifier reports acceptable confirmation state | verifier unavailable, pending too long, or conflicting result |
| Access scope | bounded to one job/resource/window | broad reusable access not explicitly priced |

## Verification concepts

Reject proofs that are:

- mismatched to quote/resource/body hash,
- expired,
- replayed,
- underpaid,
- wrong asset/network/recipient,
- over-broad for the requested access,
- already consumed.

## Protocol field caution

Exact x402 header and field names change by implementation. Verify current upstream docs before writing code. Use placeholders in planning docs until exact fields are verified.

## Error states

- payment_required
- payment_pending
- invalid_proof
- expired_quote
- already_consumed
- underpaid
- verifier_unavailable
- duplicate_payment_manual_review

## Out of scope

- Building a payer-side purchasing agent.
- Signing transactions.
- Holding private keys.
- Shipping a facilitator/proxy clone.

## Acceptance quality

A builder can design a 402 challenge/verify/grant loop for an MCP tool or API and know where protocol-specific verification remains.
