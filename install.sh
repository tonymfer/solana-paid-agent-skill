#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"

if [[ "${TARGET}" == "--target" ]]; then
  TARGET="${2:-}"
fi

if [[ -z "${TARGET}" ]]; then
  cat <<'USAGE'
Usage: bash install.sh --target /path/to/skills/solana-paid-agent-skill

Safe local-copy installer:
- no network fetch
- no wallet connection
- no signing
- no transactions
- no credentials
USAGE
  exit 2
fi

case "${TARGET}" in
  /*) ;;
  *) echo "ERROR: target must be an absolute path" >&2; exit 2 ;;
esac

mkdir -p "${TARGET}"
for entry in README.md LICENSE CLAUDE.md skill agents commands rules; do
  if [[ -e "${ROOT_DIR}/${entry}" ]]; then
    cp -R "${ROOT_DIR}/${entry}" "${TARGET}/"
  fi
done

echo "Installed solana-paid-agent-skill docs to ${TARGET}"
echo "No network, wallet, signing, transaction, or credential operations were performed."
