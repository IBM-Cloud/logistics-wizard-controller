#!/bin/bash
echo Login IBM Cloud api=$CF_TARGET_URL org=$CF_ORG space=$CF_SPACE
ibmcloud login -a "$CF_TARGET_URL" --apikey "$IAM_API_KEY" -o "$CF_ORG" -s "$CF_SPACE" -g "$RESOURCE_GROUP"

# get latest plugins (1.0.32 of cloud-functions had an issue retrieving apihost)
ibmcloud plugin update --all

# show existing namespaces
ibmcloud fn namespace list

# get the namespace URL
OPENWHISK_HOST=$(ibmcloud fn property get --apihost -o raw)
NAMESPACE_INSTANCE_ID=$(ibmcloud fn namespace get $FUNCTIONS_NAMESPACE --properties | grep ID | awk '{print $2}')
FUNCTIONS_NAMESPACE_URL=https://${OPENWHISK_HOST}/api/v1/web/${NAMESPACE_INSTANCE_ID}/${RECOMMENDATION_PACKAGE_NAME}

echo "Cloud Functions host is $OPENWHISK_HOST"
echo "Namespace Instance ID is $NAMESPACE_INSTANCE_ID"
echo "URL to call functions is $FUNCTIONS_NAMESPACE_URL"

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
if ! ibmcloud cf app $CF_APP; then
  ibmcloud cf push $CF_APP -n $CF_APP --no-start
  ibmcloud cf set-env $CF_APP LOGISTICS_WIZARD_ENV ${LOGISTICS_WIZARD_ENV}
  ibmcloud cf set-env $CF_APP ERP_SERVICE https://$ERP_SERVICE_APP_NAME$domain
  ibmcloud cf set-env $CF_APP FUNCTIONS_NAMESPACE_URL ${FUNCTIONS_NAMESPACE_URL}
  ibmcloud cf start $CF_APP
else
  OLD_CF_APP=${CF_APP}-OLD-$(date +"%s")
  rollback() {
    set +e
    if ibmcloud cf app $OLD_CF_APP; then
      ibmcloud cf logs $CF_APP --recent
      ibmcloud cf delete $CF_APP -f
      ibmcloud cf rename $OLD_CF_APP $CF_APP
    fi
    exit 1
  }
  set -e
  trap rollback ERR
  ibmcloud cf rename $CF_APP $OLD_CF_APP
  ibmcloud cf push $CF_APP -n $CF_APP --no-start
  ibmcloud cf set-env $CF_APP LOGISTICS_WIZARD_ENV ${LOGISTICS_WIZARD_ENV}
  ibmcloud cf set-env $CF_APP ERP_SERVICE https://$ERP_SERVICE_APP_NAME$domain
  ibmcloud cf set-env $CF_APP FUNCTIONS_NAMESPACE_URL ${FUNCTIONS_NAMESPACE_URL}
  ibmcloud cf start $CF_APP
  ibmcloud cf delete $OLD_CF_APP -f
fi
