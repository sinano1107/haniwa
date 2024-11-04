import time
import RPi
import RPi.GPIO as GPIO
from urllib.parse import urlparse, parse_qs, unquote
import requests
import json
import nfc
clf = nfc.ContactlessFrontend('usb')

blue = 4
yellow = 17
red = 18
uid = "2Ka8P9YUSaZCWvA4hfJAKRAWnjH2"

# GPIOピン番号の定義方法を設定する
GPIO.setmode(RPi.GPIO.BCM)
# 出力モードで初期化
GPIO.setup(blue, GPIO.OUT)
GPIO.setup(yellow, GPIO.OUT)
GPIO.setup(red, GPIO.OUT)

# NFCタグからgroupIdとtagIdを取得
def parseGroupANDTagId(uri):
    uri1 = urlparse(uri)
    qs1 = parse_qs(unquote(uri1.query))
    uri2 = urlparse(qs1['link'][0])
    qs2 = parse_qs(uri2.query)
    ids = qs2['id'][0].split('-')
    return ids[0], ids[1]

# tagIdからtagDataを取得
def fetchTagData(groupId, tagId):
    url = "https://asia-northeast1-haniwa-28.cloudfunctions.net/getTagData"
    headers = {"Content-Type": "application/json"}
    payload = {
        "data": {
            "groupId": groupId,
            "tagId": tagId,
        }
    }
    r = requests.post(url, headers=headers, data=json.dumps(payload))
    return r.json()['result']

# クエストクリア処理
def questClear(groupId, questId):
    url = "https://asia-northeast1-haniwa-28.cloudfunctions.net/questClear"
    headers = {"Content-Type": "application/json"}
    payload = {
        "data": {
            "uid": uid,
            "groupId": groupId,
            "questId": questId,
        }
    }
    r = requests.post(url, headers=headers, data=json.dumps(payload))
    return r.json()['result']

# LEDをひからせて3秒間待機
def sleepOutput(color):
    GPIO.output(color, True)
    #GPIO.output(blue, False)
    time.sleep(3)
    GPIO.output(color, False)
    #GPIO.output(blue, True)


def connected(tag):
    GPIO.output(blue, False)
    groupId, tagId = parseGroupANDTagId(tag.ndef.records[0].uri)
    print(groupId)
    print(tagId)
    tagData = fetchTagData(groupId, tagId)
    if tagData['result'] == 'nothingTag':
        print('このタグはグループに存在しません')
        sleepOutput(red)
        return
    if tagData['tag']['id'] == None:
        print('このタグにはクエストが結びついていません')
        sleepOutput(red)
        return
    questId = tagData['tag']['id']
    result = questClear(groupId, questId)
    messages = {
        'nothingQuest': 'クエストが存在しませんでした',
        'isNotMember': 'あなたはこのグループのメンバーではありません',
        'notWorkingDay': '今日は勤務日ではありません',
        'isCleared': '今日はすでにクリアしています',
        'finishedNormally': 'クエストをクリアしました!',
    }
    print(messages[result['result']])
    if result['result'] == 'finishedNormally':
        sleepOutput(yellow)
    else:
        sleepOutput(red)

while True:
    GPIO.output(blue, True)
    print('NFC読み取りを待機しています')
    clf.connect(rdwr={'on-connect': connected})
