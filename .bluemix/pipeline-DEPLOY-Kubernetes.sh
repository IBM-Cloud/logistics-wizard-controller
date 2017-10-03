#!/bin/bash

if [ -f "image.env" ]; then
  echo 'Loading image name from image.env file.'
  source image.env
  echo "IMAGE_NAME=${IMAGE_NAME}"
else
  echo 'IMAGE_NAME not set'
  exit 1;
fi

echo 'Installing dependencies...'
sudo apt-get -qq update 1>/dev/null
sudo apt-get -qq install figlet 1>/dev/null
sudo apt-get -qq install jq 1>/dev/null

mkdir /tmp/bin
export PATH="/tmp/bin:$PATH"

figlet -f small 'istioctl'
curl -L https://git.io/getLatestIstio | sh -
(cd istio-* && ln -s $PWD/bin/istioctl /tmp/bin/istioctl)
istioctl version

if [ -z "$OPENWHISK_API_HOST" ]; then
  echo 'OPENWHISK_API_HOST is not defined. Using default value.'
  export OPENWHISK_API_HOST=openwhisk.ng.bluemix.net
fi

if [ -z "$OPENWHISK_AUTH" ]; then
  echo 'OPENWHISK_AUTH is not defined. Retrieving OpenWhisk authorization key...'
  CF_ACCESS_TOKEN=`cat ~/.cf/config.json | jq -r .AccessToken | awk '{print $2}'`
  OPENWHISK_KEYS=`curl -XPOST -k -d "{ \"accessToken\" : \"$CF_ACCESS_TOKEN\", \"refreshToken\" : \"$CF_ACCESS_TOKEN\" }" \
    -H 'Content-Type:application/json' https://$OPENWHISK_API_HOST/bluemix/v2/authenticate`
  SPACE_KEY=`echo $OPENWHISK_KEYS | jq -r '.namespaces[] | select(.name == "'$CF_ORG'_'$CF_SPACE'") | .key'`
  SPACE_UUID=`echo $OPENWHISK_KEYS | jq -r '.namespaces[] | select(.name == "'$CF_ORG'_'$CF_SPACE'") | .uuid'`
  OPENWHISK_AUTH=$SPACE_UUID:$SPACE_KEY
fi

# create secret with the OPENWHISK_AUTH and RECOMMENDATION_PACKAGE_NAME
kubectl delete secret lw-controller-env
kubectl create secret generic lw-controller-env \
  --from-literal=OPENWHISK_AUTH="${OPENWHISK_AUTH}" \
  --from-literal=OPENWHISK_PACKAGE="${RECOMMENDATION_PACKAGE_NAME}"

echo "Using Docker image $IMAGE_NAME"
ESCAPED_IMAGE_NAME=$(echo $IMAGE_NAME | sed 's/\//\\\//g')
cat lw-controller-deployment.yml | sed 's/registry.ng.bluemix.net\/<namespace>\/lw-controller:latest/'$ESCAPED_IMAGE_NAME'/g' > tmp-controller.yml

echo -e 'Deploying service...'
istioctl delete -f lw-controller-routes.yml
istioctl create -f lw-controller-routes.yml
kubectl apply -f <(istioctl kube-inject -f tmp-controller.yml --includeIPRanges=172.30.0.0/16,172.20.0.0/16,10.0.0.1/24)
