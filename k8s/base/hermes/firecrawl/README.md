# Firecrawl for Hermes (qgr1)

This deploys a private scrape API in `hermes`. It does **not** change Hermes or its SearXNG search backend. No Firecrawl Cloud account, LLM keys, ingress or persistent volumes are required. The API has no client authentication; keep it behind the Hermes-only network policy.

## Deployment

The app-template release follows [upstream Compose](https://github.com/firecrawl/firecrawl/blob/8b950c45c8ca/docker-compose.yaml): the API harness runs its workers and talks to Playwright, Redis, RabbitMQ and NUQ Postgres. These are single-replica workloads with disposable state; pod replacement can lose jobs. Intended for interactive Markdown scraping, not a durable crawl queue.

The upstream example Helm chart puts database credentials in a ConfigMap and defaults to third-party images. This release instead uses the cluster's existing app-template chart, generated External Secrets and digest-pinned images. The API (amd64) and browser share upstream revision `8b950c45c8ca`; the Postgres build at `a7a63b4bfabf` has the same `apps/nuq-postgres` source tree as that revision.

Only Hermes should call `http://firecrawl-api.hermes.svc.cluster.local:3002`. API and browser pods have public IPv4 web egress on TCP 80/443, DNS, and the explicit internal peer connections in the Cilium policies. Use the local browser for private URLs. Do not expose this service through a route.

## Acceptance checks after Flux reconciliation

```sh
kubectl -n flux-system get kustomization firecrawl
kubectl -n hermes get helmrelease firecrawl
kubectl -n hermes get pods -l firecrawl.kutara.io/component
```

Wait for all five components to be Ready. From **inside the Hermes pod**, run:

```sh
B=http://firecrawl-api.hermes.svc.cluster.local:3002
curl -fsS "$B/v0/health/readiness"
curl -fsS "$B/v2/scrape" -H 'Content-Type: application/json'   -d '{"url":"https://example.com","formats":["markdown"]}' | python -c 'import json,sys; j=json.load(sys.stdin); assert j["success"] and "Example Domain" in j["data"]["markdown"]'
```

Also confirm that an unrelated pod cannot reach the API and that a request through Firecrawl to a **controlled private test page** cannot return that page. A manifest dry run tests neither connectivity nor extraction.

## Cutover and rollback (separate change)

Only after those checks pass, add `FIRECRAWL_API_URL=http://firecrawl-api.hermes.svc.cluster.local:3002` to the Hermes workload via GitOps. With the new environment present, record the old `web.extract_backend` setting, run `hermes config set web.extract_backend firecrawl`, then test `web_extract` against the same public page in a fresh session. Leave `web.search_backend` unchanged. The installed Hermes Firecrawl provider accepts a self-hosted URL without a cloud key.

To roll back, restore the previous extractor setting (remove the field if it was absent), then revert the endpoint environment change. Remove the Firecrawl workload only after Hermes no longer selects it.
