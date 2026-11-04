# Deploy — data.incensehub.org

This is a Python/MkDocs site, not a Node site.

## Cloudflare Pages (Git integration)

- Build command: `pip install -r requirements.txt && mkdocs build`
- Build output directory: `site`
- Root directory: `/`
- Python: 3.12 (set `PYTHON_VERSION=3.12` if the dashboard asks)

A `package.json` shim is included so the default `npm run build` also works:
it runs `bash build.sh`, which installs MkDocs into a local `.deps/` directory (no venv or system pip needed) and builds.
`wrangler.toml` sets `pages_build_output_dir = "site"`.

## Local

```bash
python3 -m pip install -r requirements.txt
python3 -m mkdocs build
```
