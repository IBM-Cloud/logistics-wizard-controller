#!/bin/bash
echo Login IBM Cloud api=$CF_TARGET_URL org=$CF_ORG space=$CF_SPACE
bx login -a "$CF_TARGET_URL" --apikey "$IAM_API_KEY" -o "$CF_ORG" -s "$CF_SPACE"

# get the CFx API key
OPENWHISK_AUTH=`bx wsk property get --auth | awk '{print $3}'`

# Set app's env vars
if [ "$REPO_BRANCH" == "master" ]; then
  LOGISTICS_WIZARD_ENV="PROD"
else
  LOGISTICS_WIZARD_ENV="DEV"
fi
echo "LOGISTICS_WIZARD_ENV: $LOGISTICS_WIZARD_ENV"

domain=".mybluemix.net"
case "${REGION_ID}" in
  ibm:yp:eu-gb)
    domain=".eu-gb.mybluemix.net"
  ;;
  ibm:yp:au-syd)
  domain=".au-syd.mybluemix.net"
  ;;
esac
# Deploy app
if ! bx app show $CF_APP; then
  bx app push $CF_APP -n $CF_APP --no-start
  bx app env-set $CF_APP LOGISTICS_WIZARD_ENV ${LOGISTICS_WIZARD_ENV}
  bx app env-set $CF_APP ERP_SERVICE https://$ERP_SERVICE_APP_NAME$domain
  bx app env-set $CF_APP OPENWHISK_PACKAGE ${RECOMMENDATION_PACKAGE_NAME}
  bx app env-set $CF_APP OPENWHISK_AUTH ${OPENWHISK_AUTH}
  bx app start $CF_APP
else
  OLD_CF_APP=${CF_APP}-OLD-$(date +"%s")
  rollback() {
    set +e
    if bx app show $OLD_CF_APP; then
      bx app logs $CF_APP --recent
      bx app delete $CF_APP -f
      bx app rename $OLD_CF_APP $CF_APP
    fi
    exit 1
  }
  set -e
  trap rollback ERR
  bx app rename $CF_APP $OLD_CF_APP
  bx app push $CF_APP -n $CF_APP --no-start
  bx app env-set $CF_APP LOGISTICS_WIZARD_ENV ${LOGISTICS_WIZARD_ENV}
  bx app env-set $CF_APP ERP_SERVICE https://$ERP_SERVICE_APP_NAME$domain
  bx app env-set $CF_APP OPENWHISK_PACKAGE ${RECOMMENDATION_PACKAGE_NAME}
  bx app env-set $CF_APP OPENWHISK_AUTH ${OPENWHISK_AUTH}
  bx app start $CF_APP
  bx app delete $OLD_CF_APP -f
fi
