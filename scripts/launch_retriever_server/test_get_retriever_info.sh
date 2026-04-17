#!/bin/bash

BASE_URL="http://localhost:8003"

response=$(curl -s $BASE_URL/retriever_info)

echo "Retriever info:"
echo "$response"
