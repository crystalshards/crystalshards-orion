#!/usr/bin/env bash
# Setup environment variables to allow helm to connect to the gitlab-managed
# tiller in the ops cluster. It will- download the tls certs/key to the current
# directory.

TILLER_NS=${1-"gitlab-managed-apps"}
CONTEXT=gke_crystalshards-org_us-central1-a_production

mkdir -p tmp
kubectl --context $CONTEXT get secret tiller-secret -n $TILLER_NS -o "jsonpath={.data['ca\.crt']}" | base64 -D > tmp/tiller-ca.crt
kubectl --context $CONTEXT get secret tiller-secret -n $TILLER_NS -o "jsonpath={.data['tls\.crt']}" | base64 -D > tmp/tiller.crt
kubectl --context $CONTEXT get secret tiller-secret -n $TILLER_NS -o "jsonpath={.data['tls\.key']}" | base64 -D > tmp/tiller.key

export HELM_TLS_ENABLE=true
export HELM_TLS_CA_CERT=$(pwd)/tmp/tiller-ca.crt
export HELM_TLS_CERT=$(pwd)/tmp/tiller.crt
export HELM_TLS_KEY=$(pwd)/tmp/tiller.key
export TILLER_NAMESPACE=gitlab-managed-apps
