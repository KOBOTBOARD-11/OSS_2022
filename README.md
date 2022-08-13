## 1. Firebase 홈페이지 접속

→ <>(웹) 클릭

→ 앱 등록(별 다른 체크 X)

→ Firebase SDK 추가 파트

자바스크립트 코드에서 아래 부분만 가져온다.

```jsx
const firebaseConfig = {
    apiKey: "자신의 api Key",
    authDomain: "개인 정보",
    projectId: "자신의 프로젝트 ID",
    storageBucket: "Bucket 정보",
    messagingSenderId: "개인 정보",
    appId: "개인 정보",
    measurementId: "개인 정보"
  };
// 위 코드만 복사한다. 

// 다운받은 비공개 키를 해당 폴더로 옮긴 후 아래코드를 config 안에 추가 
serviceAccount: "다운받은 비공개 키" 
```

프로젝트 설정 → 상단에 서비스 계정 → python코드로 서비스 계정만들기  → 새 비공개 키 생성

위 방법으로 비공개 키를 다운받은 후 서비스 계정을 이용하여 등록

## 2. Python 실행

→ 파이썬에서 파이어베이스를 제어하기 위해 pyrebase 설치

```bash
pip install pyrebase4
pip install firebase_admin
## 위 명령어를 터미널에서 실행하여 pyrebase 라이브러리 설치
```

### 다운받은 서비스계정를 이용하여 Pyrebase4 제어

```python
from distutils.command.config import config
import pyrebase

config = {
    "apiKey": "AIzaSyBqQjlNppEdPpjZrA64zEgkKfAIIPo-TE8",
    "authDomain": "ossvideo-5e684.firebaseapp.com",
    "projectId": "ossvideo-5e684",
    "storageBucket": "ossvideo-5e684.appspot.com",
    "messagingSenderId": "798635139551",
    "appId": "1:798635139551:web:b76ed3012d82202bb2646a",
    "measurementId": "G-JFF15R9GQ8",
    "serviceAccount": "serviceAcc.json" ## 다운받은 비공개 키
}
### Database URL 에러가 뜨는데 이 때 리얼타임 데이터베이스를 생성해야한다.
### DatabaseURL 추가 코드

from distutils.command.config import config
import pyrebase

config = {
    "apiKey": "AIzaSyBqQjlNppEdPpjZrA64zEgkKfAIIPo-TE8",
    "authDomain": "ossvideo-5e684.firebaseapp.com",
    "databaseURL":"https://ossvideo-5e684-default-rtdb.firebaseio.com/", ## 데이터베이스 추가
    "projectId": "ossvideo-5e684",
    "storageBucket": "ossvideo-5e684.appspot.com",
    "messagingSenderId": "798635139551",
    "appId": "1:798635139551:web:b76ed3012d82202bb2646a",
    "measurementId": "G-JFF15R9GQ8",
    "serviceAccount": "serviceAcc.json"
    
}

firebase = pyrebase.initialize_app(config)
```

### storge에 영상 저장하고 다운로드 받기 + 리얼타임 데이터 베이스에 저장

```python
from distutils.command.config import config
import pyrebase
import json

config = {
    "apiKey": "AIzaSyBqQjlNppEdPpjZrA64zEgkKfAIIPo-TE8",
    "authDomain": "ossvideo-5e684.firebaseapp.com",
    "databaseURL":"https://ossvideo-5e684-default-rtdb.firebaseio.com/", ## 데이터베이스 추가
    "projectId": "ossvideo-5e684",
    "storageBucket": "ossvideo-5e684.appspot.com",
    "messagingSenderId": "798635139551",
    "appId": "1:798635139551:web:b76ed3012d82202bb2646a",
    "measurementId": "G-JFF15R9GQ8",
    "serviceAccount": "serviceAcc.json" ## 다운받은 비공개 키
}

firebase = pyrebase.initialize_app(config)
## firebase 실행
storage = firebase.storage()

#####   데이터 업로드 #####
## 첫 번째는 데이터베이스에 보여지길 원하는 이름을 적고 그 다음에는 업로드할 파일의 경로를 적어준다.
# storge.child("fire").put(r"video/fire.mp4")
#####   데이터 업로드 #####

#####   데이터 다운로드 #####
## 첫 번째는 다운로드 하고싶은 파일에 이름을 적고 그 다음에는 다운로드 받은 파일을 로컬 pc에 저장할 이름이다.
# storage.download("fire", "fires.mp4")
#####   데이터 다운로드 #####

#####   Realtime 데이터베이스 업로드 #####
fileUrl = storage.child("Videos/"+"fire").get_url(1) #0은 저장소 위치 1은 다운로드 url 경로
# print(fileUrl)
db = firebase.database()
d = {} 
d["fire"] = fileUrl
data = json.dumps(d)
results = db.child("files").push(data)
print("OK")
#####   Realtime 데이터베이스 업로드 #####

## 데이터베이스에 저장된 모드 값들 출력
files = db.child("files").get().val() #딕셔너리로 반환된다.
print(files)
```

### Realtime database 보다 Cloud firestore가 더 좋다고 하니 Cloud firestore 데이터 베이스에 영상을 저장하는 방법

- 기본 접근 방법

```python
#-*- coding:utf-8 -*-

import collections
from firebase_admin import credentials
from firebase_admin import firestore
import firebase_admin

credpath = r"serviceAcc.json" ##다운받은 serviceAcc 경로
login = credentials.Certificate(credpath)
## firebase app 시작

firebase_admin.initialize_app(login) 

## 데이터베이스에서 값 가져오기
db = firestore.client()
collection =  db.collection("Video").stream()
# print(collection)
## Json 형태에 데이터가 들어있음

## 데이터베이스에 값 쓰기

Video = db.collection("Video")
Video.document("Wild").set({
    'class' : "Wild boar" ,
    'age'  : 10
})
```

- 영상 업로드… 맞는지는 확인 필요

```python
### Cloud firestore ###

#-*- coding:utf-8 -*-
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
```
