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

```bash
cd terraform/cloudflare/origin-certs-chatup
# needs TF_VAR_noizu_cloudflare_api_token with "SSL and Certificates: Edit" (Origin CA) scope
terragrunt apply          # mints CF Origin CA cert (local state)
infisical-populate-secrets   # pushes cert -> Infisical /apps/tls/chatuptherobotcodes
```

Then in the Cloudflare dashboard set the `chatup.therobot.codes` zone **SSL/TLS
mode = Full (Strict)** (the origin now has a valid CF Origin CA cert).

### 2. GitHub Actions on `main`

1. Build + smoke the nginx image (`/nginx-health`, fallback `GET /`)
2. Push `sha-<7>` to `ops.noizu.com` — never `:latest`
3. Bot commits the helm tag bump (`ci: deploy sha-XXX [skip ci]`)
4. ArgoCD auto-syncs (wired in `trl-infra`)

Never bump chart tags, merge, or push `main` by hand.

## License

MIT © TheRobotLives
