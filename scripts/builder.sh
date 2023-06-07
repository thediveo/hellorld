#!/bin/sh

# Note: requires qemu to be installed. On Debian-based distros, install using
# "sudo apt-get install -y qemu qemu-user-static".

PLATFORMS="linux/amd64,linux/arm64"

BOBTHEBUILDER="builderbob"

# Had our builder been created in the past and still exists?
if ! docker buildx inspect "${BOBTHEBUILDER}"; then
    docker buildx create --name "${BOBTHEBUILDER}" --bootstrap --platform "${PLATFORMS}"
fi

docker buildx build --builder "${BOBTHEBUILDER}" --platform "${PLATFORMS}" -t hellorld -f deployments/hellorld/Dockerfile
