## (Multi Architecture) hellorld

A tiny experimental repository for automatically building multi-arch (Docker)
container images and releasing them to ghcr.io.

It is on purpose slightly more complex than the usual run-of-the-mill blog post
or the official documentation shows. Don't get me wrong: the official
documentation was a great help here. As for blog posts and StuckOverflaw, yeah,
*shrug*.

Anyway, this repo shows how to build a multi-arch container image using Docker's
buildx and pushing it to some registry. Building and pushing can be done (1) in
a Github workflow, or (2) purely locally with a local registry.

## Dockerfile

This is a usual multi-staged build, but with the typical twist of running all
build stages execpt for the final one for the build platform. Only the final
build stage is target platform-specific. For the Go binary build stage we always
use the build platform and then simply cross-compile, one of the greatest
features of the Go toolchain.

## Github Workflow

See `.github/workflows/buildandrelease.yaml` for the ugly details.

Most notable: the workflow emulates the (dynamic) Go workspace we use for local
builds. This is something that is only necessary in those situations where a
complex service needs to be build locally for rapid turn-arounds, such as my
infamous [lxkns](https://github.com/thediveo/lxkns) Linux namespaces and
container discovery service. This Go workspace isn't needed, but by
emulating/faking it the workflow reuses the same Dockerfile with its multiple
stages that is used for the local builds.

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

Again, this is more complex than what usually is needed. This example uses the
method of dynamic Go workspaces in Docker image builds that is used in
[lxkns](https://github.com/thediveo/lxkns). This method allows to build local
image test versions not inside a clean CI/CD pipeline, but instead inside an
optional Go workspace when hacking on dependency (upstream) modules.

When building the Go binaries we use Docker's suggestion of mounting caches for
just these build steps. This will be useless in the Github workflow, but it
won't hurt either; thus, we can use the same Dockerfile both locally as well as
in the CI/CD pipeline.
