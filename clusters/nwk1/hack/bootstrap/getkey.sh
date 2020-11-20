#!/usr/bin/env bash
kubeseal --fetch-cert --controller-name=sealed-secrets --controller-namespace=kube-system > ../secrets/pub-cert.pem
