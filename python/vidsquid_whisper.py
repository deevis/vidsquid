# will retrieve all the untagged videos and transcribe them using wisper

import requests
import whisper    # https://github.com/openai/whisper
import os
import json

RUN_AGAINST_LOCAL_STORAGE = False

if not RUN_AGAINST_LOCAL_STORAGE and not os.path.exists('vidsquid_data'):
    os.mkdir("vidsquid_data")

# Specify the URL containing the JSON data
# url = 'http://127.0.0.1:3002/videos/list_untranscribed_video_paths'
# url = 'http://192.168.0.43:3143/videos/list_untranscribed_video_paths'
vidsquid_url = 'http://172.22.177.38:3002'
url = f"{vidsquid_url}/videos/list_untranscribed_video_paths"

# Send an HTTP GET request to the URL
response = requests.get(url)
# Check if the request was successful (status code 200)
if response.status_code == 200:
    # Parse the JSON data from the response
    json_data = response.json()
    # {"count":345,
    # "videos":[
    #   {   "id":3830, 
    #       "storage_name: "tmuofyirpsk9obbko01kdydvmwl1",
    #       "path":"/mnt/c/Users/Darren/projects/github/vidsquid/storage/tm/uo/tmuofyirpsk9obbko01kdydvmwl1",
    #       "url": "http://.......mp4"
    # },
    record_count = json_data['count']
    videos = json_data['videos']
    print(f"Returned {record_count} videos from {url}")
else:
    print(f"Request failed with status code {response.status_code}")

whisper_model = 'medium' # tiny(39 M), base(74 M), small(244 M), medium(769 M), large(1550 M)
print(f"Loading whisper[{whisper_model}] model...")
model = whisper.load_model(whisper_model)
count = 0
for video in videos:
    video_id = video['id']
    count += 1
    needs_transcription = True
    if RUN_AGAINST_LOCAL_STORAGE:
        path = video['path']
        path = path.replace("/mnt/c", "c:")
        transcribed_path = f"{path}.txt"
    else:
        path = f"vidsquid_data/{video['storage_name']}"      
        if not os.path.exists(path):
            print(f"Downloading: {path}")
            r = requests.get(video['url'], allow_redirects=True)
            open(path, 'wb').write(r.content)
        transcribed_path = f"{path}.txt"

    if os.path.exists(transcribed_path):
        print(f"{count}/{record_count} Skipping[{video_id}] - already transcribed: - {path}")
        needs_transcription = False

    if needs_transcription:
        print(f"{count}/{record_count} Transcribing[{video_id}]: - {path}")
        result = model.transcribe(path)
        text = result["text"].strip()
        print(text)
        with open(transcribed_path, "w", encoding='utf-8') as file:
            file.write(text)
            file.write("\n")
        print(f"Written to {transcribed_path}")
        tsv_path = f"{path}.tsv"
        tsv_text = ''
        with open(tsv_path, "w", encoding='utf-8') as file:    
            file.write("start\tend\ttext\n")
            # build TSV file (start/tend/ttext)
            for segment in result["segments"]:
                start = int(segment['start'] * 1000)
                end = int(segment['end'] * 1000)
                snippet = segment['text'].strip()
                tsv_text += f"{start}\t{end}\t{snippet}\n"
                file.write(f"{start}\t{end}\t{snippet}\n")
        # now tell vidsquid that the transcription files are present
        url = f"{vidsquid_url}/videos/{video_id}/populate_whisper_transcription.json"
        print(url)
        response = requests.post(url, data={'whisper_txt': text, 'whisper_tsv': tsv_text, 'whisper_model': whisper_model})
        if response.status_code == 200:
            # Parse the JSON data from the response
            video_data = response.json()
            print(f"Successfully updated transcription in VidSquid - {len(video_data['whisper_txt'])} bytes")
        else:
            print(f"Request failed with status code {response.status_code}")
        print("\n\n")


#  "segments": [
#         {
#             "id": 0,
#             "seek": 0,
#             "start": 0.0,
#             "end": 2.0,
#             "text": " Look mom, I'm American.",
#             "tokens": [
#                 50364,
#                 2053,
#                 1225,
#                 11,
#                 286,
#                 478,
#                 2665,
#                 13,
#                 50464
#             ],
#             "temperature": 0.0,
#             "avg_logprob": -0.29581356048583984,
#             "compression_ratio": 1.0405405405405406,
#             "no_speech_prob": 0.09053011238574982
#         },