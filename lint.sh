#!/bin/bash

set -e

# Clone the ansible-lint repository
rm -rf ansible-lint
git clone https://github.com/willthames/ansible-lint.git

export PYTHONPATH=$PYTHONPATH:`pwd`/ansible-lint/lib

ansible-lint/bin/ansible-lint ping.yml
