import requests
import json

url = "https://asia-northeast1-haniwa-28.cloudfunctions.net/questClear"
headers = {"Content-Type": "application/json"}
payload = {
    "data": { 
        'uid': 'aaaaaa',
        'groupId': 'iiiiiiiii',
        'questId': 'uuuuuuuu',
    }
}
print(payload)
r = requests.post(url, headers=headers, data=json.dumps(payload))
# print("tataketayo:)")
print(r.json())