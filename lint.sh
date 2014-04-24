#!/bin/bash

set -e

for dir in defaults handlers meta tasks vars
do
    # Basic YAML syntax checking script
    echo "===== Checking $i directory ====="
    python test.ping/syntax_check.py role/$i/*.yml
done
