#!/bin/bash
# A very simple JQ test

echo '{"counts": {}}' > /tmp/test.json

REPO="test-repo"
jq --arg repo "$REPO" '.counts[$repo] = (.counts[$repo] // 0) + 1' /tmp/test.json

echo "JQ test completed"