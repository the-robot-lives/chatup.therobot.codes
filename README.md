# chatup.therobot.codes

Landing page for **Chat to Markdown** — a local-only browser extension that
exports ChatGPT, Claude, Gemini, Le Chat, Open WebUI and more as clean Markdown
or API-format YAML.

Plugin: [the-robot-lives/chat-to-markdown](https://github.com/the-robot-lives/chat-to-markdown)

Part of [The Robot Lives](https://therobotlives.com) portfolio.

## Stack

- Hand-authored static HTML (`web/`)
- nginx Alpine image (`ops.noizu.com/chatup.therobot.codes/web:sha-*`)
- Helm chart `helm/chatup` wrapping the vendored `static-site` subchart

## Local sandbox

```bash
make sandbox        # http://127.0.0.1:8787
make sandbox-stop
```

## Deploy

PRs target `develop`. `main` is CI/CD-only.

### 1. Provision the origin TLS cert (once)

`chatup.therobot.codes` is an A record on the existing `therobot.codes` zone
(TRL Cloudflare account). Origin CA stack is local-state terraform (no
terragrunt), in the **monorepo**:

```bash
cd terraform/cloudflare/origin-certs-chatup
# needs TF_VAR_trl_cloudflare_api_token with "SSL and Certificates: Edit" (Origin CA)
terraform init
terraform apply          # writes .secrets/tls/chatuptherobotcodes/{cert,key}.pem
cd ../../..
infisical-populate-secrets --include apps-tls-chatuptherobotcodes
```

Zone SSL/TLS mode is already Full (Strict) on `therobot.codes`. A 526 means
the origin ingress is presenting a cert that does not include
`chatup.therobot.codes`.

### 2. GitHub Actions on `main`

1. Build + smoke the nginx image (`/nginx-health`, fallback `GET /`)
2. Push `sha-<7>` to `ops.noizu.com` — never `:latest`
3. Bot commits the helm tag bump (`ci: deploy sha-XXX [skip ci]`)
4. ArgoCD auto-syncs (wired in `trl-infra`)

Never bump chart tags, merge, or push `main` by hand.

## License

MIT © TheRobotLives
