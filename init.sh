#!/bin/bash
set -e

# Guard: refuse to run inside the tmpl.nvim template repo itself
REMOTE_URL=$(git remote get-url origin 2>/dev/null || true)
if [[ "$REMOTE_URL" == *"tmpl.nvim"* ]]; then
    echo "Error: this script must not be run inside the tmpl.nvim template repo" >&2
    exit 1
fi

# Prompt for variables
read -r -p "github org (e.g. your-org): " ORG
read -r -p "plugin name (e.g. myplugin): " NAME

if [[ -z "$ORG" || -z "$NAME" ]]; then
    echo "Error: org and name must not be empty" >&2
    exit 1
fi

# Rename plugin/@NAME@.vim -> plugin/<name>.vim
git mv "plugin/@NAME@.vim" "plugin/${NAME}.vim"

# Rename tests/@NAME@_spec.lua -> tests/<name>_spec.lua
git mv "tests/@NAME@_spec.lua" "tests/${NAME}_spec.lua"

# Substitute placeholder tokens in affected files
FILES=(
    ".cqfdrc"
    "plugin/${NAME}.vim"
    "tests/minimal_init.lua"
    "tests/${NAME}_spec.lua"
)

for f in "${FILES[@]}"; do
    sed -i \
        -e "s/@ORG@/${ORG}/g" \
        -e "s/@NAME@/${NAME}/g" \
        "$f"
done

# Stage substituted files
git add "${FILES[@]}"

# Remove this script
git rm --force init.sh

# Commit
git commit -m "init: configure plugin as ${ORG}/${NAME}"
