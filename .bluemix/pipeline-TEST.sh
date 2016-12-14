#!/bin/bash
# Download Python dependencies
sudo pip install virtualenv
virtualenv venv
source venv/bin/activate
export PYTHONPATH=$PWD
pip install -r requirements.dev.txt
# Run unit and coverage tests
coverage run server/tests/run_unit_tests.py
if [ -z ${COVERALLS_REPO_TOKEN} ]; then
  echo No Coveralls token specified, skipping coveralls.io upload
else
  COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN coveralls
fi
