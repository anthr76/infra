# SearXNG for Hermes

Private, stateless search service in namespace `hermes`. No ingress or HTTPRoute;
Cilium permits only Hermes pods to reach TCP 8080. Search egress is limited to
public IPv4 HTTP/HTTPS and cluster DNS; private networks remain excluded.

The signing key is generated in-cluster by External Secrets with CreatedOnce.
No credentials or search history are stored in Git. Cache is disposable emptyDir.
The limiter is intentionally disabled for this single-client private service;
there is no Valkey dependency. Revisit authentication and limiting before exposing
this service to other clients or adding an ingress.

## Activation after merge

1. Wait for Flux Kustomization `searxng` and HelmRelease `hermes/searxng` to
   report Ready. The Hermes Kustomization depends on this health check.
2. The Hermes environment update rolls its pod, adding:
   `SEARXNG_URL=http://searxng.hermes.svc.cluster.local:8080`.
3. From Hermes, verify `/healthz`, then request
   `/search?q=SearXNG&format=json`. Require HTTP 200, valid JSON, and non-empty
   `results`; inspect `unresponsive_engines` rather than treating an empty search
   as a successful test.
4. Only after that succeeds, use the supported Hermes CLI (active default profile):
   ```sh
   /opt/hermes/bin/hermes config set web.search_backend searxng
   /opt/hermes/bin/hermes config get web.search_backend
   ```
   Do not hand-edit config.yaml or replace the rest of the user's config.
5. Exercise Hermes `web_search` and confirm returned titles/URLs. If a running
   session retains the previous provider, start a new session and verify again.

SearXNG is search-only. `web.extract_backend` is intentionally unchanged; URL
extraction needs a separate provider. This PR does not buy or configure one.

## Rollback

Before activation, record `hermes config get web.search_backend`. Restore that
value with `hermes config set` if it was explicit; if unset/default, run
`hermes config unset web.search_backend`. Verify searches on the prior provider
before reverting this PR to remove the service, policy allowance, and URL env.
Do not remove the service while Hermes is still explicitly selecting SearXNG.

## Verification boundaries

Kustomize and Helm rendering validate manifests, not upstream-engine availability.
Read-only cluster credentials cannot deploy, exec, read Secrets, or fetch pod logs.
Runtime health, Cilium reachability, upstream engine responses, and the final Hermes
provider call must be verified after the approved GitOps deployment.
