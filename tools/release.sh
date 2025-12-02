#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=${IMAGE_NAME:-sinatra-skeleton}
REGISTRY_IMAGE=${REGISTRY_IMAGE:-doridoridoriand/${IMAGE_NAME}}
BUILDX_NAME=${BUILDX_NAME:-${IMAGE_NAME}-builder}
PLATFORMS=${PLATFORMS:-linux/amd64,linux/arm64}
VERSION=${VERSION:-$(date +%s)}

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker engine not running or unreachable. Build failed." >&2
  exit 1
fi

EXISTING_BUILDER=$(docker buildx ls 2>/dev/null | grep "${BUILDX_NAME}" || true)
if [ -n "${EXISTING_BUILDER}" ]; then
  docker buildx rm "${BUILDX_NAME}"
fi

docker login
docker buildx create --name "${BUILDX_NAME}" --use

docker buildx build \
  --platform "${PLATFORMS}" \
  --tag "${REGISTRY_IMAGE}:latest" \
  --tag "${REGISTRY_IMAGE}:${VERSION}" \
  --push \
  -f Dockerfile .

docker buildx rm "${BUILDX_NAME}"
