#!/usr/bin/env bash
# Build the ZIP uploaded at platform.openai.com/plugins: the contents of plugins/openai
# at the archive root, named after plugin.json's version. Prints the ZIP's path.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
src="$root/plugins/openai"
version="$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["version"])' "$src/plugin.json")"
out="$root/dist/velo-openai-$version.zip"

mkdir -p "$root/dist"
rm -f "$out"
# README.md is notes for us, not part of the package.
(cd "$src" && zip -r -X -q "$out" . -x 'README.md' -x '*.DS_Store' -x '__MACOSX/*')
echo "$out"
