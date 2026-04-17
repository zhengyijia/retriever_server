#!/bin/bash

BASE_URL="http://localhost:8003"

response=$(curl -X POST $BASE_URL/retrieve \
  -H "Content-Type: application/json" \
  -d '{
    "queries": ["What is retrieval?", "What is a retriever model?"],
    "topk": 3,
    "mode": "text"
  }')

echo "Retrieval response:"
echo "$response"

