#!/bin/bash

set -e

# Clone the ansible-lint repository
rm -rf $WORKSPACE/ansible-lint
git clone https://github.com/willthames/ansible-lint.git $WORKSPACE/

# Setup path for ansible-lint command
export PYTHONPATH=$PYTHONPATH:$WORKSPACE/ansible-lint/lib

# invoke the test
$WORKSPACE/ansible-lint/bin/ansible-lint ping.yml
