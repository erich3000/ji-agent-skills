#!/usr/bin/env bash
set -euo pipefail

URL="${1:?Usage: navigate.sh <url>}"

WS=$(cmux identify | jq -r '.caller.workspace_ref')
SURF=$(cmux rpc surface.list "{\"workspace_id\":\"$WS\"}" | jq -r '[.surfaces[] | select(.type == "browser")] | first | .ref // empty')

if [ -z "$SURF" ]; then
  cmux browser open-split "$URL"
else
  cmux browser "$SURF" navigate "$URL"
  cmux browser "$SURF" wait --load-state complete
fi
