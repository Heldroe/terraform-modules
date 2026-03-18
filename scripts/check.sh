#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <module_directory>"
  exit 1
fi

MODULE_DIR=$1
REPO_ROOT=$(git rev-parse --show-toplevel)

# Setup provider cache
export TF_PLUGIN_CACHE_DIR="$REPO_ROOT/.terraform.d/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"

echo "================================================"
echo "🚀 Running checks for module: $MODULE_DIR"
echo "================================================"

# Enter the module directory
cd "$MODULE_DIR"

echo "✨ Formatting..."
terraform fmt -check

echo "🔍 Linting (tflint)..."
# Explicitly point to the root config so tflint finds your custom plugins
tflint --init --config="$REPO_ROOT/.tflint.hcl"
tflint --config="$REPO_ROOT/.tflint.hcl"

echo "⚙️  Initializing..."
terraform init -backend=false

echo "✅ Validating..."
terraform validate

echo "🎉 Success for $MODULE_DIR!"
echo ""
