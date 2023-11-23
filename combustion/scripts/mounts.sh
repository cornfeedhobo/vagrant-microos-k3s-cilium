#!/usr/bin/env bash
set -xeuo pipefail

# Mount needed rw directories that are normally
# unavailable during transactional-update.
mount /usr/local
mount /var
mount /home
