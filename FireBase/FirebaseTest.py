from distutils.command.config import config
import pyrebase
import json

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