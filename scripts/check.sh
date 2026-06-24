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
echo " Running checks for module: $MODULE_DIR"
echo "================================================"

# Enter the module directory
cd "$MODULE_DIR"

echo "- Formatting..."
terraform fmt -check

echo "- Linting..."
# Explicitly point to the root config so tflint finds your custom plugins
tflint --init --config="$REPO_ROOT/.tflint.hcl" > /dev/null # Silence when plugins are already installed
tflint --config="$REPO_ROOT/.tflint.hcl"

echo "- Initializing..."
terraform init -backend=false -upgrade > /dev/null # Silence noisy stdout

echo "- Validating..."
VALIDATE_OUTPUT=$(terraform validate -json)
echo "$VALIDATE_OUTPUT" | jq -r '
  .diagnostics[] |
  "\(if .severity == "error" then "ERROR" elif .severity == "warning" then "WARNING" else .severity | ascii_upcase end): \(.summary)\(if .detail != "" then "\n  \(.detail)" else "" end)\(if .range then "\n  at \(.range.filename):\(.range.start.line)" else "" end)"
'
ERROR_COUNT=$(echo "$VALIDATE_OUTPUT" | jq '[.diagnostics[] | select(.severity == "error")] | length')
WARNING_COUNT=$(echo "$VALIDATE_OUTPUT" | jq '[.diagnostics[] | select(.severity == "warning")] | length')
if [ "$ERROR_COUNT" -gt 0 ] || [ "$WARNING_COUNT" -gt 0 ]; then
  echo "Validation failed: $ERROR_COUNT error(s), $WARNING_COUNT warning(s)"
  exit 1
fi
echo "Success! The configuration is valid."
