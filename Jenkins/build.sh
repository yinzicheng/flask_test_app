#!/bin/sh

set -x

python -m venv venv
. venv/bin/activate

python -m pip install --upgrade pip

##following cmd only in dev enviroment
# pip install flask pytest
# pip list
# pip freeze > requirements.txt

pip install -r requirements.txt

set +x