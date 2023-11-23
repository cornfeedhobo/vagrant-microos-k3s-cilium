#!/usr/bin/env bash
set -xeuo pipefail

# Upgrade everything
zypper --non-interactive dup
