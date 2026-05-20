#!/bin/bash
set -e

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
