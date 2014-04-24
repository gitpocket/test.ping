#!/bin/bash

set -e

for dir in defaults handlers meta tasks vars
do
    # Basic YAML syntax checking script
    echo "===== Checking $dir directory ====="
    python test.ping/syntax_check.py role/$dir/*.yml
done
