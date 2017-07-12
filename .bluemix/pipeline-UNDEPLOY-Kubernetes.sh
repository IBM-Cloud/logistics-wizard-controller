#!/bin/bash

mkdir /tmp/bin
export PATH="/tmp/bin:$PATH"

curl -L https://git.io/getIstio | sh -
(cd istio-* && ln -s $PWD/bin/istioctl /tmp/bin/istioctl)
istioctl version

istioctl delete -f lw-controller-routes.yml
kubectl delete -f lw-controller-deployment.yml
kubectl delete secret lw-controller-env
