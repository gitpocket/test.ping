#!/bin/bash

set -e

# Clone the ansible-lint repository
rm -rf ansible-lint
git clone git@github.com:willthames/ansible-lint.git

export PYTHONPATH=$PYTHONPATH:`pwd`/ansible-lint/lib

ansible-lint ping.yml
