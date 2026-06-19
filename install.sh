#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${HOME}/.claude/skills/solana-paid-agent-skill"
DRY_RUN=false

print_help() {
  cat <<'USAGE'
Usage: bash install.sh [--target /absolute/path] [--dry-run] [--help]

Default target:
  ~/.claude/skills/solana-paid-agent-skill

Examples:
  bash install.sh
  bash install.sh --target ~/.claude/skills/solana-paid-agent-skill
  bash install.sh --target ./.claude/skills/solana-paid-agent-skill
  bash install.sh --target ~/.hermes/skills/solana-paid-agent-skill

Safe local-copy installer:
- no network fetch
- no wallet connection
- no signing
- no transactions
- no credentials
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      [[ -n "${TARGET}" ]] || { echo "ERROR: --target requires a path" >&2; exit 2; }
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      print_help >&2
      exit 2
      ;;
  esac
done

# Expand leading ~ without eval.
case "${TARGET}" in
  ~) TARGET="${HOME}" ;;
  ~/*) TARGET="${HOME}/${TARGET#~/}" ;;
esac

# Allow project-local ./.claude installs; otherwise require absolute paths.
case "${TARGET}" in
  /*|./.claude/*) ;;
  *) echo "ERROR: target must be absolute or project-local ./.claude/..." >&2; exit 2 ;;
esac

entries=(README.md LICENSE CLAUDE.md skill agents commands rules examples templates integration scripts .github)

if [[ "${DRY_RUN}" == "true" ]]; then
  echo "DRY RUN: would install solana-paid-agent-skill to ${TARGET}"
  printf 'Would copy:'
  for entry in "${entries[@]}"; do
    [[ -e "${ROOT_DIR}/${entry}" ]] && printf ' %s' "${entry}"
  done
  printf '\n'
  echo "No network, wallet, signing, transaction, or credential operations would be performed."
  exit 0
fi

mkdir -p "${TARGET}"
for entry in "${entries[@]}"; do
  if [[ -e "${ROOT_DIR}/${entry}" ]]; then
    rm -rf "${TARGET}/${entry}"
    cp -R "${ROOT_DIR}/${entry}" "${TARGET}/"
  fi
done

echo "Installed solana-paid-agent-skill docs to ${TARGET}"
echo "No network, wallet, signing, transaction, or credential operations were performed."
