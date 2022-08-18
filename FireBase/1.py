import collections
from distutils.command.config import config
import pyrebase
import json
from datetime import datetime


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

fileUrl = storage.child("Test_2022-08-18 19:21:34.(3)").get_url(1)
print(fileUrl)

# storage.download(fileUrl,"Example.mp4")