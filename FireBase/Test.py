#-*- coding:utf-8 -*-

from ast import Num
import collections
from distutils.command.config import config
from datetime import datetime
import numbers
from pickle import FALSE, TRUE
from tabnanny import check
import time
import pyrebase
import json
import cv2
import numpy as np
from firebase_admin import firestore
from firebase_admin import credentials
import firebase_admin
import os


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

#-- firebase sotrage 실행 ###
firebase = pyrebase.initialize_app(config)
storage = firebase.storage()

#-- firestore 데이터베이스 연동 ###
credpath = r"serviceAcc.json" ## 다운받은 service Acc 경로
login = credentials.Certificate(credpath)
firebase_admin.initialize_app(login)
db = firestore.client()

Video = db.collection("Video")

#-- 비디오 활성화
cap = cv2.VideoCapture(0) #-- 웹캠 사용시 vedio_path를 0 으로 변경
width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
Number = 1
out = cv2.VideoWriter('./video/Test_' + str(Number)+".mp4", fourcc, 15.0, (int(width), int(height)))
Token = "ossvideo-5e684.appspot.com"
Start_Time = time.time()
check = False
            
while True:
    ret, frame = cap.read()
    if frame is None:
        print('--(!) No captured frame -- Break!')
        break
    cv2.imshow("Frame", frame)
    out.write(frame)
    End_Time = time.time()
    Time  = int(End_Time - Start_Time)
    print(Time)
    
    
    if Time == 5:
        Time = 0
        T = datetime.now()
        T = T.strftime('%Y-%m-%d %H:%M:%S')
        if Number != 1 and check ==False:
            storage.delete(filename, Token + filename)
            
        filename = "Test_" + str(T) + ".(" + str(Number) +")"         
        storage.child(filename).put("./video/Test_"+str(Number)+".mp4")
        
        
        if check == True:
            fileUrl = storage.child(filename).get_url(1) #0은 저장소 위치 1은 다운로드 url 경로
            fileUrl_1 =  storage.child(filename).get_url(0) #0은 저장소 위치 1은 다운로드 url 경로
            Video.document("FIRE"+ datetime.now().strftime('%Y-%m-%d %H:%M:%S')).set({
                'date' : datetime.today().strftime("%Y%m%d_%H%M%S"),
                'downloadurl' : json.dumps(fileUrl),
                'storage_url' : json.dumps(fileUrl_1)
            })
            
        Number +=1
        if Number >3:
            check = True 
        out = cv2.VideoWriter('./video/Test_' + str(Number)+".mp4", fourcc, 15.0, (int(width), int(height)))
        Start_Time = time.time()
        print("SAVE THE VIDEO ")
        
        
    #-- q 입력시 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()


