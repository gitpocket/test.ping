#!/bin/bash

set -e

DRONEDIR="/var/cache/drone/src/github.com/rack-roles/*"

for dir in defaults handlers meta tasks vars tests
do
    # Basic YAML syntax checking script
    echo "===== Checking YAML in $dir ====="
    python test.ping/yaml_check.py $DRONEDIR/$dir/*.yml
done
for dir in templates
do
    # Basic Jinja syntax checking script
    echo "===== Checking Jinja in $dir ====="
    python test.ping/jinja_check.py $DRONEDIR/$dir
done
