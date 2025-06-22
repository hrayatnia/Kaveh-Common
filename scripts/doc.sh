#!/bin/bash
set -e

echo "📖 Generating documentation..."
mkdir -p ./docs  # Ensure the directory exists
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target Kaveh-Common --output-path ./docs \
    --transform-for-static-hosting --hosting-base-path Kaveh-Common

echo "🔍 Checking generated docs:"
ls -la ./docs