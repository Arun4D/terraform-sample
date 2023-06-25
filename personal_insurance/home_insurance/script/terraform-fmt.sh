#!/usr/bin/env bash
echo "==> Checking terraform codes are formatted..."
error=false
terraform fmt  -recursive || error=true
if ${error}; then
  echo "------------------------------------------------"
  echo ""
  echo "The preceding files contain terraform codes that are not correctly formatted or contain errors."
  echo ""
   echo "------------------------------------------------"
  exit 1
fi
exit 0