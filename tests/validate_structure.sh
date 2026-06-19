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
  examples/paid-mcp-launch-report.md
  templates/payment-required-response.json
  templates/payment-proof-retry.json
  templates/success-receipt.json
  templates/submission-questionnaire.md
  templates/demo-script.md
  templates/risk-register.md
  integration/skill-registry-entry.json
  scripts/validate.py
  .github/workflows/validate.yml
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
example_files=$(find examples -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')
json_template_files=$(find templates -maxdepth 1 -type f -name '*.json' | wc -l | tr -d ' ')
md_template_files=$(find templates -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')
integration_files=$(find integration -maxdepth 1 -type f -name '*.json' | wc -l | tr -d ' ')

[[ "${skill_modules}" == "5" ]] || fail "expected 5 skill modules, got ${skill_modules}"
[[ "${agent_files}" == "1" ]] || fail "expected 1 agent file, got ${agent_files}"
[[ "${command_files}" == "2" ]] || fail "expected 2 command files, got ${command_files}"
[[ "${rule_files}" == "3" ]] || fail "expected 3 rule files, got ${rule_files}"
[[ "${example_files}" == "1" ]] || fail "expected 1 example file, got ${example_files}"
[[ "${json_template_files}" == "3" ]] || fail "expected 3 JSON template files, got ${json_template_files}"
[[ "${md_template_files}" == "3" ]] || fail "expected 3 markdown template files, got ${md_template_files}"
[[ "${integration_files}" == "1" ]] || fail "expected 1 integration file, got ${integration_files}"
pass "file counts match required lean v1 structure plus examples/templates/integration"

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
grep -q "Why this belongs in Solana AI Kit" README.md || fail "README missing Solana AI Kit fit section"
grep -q "~/.claude/skills/solana-paid-agent-skill" README.md || fail "README missing Claude/Solana AI Kit install path"
grep -q "Optional Hermes install" README.md || fail "README missing optional Hermes install note"
grep -q "Output templates" skill/SKILL.md || fail "SKILL missing output templates section"
grep -q "Paid MCP / API design brief" skill/SKILL.md || fail "SKILL missing design brief template"
grep -q "402 challenge sketch" skill/SKILL.md || fail "SKILL missing 402 challenge template"
grep -q "Launch readiness verdict" skill/SKILL.md || fail "SKILL missing launch readiness template"
grep -q "Concrete planning schema" skill/seller-side-x402.md || fail "seller-side-x402 missing concrete planning schema"
grep -q '"type": "payment_required"' skill/seller-side-x402.md || fail "seller-side-x402 missing payment_required JSON schema"
grep -q "Verification matrix" skill/seller-side-x402.md || fail "seller-side-x402 missing verification matrix"
grep -q "30-second example use" README.md || fail "README missing 30-second example"
grep -q "examples/paid-mcp-launch-report.md" README.md || fail "README missing example link"
grep -q "integration/skill-registry-entry.json" README.md || fail "README missing registry entry mention"
grep -q "templates/submission-questionnaire.md" README.md || fail "README missing submission template mention"
grep -q "examples/paid-mcp-launch-report.md" skill/SKILL.md || fail "SKILL missing example pointer"
grep -q '"type": "payment_required"' templates/payment-required-response.json || fail "payment-required template missing type"
grep -q '"payment_reference"' templates/payment-proof-retry.json || fail "payment-proof template missing payment_reference"
grep -q '"succeeded_consumed"' templates/success-receipt.json || fail "success template missing succeeded_consumed"
grep -q '"id": "solana-paid-agent-skill"' integration/skill-registry-entry.json || fail "registry entry missing id"
grep -q "generate_agent_launch_report" examples/paid-mcp-launch-report.md || fail "example missing paid MCP scenario"
grep -q "closest competing skill" templates/submission-questionnaire.md || fail "submission questionnaire missing competitor answer"
grep -q "Safety fail demo" templates/demo-script.md || fail "demo script missing safety fail demo"
grep -q "Payment proof replay" templates/risk-register.md || fail "risk register missing replay risk"
grep -q "python3 scripts/validate.py" .github/workflows/validate.yml || fail "GitHub workflow missing Python validation"
pass "README/SKILL key phrases, examples, templates, and registry metadata present"

if grep -RInE 'TODO|TBD|FIXME|lorem ipsum|placeholder text' README.md skill agents commands rules examples templates integration CLAUDE.md; then
  fail "obvious placeholder TODOs found in core docs"
fi
pass "no obvious placeholder TODOs in core docs"

if grep -RInE 'RelAI' README.md skill agents commands rules examples templates integration CLAUDE.md | grep -v "Unverified and intentionally not cited"; then
  fail "unverified RelAI guidance found"
fi
pass "no unverified RelAI guidance"

if grep -RInE 'curl .*http|wget |npm install|pnpm add|yarn add|solana transfer|solana confirm|sendTransaction|signTransaction|secretKey|mnemonic|seed phrase:' install.sh skill agents commands rules examples templates integration README.md CLAUDE.md; then
  fail "possible network/wallet/signing/credential instruction found"
fi
pass "no obvious network fetch, wallet connection, signing, transaction, or credential instructions"

dry_run_output="$(bash install.sh --dry-run)"
echo "${dry_run_output}" | grep -q "DRY RUN" || fail "installer dry-run did not report DRY RUN"
echo "${dry_run_output}" | grep -q "examples templates integration scripts .github" || fail "installer dry-run missing examples/templates/integration/scripts/.github copy set"
echo "${dry_run_output}" | grep -q "No network, wallet, signing, transaction, or credential operations" || fail "installer dry-run missing safety statement"
pass "installer dry-run is safe and includes all artifact groups"

python3 -m json.tool templates/payment-required-response.json >/dev/null || fail "invalid JSON: payment-required-response"
python3 -m json.tool templates/payment-proof-retry.json >/dev/null || fail "invalid JSON: payment-proof-retry"
python3 -m json.tool templates/success-receipt.json >/dev/null || fail "invalid JSON: success-receipt"
python3 -m json.tool integration/skill-registry-entry.json >/dev/null || fail "invalid JSON: registry entry"
pass "JSON templates and registry entry parse"

python3 scripts/validate.py >/tmp/solana-paid-agent-python-validate.log || { cat /tmp/solana-paid-agent-python-validate.log >&2; fail "Python validator failed"; }
pass "Python validator passes"

pass "structure validation complete"
