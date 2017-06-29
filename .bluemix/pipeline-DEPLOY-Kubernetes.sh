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

mkdir /tmp/bin
export PATH="/tmp/bin:$PATH"

figlet -f small 'kubectl'
wget --quiet --output-document=/tmp/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x /tmp/bin/kubectl

figlet -f small 'istioctl'
curl -L https://git.io/getIstio | sh -
(cd istio-* && ln -s $PWD/bin/istioctl /tmp/bin/istioctl)

figlet 'Logging in Bluemix'
bx login -a "$CF_TARGET_URL" --apikey "$BLUEMIX_API_KEY" -o "$CF_ORG" -s "$CF_SPACE"
bx cs init

figlet 'Configuring kubectl'
exp=$(bx cs cluster-config $CLUSTER_NAME | grep export)
eval "$exp"

kubectl version
istioctl version

echo "Using Docker image $IMAGE_NAME"
ESCAPED_IMAGE_NAME=$(echo $IMAGE_NAME | sed 's/\//\\\//g')
cat lw-controller-deployment.yml | sed 's/registry.ng.bluemix.net\/<namespace>\/lw-controller:latest/'$ESCAPED_IMAGE_NAME'/g' > tmp-controller.yml

echo -e 'Deploying service...'
istioctl delete -f lw-controller-routes.yml
istioctl create -f lw-controller-routes.yml
kubectl apply -f <(istioctl kube-inject -f tmp-controller.yml --includeIPRanges=10.0.0.1/24)
