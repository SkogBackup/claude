#!/bin/bash

set -e

printf "gh auth status:\n"
gh auth status
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
printf "repo: %s\n" "$REPO"
AVAILABLE_SECRETS=$(gh secret list --org skogai)
printf "available secrets: \n%s\n" "$AVAILABLE_SECRETS"
