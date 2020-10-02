#!/bin/sh

set -x
python -m pip install --upgrade pip

python -m venv venv
source venv/bin/activate

##following cmd only in dev enviroment
# pip install flask pytest
# pip list
# pip freeze > requirements.txt

pip install -r requirements.txt
set +x