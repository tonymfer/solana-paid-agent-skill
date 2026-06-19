#!/usr/bin/env python3
"""Validation for solana-paid-agent-skill.

Runs repository-level quality checks without network, wallet, signing,
transaction, or credential access.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "LICENSE",
    "CLAUDE.md",
    "install.sh",
    "skill/SKILL.md",
    "skill/paid-agent-architecture.md",
    "skill/seller-side-x402.md",
    "skill/usage-metering.md",
    "skill/safety-and-signing.md",
    "skill/testing-and-simulation.md",
    "agents/signing-safety-reviewer.md",
    "commands/audit-payment-flow.md",
    "commands/generate-launch-checklist.md",
    "rules/custody.md",
    "rules/signing.md",
    "rules/payments.md",
    "examples/paid-mcp-launch-report.md",
    "templates/payment-required-response.json",
    "templates/payment-proof-retry.json",
    "templates/success-receipt.json",
    "templates/submission-questionnaire.md",
    "templates/demo-script.md",
    "templates/risk-register.md",
    "integration/skill-registry-entry.json",
    "scripts/validate.py",
    "tests/validate_structure.sh",
    ".github/workflows/validate.yml",
]

REQUIRED_PHRASES = {
    "README.md": [
        "Seller-side paid-agent rails",
        "Why this belongs in Solana AI Kit",
        "30-second example use",
        "examples/paid-mcp-launch-report.md",
        "templates/submission-questionnaire.md",
    ],
    "skill/SKILL.md": [
        "Output templates",
        "payment_required",
        "Launch readiness verdict",
    ],
    "skill/seller-side-x402.md": [
        "Concrete planning schema",
        "Verification matrix",
        "payment_required",
    ],
    "examples/paid-mcp-launch-report.md": [
        "generate_agent_launch_report",
        "Verification checklist",
        "Blockers before production",
    ],
    "templates/submission-questionnaire.md": [
        "closest competing skill",
        "seller-side paid-agent rails",
    ],
}

BANNED_PATTERNS = [
    r"TODO|TBD|FIXME|lorem ipsum|placeholder text",
    r"curl\s+.*https?://|wget\s+",
    r"npm install|pnpm add|yarn add",
    r"solana transfer|solana confirm",
    r"sendTransaction|signTransaction",
    r"secretKey|mnemonic|seed phrase:",
]


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    sys.exit(1)


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def check_required_files() -> None:
    missing = [rel for rel in REQUIRED_FILES if not (ROOT / rel).is_file()]
    if missing:
        fail("missing required files: " + ", ".join(missing))
    print("PASS: required files exist")


def check_required_phrases() -> None:
    for rel, phrases in REQUIRED_PHRASES.items():
        text = read(rel)
        for phrase in phrases:
            if phrase not in text:
                fail(f"{rel} missing phrase: {phrase}")
    print("PASS: required phrases present")


def check_json() -> None:
    for rel in [
        "templates/payment-required-response.json",
        "templates/payment-proof-retry.json",
        "templates/success-receipt.json",
        "integration/skill-registry-entry.json",
    ]:
        json.loads(read(rel))
    registry = json.loads(read("integration/skill-registry-entry.json"))
    if registry.get("id") != "solana-paid-agent-skill":
        fail("registry id mismatch")
    if "wallet connection" not in registry.get("safety", ""):
        fail("registry safety field missing wallet safety")
    print("PASS: JSON templates and registry parse")


def check_banned_patterns() -> None:
    scan_dirs = ["README.md", "CLAUDE.md", "install.sh", "skill", "agents", "commands", "rules", "examples", "templates", "integration", "scripts", "tests"]
    files: list[Path] = []
    for item in scan_dirs:
        p = ROOT / item
        if p.is_file():
            files.append(p)
        else:
            files.extend(x for x in p.rglob("*") if x.is_file())
    validator_files = {ROOT / "scripts/validate.py", ROOT / "tests/validate_structure.sh"}
    for path in files:
        if path in validator_files:
            # Validators necessarily contain the banned regexes they enforce.
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        for pattern in BANNED_PATTERNS:
            if re.search(pattern, text, re.IGNORECASE):
                fail(f"banned pattern {pattern!r} in {path.relative_to(ROOT)}")
    print("PASS: no banned unsafe/unfinished patterns in content")


def check_installer_dry_run() -> None:
    out = subprocess.check_output(["bash", "install.sh", "--dry-run"], cwd=ROOT, text=True)
    for phrase in ["DRY RUN", "examples templates integration scripts .github", "No network, wallet, signing, transaction, or credential operations"]:
        if phrase not in out:
            fail(f"installer dry-run missing: {phrase}")
    print("PASS: installer dry-run safe")


def main() -> None:
    check_required_files()
    check_required_phrases()
    check_json()
    check_banned_patterns()
    check_installer_dry_run()
    print("PASS: Python validation complete")


if __name__ == "__main__":
    main()
