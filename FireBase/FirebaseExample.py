#-*- coding:utf-8 -*-

import collections
from distutils.command.config import config
import pyrebase
import json
from datetime import datetime

from .SaveVideo import Token


config = {
    "apiKey": "AIzaSyBqQjlNppEdPpjZrA64zEgkKfAIIPo-TE8",
    "authDomain": "ossvideo-5e684.firebaseapp.com",
    "databaseURL":"https://ossvideo-5e684-default-rtdb.firebaseio.com/",
    "projectId": "ossvideo-5e684",
    "storageBucket": "ossvideo-5e684.appspot.com",
    "messagingSenderId": "798635139551",
    "appId": "1:798635139551:web:b76ed3012d82202bb2646a",
    "measurementId": "G-JFF15R9GQ8",
    "serviceAccount": "serviceAcc.json"
}


## firebase sotrage 실행 ###
firebase = pyrebase.initialize_app(config)
storage = firebase.storage()
## firebase sotrage 실행 ###


#####   데이터 업로드 #####
## 첫 번째는 데이터베이스에 보여지길 원하는 이름을 적고 그 다음에는 업로드할 파일의 경로를 적어준다.
filename = "fire" + datetime.now()
storage.child(filename).put(r"video/fire.mp4")
#####   데이터 업로드 #####


#####   데이터 다운로드 #####
## 첫 번째는 다운로드 하고싶은 파일에 이름을 적고 그 다음에는 다운로드 받은 파일을 로컬 pc에 저장할 이름이다.
# storage.download("filename", "fires.mp4")
#####   데이터 다운로드 #####

##### 데이터 삭제 #####
Token = "ossvideo-5e684.appspot.com"
storage.delete(filename, Token + filename)
##### 데이터 삭제 #####


#####   Realtime 데이터베이스 업로드 #####
fileUrl = storage.child("Videos/"+"fire").get_url(1) #0은 저장소 위치 1은 다운로드 url 경로
# # print(fileUrl)
# db = firebase.database()
# d = {} 
# d["fire"] = fileUrl
# data = json.dumps(d)
# results = db.child("files").push(data)
# print("OK")
#####   Realtime 데이터베이스 업로드 #####


##### 데이터베이스에 저장된 모드 값들 출력 #####
# files = db.child("files").get().val() #딕셔너리로 반환된다.
# print(files)
##### 데이터베이스에 저장된 모드 값들 출력 #####


### Cloud firestore ###

from firebase_admin import firestore
from firebase_admin import credentials
import firebase_admin
import time
from datetime import datetime
import os

credpath = r"serviceAcc.json" ## 다운받은 service Acc 경로
login = credentials.Certificate(credpath)
firebase_admin.initialize_app(login)

db = firestore.client()
collection = db.collection("Video").stream()
print(collection)
## Json 형태에 데이터가 들어있음

#####  데이터베이스에 값 저장 #####
Video = db.collection("Video")
Video.document("FIRE").set({
    'date' : datetime.today().strftime("%Y%m%d_%H%M%S"),
    'url' : json.dumps(fileUrl)
})
#####  데이터베이스에 값 저장 #####



