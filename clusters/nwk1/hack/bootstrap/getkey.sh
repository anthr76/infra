#!/usr/bin/env bash
kubeseal --fetch-cert --controller-name=sealed-secrets --controller-namespace=kube-system > hack/secrets/pub-cert.pem
