#!/bin/bash
set -e
echo run with arguments: "$@"

python3 ./scripts/render_conf_files.py "$@"

#/bin/bash
./bin/launcher run
