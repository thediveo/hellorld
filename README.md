A tiny experimental repository for automatically building multi-arch (Docker)
container images and releasing them to ghcr.io.

## Github Workflow

See `.github/workflows/buildandrelease.yaml`.

## Local Build

Running `scripts/builder.sh`...
1. starts a local registry v2 service on port 5000, if not already started.
2. calls into `scripts/docker-build.sh` ... which is a very elaborate script
   wrapping `docker buildx build ...` with the ability to transfer the current
   workspace (if any) into the Go build stage.

Then, to pull and run the world-rocking "hellorld":
```bash
docker run -it --rm localhost:5000/hellorld
```
