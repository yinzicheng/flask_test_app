#!/bin/sh

set -x

. venv/bin/activate

env FLASK_APP=app.py flask run &

set +x