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

### TODO - populate Neo4J for fast tag traversal
```
with range(6, 150) as video_ids
unwind video_ids as video_id
with video_id,
'http://192.168.0.43:3143/videos/VIDEO_ID.json' as base_url
with replace(base_url, "VIDEO_ID", toString(video_id)) as url 
CALL apoc.load.json(url,'', {failOnError: false}) YIELD value
with value
merge(v:Video{id: value.id, label: value.id})
with value, v
unwind value.tag_list as tag
    with value, tag, v
    merge(t:Tag{label:tag})
    merge(v)-[:TAGGED_AS]->(t)
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



