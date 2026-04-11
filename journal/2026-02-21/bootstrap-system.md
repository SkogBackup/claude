# Bootstrap System for Fresh Arch Installs

Built `SkogAI/bootstrap` — a public repo that reduces ~13 manual post-archinstall steps to a single curl|bash one-liner with one vault password prompt.

## What it solves

Three problems from `projects/newinstall/steps.md`:
1. AUR helper (yay) not available early enough
2. SSH key setup was a 5-step manual process with org name confusion
3. No automation — everything was copy-paste from docs

## Architecture

Three-phase bash script (~200 lines):
- **Phase 1 (Foundation)**: pacman -Syu, install git/base-devel/openssh/gh/ansible-core, build yay from AUR
- **Phase 2 (Secret Unlock)**: clone public repo, ansible-vault decrypt (password via /dev/tty works in curl|bash context), extract tar.gz
- **Phase 3 (Identity)**: deploy SSH keys (dynamic key type detection), git config, gh auth with PAT, verify

Secrets stored as ansible-vault encrypted tar.gz containing ed25519 keys, a fine-grained GitHub PAT, and git identity.

## Key decisions

- **Public repo**: required for curl|bash to work without auth on fresh machines. Vault encryption is the security layer.
- **ansible-vault over age/sops**: already in the package list (ansible-core), getpass reads from /dev/tty which works in piped context
- **ed25519 over RSA**: user had both, ed25519 is modern standard
- **Dynamic key detection**: script handles any key type found in vault, no hardcoded filenames
- **DRY_RUN mode**: `DRY_RUN=true` prints actions without executing — useful for verification
- **Makefile for vault ops**: encrypt/decrypt/edit/verify/lint/clean — the `edit` target is particularly nice (decrypt, drop into shell, re-encrypt on exit)

## Gotcha: master vs main

The repo uses `master` as default branch. All raw.githubusercontent.com URLs must use `/master/` not `/main/`. Caught this when the curl one-liner 404'd on first test.
