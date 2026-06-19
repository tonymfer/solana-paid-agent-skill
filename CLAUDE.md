# CLAUDE.md

This repo is a lean Solana AI skill for seller-side paid-agent rails.

Hard boundaries for any assistant working here:

- Do not add wallet connection code.
- Do not add signing, broadcasting, transaction submission, or credential handling.
- Do not fetch installer payloads from the network.
- Do not turn this into a generic checkout guide or payer-side x402 client.
- Route checkout to official Payments & Commerce / Commerce Kit / Solana Pay.
- Route private balances to Token-2022 Confidential Transfers.
- Route receipt NFT/SBT implementation to Metaplex.
- Route buyer payment flows to payer-side x402 skills.

Default contribution shape: markdown guidance, rules, command prompts, and local validation only.
