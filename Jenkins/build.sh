#!/bin/sh

set -x
python -m pip install --upgrade pip

##following cmd only in dev enviroment
# python -m venv venv
# source venv/bin/activate
# pip install flask pytest
# pip list
# pip freeze > requirements.txt

pip install -r requirements.txt
set +x