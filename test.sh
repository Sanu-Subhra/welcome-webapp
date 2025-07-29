#!/bin/bash
echo "Running tests"
if grep -q "Welcome to My Web App" index.html; 
then
    echo "Test passed: Welcome message found."
    exit 0
else
    echo "Test failed: Welcome message not found."
    exit 1
fi
