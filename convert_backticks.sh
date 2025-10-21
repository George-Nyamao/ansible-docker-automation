#!/bin/bash

# Script to convert single quotes to backticks in markdown files

echo "Converting README.md..."
sed -i "s/'''/\`\`\`/g" README.md

echo "Converting DEPLOYMENT.md..."
sed -i "s/'''/\`\`\`/g" DEPLOYMENT.md

echo "Conversion complete!"

# Verify the files
echo ""
echo "Checking README.md..."
grep -c '```' README.md && echo "README.md: Backticks found!" || echo "README.md: No backticks found!"

echo ""
echo "Checking DEPLOYMENT.md..."
grep -c '```' DEPLOYMENT.md && echo "DEPLOYMENT.md: Backticks found!" || echo "DEPLOYMENT.md: No backticks found!"

echo ""
echo "Done! Files are ready to commit."
