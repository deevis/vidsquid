# VidSquid

A modern video aggregation platform that uses whisper transcription and LLMs to summarize, title, and categorize uploaded videos.

## Prerequisites

- Ruby 3.1.2
- Rails 7


## To build/install locally

```
cd myprojects
git clone https://github.com/deevis/vidsquid.git
cd vidsquid
bundle install
rails db:create
rails db:migrate
rails s
```

* Restore PROD db into DEV
mysql -u vidsquid -p --host 127.0.0.1 vidsquid_development < vidsquid_production_2023-08-17_03_01am.sql


## Deploy docker container

### Powershell - arm64 target  (raspberry pi, new macbooks...)

```
docker buildx build -f production.Dockerfile --platform linux/arm64 -t vidsquid-arm64 .
docker image tag vidsquid-arm64:latest 192.168.0.43:5000/deevis/vidsquid-arm64:latest
docker image push 192.168.0.43:5000/deevis/vidsquid-arm64:latest
```

### Branches

- main



