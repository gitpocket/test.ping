#!/bin/bash

set -e

# Pull in the ansible-lint project
echo "===== Cloning Ansible-Lint Project ====="
git clone https://github.com/willthames/ansible-lint.git "$WORKSPACE/ansible-lint"

# Setup path for ansible-lint command
echo "===== Setting PYTHONPATH ====="
echo $PYTHONPATH
export PYTHONPATH=$PYTHONPATH:`pwd`/ansible-lint/lib
echo $PYTHONPATH

# Invoke the test
echo "===== Invoking Test ====="
python ansible-lint/bin/ansible-lint ansible-lint/examples/play.yml
