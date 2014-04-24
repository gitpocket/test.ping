#!/bin/bash

set -e

echo "===== Cloning Ansible-Lint Project ====="
echo 'git clone https://github.com/willthames/ansible-lint.git "$WORKSPACE/ansible-lint"'
git clone https://github.com/willthames/ansible-lint.git "$WORKSPACE/ansible-lint"

# Setup path for ansible-lint command
echo "===== Setting PYTHONPATH ====="
export PYTHONPATH=$PYTHONPATH:"$WORKSPACE/ansible-lint/lib"

# invoke the test
echo "===== Invoking Test ====="
"python $WORKSPACE/ansible-lint/bin/ansible-lint" "$WORKSPACE/ansible-lint/examples/play.yml"
