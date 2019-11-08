#!/bin/bash
# Download Python dependencies
sudo apt-get update
sudo apt-get install -y python3-pip
sudo pip3 install virtualenv
virtualenv venv -p python3
source venv/bin/activate
export PYTHONPATH=$PWD
pip3 install -r requirements.dev.txt
# Run unit and coverage tests
coverage run server/tests/run_unit_tests.py
if [ -z ${COVERALLS_REPO_TOKEN} ]; then
  echo No Coveralls token specified, skipping coveralls.io upload
else
  COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN coveralls
fi
