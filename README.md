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

### Local tricks of the trade
* Restore PROD db into DEV
mysql -u vidsquid -p --host 127.0.0.1 vidsquid_development < vidsquid_production_2023-08-17_03_01am.sql



## Neo4J

### Populate Neo4J for fast tag traversal
```
with range(1, 4750) as video_ids
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

### View graph of 10 most used tags
```
MATCH (v)-[:TAGGED_AS]->(t)
RETURN t, COLLECT(v) as videos
ORDER BY SIZE(videos) DESC LIMIT 10
```

### Visualize connections between any two tags
```
match p=allShortestPaths((t1:Tag{label:"anthony fauci"})-[*]-(t2:Tag{label:"plandemic"}))
WITH [node in nodes(p) WHERE node:Video] as videos
unwind videos as v
with v
match (v)-[:TAGGED_AS]->(t:Tag)
return distinct v, t
```

## Deploy docker container

### Powershell - arm64 target  (raspberry pi, new macbooks...)

```
docker buildx build -f production.Dockerfile --platform linux/arm64 -t vidsquid-arm64 .
docker image tag vidsquid-arm64:latest 192.168.0.43:5000/deevis/vidsquid-arm64:latest
docker image push 192.168.0.43:5000/deevis/vidsquid-arm64:latest
```

### Branches

- main



