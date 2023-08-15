#!/bin/sh

# Build docker image for arm64 (raspberry pi, new macbooks...)
docker buildx build -f production.Dockerfile --platform linux/arm64 -t vidsquid-arm64 .
docker image tag vidsquid-arm64:latest 192.168.0.43:5000/deevis/vidsquid-arm64:latest
docker image push 192.168.0.43:5000/deevis/vidsquid-arm64:latest
