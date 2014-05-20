#!/bin/bash

set -e

DRONEDIR="/var/cache/drone/src/github.com/rack-roles/test.ping"

for dir in tests
do
    # Basic YAML syntax checking script
    echo "===== Checking YAML in $dir ====="
    python $DRONEDIR/yaml_check.py $DRONEDIR/$dir/*.yml
done
for dir in tests
do
    # Basic Jinja syntax checking script
    echo "===== Checking Jinja in $dir ====="
    python $DRONEDIR/jinja_check.py $DRONEDIR/$dir
done
