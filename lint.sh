#!/bin/bash

set -e

# Pull in the ansible-lint project
echo "===== Cloning Ansible-Lint Project ====="
git clone https://github.com/willthames/ansible-lint.git "$WORKSPACE/ansible-lint"

# Setup path for ansible-lint command
echo "===== Setting PYTHONPATH ====="
export PYTHONPATH=$PYTHONPATH:"$WORKSPACE/ansible-lint/lib"

# Invoke the test
echo "===== Invoking Test ====="
python ansible-lint/bin/ansible-lint ansible-lint/examples/play.yml
