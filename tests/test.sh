#!/bin/bash

set -e

DRONEDIR="/var/cache/drone/src/github.com/rack-roles/test.ping"

for dir in tests
do
    # Basic YAML syntax checking script
    echo "===== Checking $dir directory ====="
    python $DRONEDIR/yaml_check.py $DRONEDIR/$dir/*.yml
done
for dir in tests
do
    # Basic YAML syntax checking script
    echo "===== Checking $dir directory ====="
    python $DRONEDIR/jinja_check.py $DRONEDIR/$dir/*.j2
done
