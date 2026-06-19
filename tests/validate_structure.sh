#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

required_files=(
  README.md
  LICENSE
  install.sh
  CLAUDE.md
  skill/SKILL.md
  skill/paid-agent-architecture.md
  skill/seller-side-x402.md
  skill/usage-metering.md
  skill/safety-and-signing.md
  skill/testing-and-simulation.md
  agents/signing-safety-reviewer.md
  commands/audit-payment-flow.md
  commands/generate-launch-checklist.md
  rules/custody.md
  rules/signing.md
  rules/payments.md
  tests/validate_structure.sh
)

for file in "${required_files[@]}"; do
  [[ -f "${file}" ]] || fail "missing required file: ${file}"
done
pass "all required files exist"

[[ -x install.sh ]] || fail "install.sh is not executable"
[[ -x tests/validate_structure.sh ]] || fail "tests/validate_structure.sh is not executable"
pass "required scripts are executable"

skill_modules=$(find skill -maxdepth 1 -type f -name '*.md' ! -name 'SKILL.md' | wc -l | tr -d ' ')
agent_files=$(find agents -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')
command_files=$(find commands -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')
rule_files=$(find rules -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')

[[ "${skill_modules}" == "5" ]] || fail "expected 5 skill modules, got ${skill_modules}"
[[ "${agent_files}" == "1" ]] || fail "expected 1 agent file, got ${agent_files}"
[[ "${command_files}" == "2" ]] || fail "expected 2 command files, got ${command_files}"
[[ "${rule_files}" == "3" ]] || fail "expected 3 rule files, got ${rule_files}"
pass "file counts match required lean v1 structure"

head -n 5 README.md | grep -q "Seller-side paid-agent rails" || fail "README top missing seller-side phrase"
grep -q "Existing skills help agents pay" README.md || fail "README missing existing skills distinction"
grep -q "Official commerce skills help humans check out" README.md || fail "README missing official commerce distinction"
grep -q "builders get paid safely" README.md || fail "README missing builder-get-paid distinction"
grep -q "Paid MCP/x402" README.md || fail "README missing Paid MCP/x402 demo"
grep -q "seller-side" skill/SKILL.md || fail "SKILL missing seller-side positioning"
grep -q "Never ask for, store, log, transmit, or infer seed phrases/private keys" README.md || fail "README missing safety hard rule"
grep -q "Never auto-sign" skill/SKILL.md || fail "SKILL missing auto-sign safety rule"
grep -q "Token-2022 Confidential Transfers" README.md || fail "README missing confidential transfers routing"
grep -q "Metaplex" README.md || fail "README missing Metaplex routing"
pass "README/SKILL key phrases present"

if grep -RInE 'TODO|TBD|FIXME|lorem ipsum|placeholder text' README.md skill agents commands rules CLAUDE.md; then
  fail "obvious placeholder TODOs found in core docs"
fi
pass "no obvious placeholder TODOs in core docs"

if grep -RInE 'RelAI' README.md skill agents commands rules CLAUDE.md | grep -v "Unverified and intentionally not cited"; then
  fail "unverified RelAI guidance found"
fi
pass "no unverified RelAI guidance"

if grep -RInE 'curl .*http|wget |npm install|pnpm add|yarn add|solana transfer|solana confirm|sendTransaction|signTransaction|secretKey|mnemonic|seed phrase:' install.sh skill agents commands rules README.md CLAUDE.md; then
  fail "possible network/wallet/signing/credential instruction found"
fi
pass "no obvious network fetch, wallet connection, signing, transaction, or credential instructions"

pass "structure validation complete"
