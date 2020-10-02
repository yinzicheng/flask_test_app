#!/bin/sh

set -x

. venv/bin/activate
python -m pytest

set +x
