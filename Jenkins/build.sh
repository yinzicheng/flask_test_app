#!/bin/sh

set -x

# create and activate vitrualenv first
python -m venv venv
. venv/bin/activate

##following cmd only in dev enviroment
# pip install flask pytest
# pip list
# pip freeze > requirements.txt

python -m pip install --upgrade pip
pip install -r requirements.txt

set +x
