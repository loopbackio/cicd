#!/bin/sh
# SPDX-FileCopyrightText: LoopBack Contributors
# SPDX-License-Identifier: MIT
set -eu
export POSIXLY_CORRECT=1

SCRIPT_DIR="$(dirname $0)"
RENOVATE_CONFIG_ROOT="$SCRIPT_DIR/../shared-configs/renovate"

find "$RENOVATE_CONFIG_ROOT" -name *.yaml -type f | \
    xargs -I'{}' \
        env RENOVATE_CONFIG_FILE='{}' \
            npm exec \
                --no-install \
                --package=renovate \
                -- \
                renovate-config-validator
