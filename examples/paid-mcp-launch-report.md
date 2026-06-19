# Example: Paid MCP launch report tool

This example shows the expected output shape when an agent uses `solana-paid-agent-skill` to design a seller-side paid MCP tool. It is intentionally mock-only: no wallet connection, signing, broadcasting, live facilitator call, or credential handling.

## Scenario

A founder exposes an MCP tool:

```txt
generate_agent_launch_report(project_url, target_audience, depth)
```

The report is expensive to generate, so the server charges 1 USDC per completed report.

## Design brief

- Product being sold: one AI-generated Solana agent launch report.
- Protected resource/tool/API: MCP tool `generate_agent_launch_report`.
- Payment route: seller-side 402 challenge; payer completes payment externally using official checkout, facilitator, or payer-side x402 skill.
- Quote fields: price, asset, network, recipient/facilitator, expiry, resource hash, idempotency key.
- Verification source: payment/facilitator verifier selected by the builder after checking current upstream docs.
- Access grant scope: one report for the exact resource hash and idempotency key.
- Usage ledger states: quoted → payment_pending → paid_unconsumed → running → succeeded_consumed.
- Refund/credit/manual-review states: expired, failed_refundable, duplicate_payment_manual_review, verifier_unavailable.
- Safety gates: no custody, no private keys, no auto-signing, no live transaction in tests.
- Routes to existing Solana AI Kit skills: Payments & Commerce for checkout UX, Token-2022 Confidential Transfers for private balances, Metaplex for receipt NFT/SBT implementation if needed.

## Initial MCP response

```json
{
  "type": "payment_required",
  "quote_id": "quote_launch_report_001",
  "resource": "mcp.generate_agent_launch_report",
  "resource_hash": "sha256:redacted-tool-args",
  "price": { "amount": "1.00", "asset": "USDC", "network": "solana" },
  "recipient": "merchant_or_facilitator_identifier",
  "expires_at": "2026-01-01T00:05:00Z",
  "idempotency_key": "idem_launch_report_user_resource",
  "retry_with": { "payment_reference": "transaction_or_facilitator_reference" }
}
```

## Retry with proof

```json
{
  "quote_id": "quote_launch_report_001",
  "idempotency_key": "idem_launch_report_user_resource",
  "payment_reference": "transaction_or_facilitator_reference",
  "resource_hash": "sha256:redacted-tool-args"
}
```

## Verification checklist

| Check | Expected |
|---|---|
| Quote binding | Quote ID, idempotency key, and resource hash match. |
| Amount/asset/network | 1.00 USDC on Solana. |
| Recipient/facilitator | Expected merchant or facilitator route. |
| Expiry | Proof observed before quote expiry. |
| Replay | Proof not previously consumed for another job. |
| Confirmation | Verifier returns acceptable confirmation state. |
| Access scope | One report only; no reusable broad access. |

## Success response

```json
{
  "status": "succeeded_consumed",
  "result_ref": "report_cache_key_or_result_id",
  "receipt": {
    "quote_id": "quote_launch_report_001",
    "payment_reference_hash": "sha256:payment-reference",
    "consumed_units": 1,
    "access_scope": "single_report"
  }
}
```

## Blockers before production

- Verify exact current x402/facilitator field names and verification API.
- Decide whether receipt metadata is off-chain only or routes to Metaplex.
- Add app-specific abuse limits and manual review policy.
- Run only mock/local tests unless a human explicitly authorizes devnet/live-money testing.
