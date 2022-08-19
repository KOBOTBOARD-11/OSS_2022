#-*- coding:utf-8 -*-

from ast import Num
import collections
from distutils.command.config import config
from datetime import datetime
import numbers
from pickle import FALSE, TRUE
from tabnanny import check
import pyrebase
import json
from firebase_admin import firestore
from firebase_admin import credentials
import firebase_admin
import os
import cv2
import numpy as np
import time # -- 프레임 계산을 위해 사용

check = False
vedio_path = './video.mp4' #-- 사용할 영상 경로
min_confidence = 0.5

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
Token = "ossvideo-5e684.appspot.com"

#-- firestore 데이터베이스 연동 ###
credpath = r"serviceAcc.json" ## 다운받은 service Acc 경로
login = credentials.Certificate(credpath)
firebase_admin.initialize_app(login)
db = firestore.client()
Video = db.collection("Video")

#-- 비디오 활성화
cap = cv2.VideoCapture(0) #-- 웹캠 사용시 vedio_path를 0 으로 변경
Width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
Height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
Number = 1
Video_Out = cv2.VideoWriter('./video/Fire_' + str(Number)+".mp4", fourcc, 15.0, (int(Width), int(Height)))
Start_Time = time.time()



def detectAndDisplay(frame): 
    detect_time = time.time()
    img = cv2.resize(frame, None, fx=0.8, fy=0.8)
    height, width, channels = img.shape
    #cv2.imshow("Original Image", img)

    #-- 창 크기 설정
    blob = cv2.dnn.blobFromImage(img, 0.00392, (416, 416), (0, 0, 0), True, crop=False)

    net.setInput(blob)
    outs = net.forward(output_layers)

    #-- 탐지한 객체의 클래스 예측 
    class_ids = []
    confidences = []
    boxes = []
    

    for out in outs:
        for detection in out:
            scores = detection[5:]
            class_id = np.argmax(scores)
            confidence = scores[class_id]
            
            #-- 원하는 class id 입력 / coco.names의 id에서 -1 할 것 
            if class_id == 0 and confidence > min_confidence:
                #-- 탐지한 객체 박싱
                
                center_x = int(detection[0] * width)
                center_y = int(detection[1] * height)
                w = int(detection[2] * width)
                h = int(detection[3] * height)
               
                x = int(center_x - w / 2)
                y = int(center_y - h / 2)

                boxes.append([x, y, w, h])
                confidences.append(float(confidence))
                class_ids.append(class_id)

    indexes = cv2.dnn.NMSBoxes(boxes, confidences, min_confidence, 0.4)
    font = cv2.FONT_HERSHEY_DUPLEX
    for i in range(len(boxes)):
        if i in indexes:
            x, y, w, h = boxes[i]
            label = "{}: {:.2f}".format(classes[class_ids[i]], confidences[i]*100)
            print(i, label)
            color = colors[i] #-- 경계 상자 컬러 설정 / 단일 생상 사용시 (255,255,255)사용(B,G,R)
            cv2.rectangle(img, (x, y), (x + w, y + h), color, 2)
            cv2.putText(img, label, (x, y - 5), font, 1, color, 1)
    end_time = time.time()
    process_time = end_time - detect_time
    # print("=== A frame took {:.3f} seconds".format(process_time))
    cv2.imshow("YOLO", img)
    
    
    
#-- yolo 포맷 및 클래스명 불러오기
model_file = 'YOLO/yolov4-tiny.weights' #-- 본인 개발 환경에 맞게 변경할 것
config_file = 'YOLO/Yolov4_tiny.cfg' #-- 본인 개발 환경에 맞게 변경할 것
net = cv2.dnn.readNet(model_file, config_file)


#-- 클래스(names파일) 오픈 / 본인 개발 환경에 맞게 변경할 것
classes = []
with open("YOLO/coco.names", "r") as f:
    classes = [line.strip() for line in f.readlines()]
layer_names = net.getLayerNames()
output_layers = [layer_names[i - 1] for i in net.getUnconnectedOutLayers()]
## 기존 코드 i[0] - 1 을 수정해야함

colors = np.random.uniform(0, 255, size=(len(classes), 3))
if not cap.isOpened:
    print('--(!)Error opening video capture')
    exit(0)
while True:
    ret, frame = cap.read()
    if frame is None:
        print('--(!) No captured frame -- Break!')
        break
    #-- detect
    img = cv2.resize(frame, None, fx=1, fy=1)
    height, width, channels = img.shape
    #cv2.imshow("Original Image", img)
    #-- 창 크기 설정
    blob = cv2.dnn.blobFromImage(img, 0.00392, (416, 416), (0, 0, 0), True, crop=False)
    net.setInput(blob)
    outs = net.forward(output_layers)
    #-- 탐지한 객체의 클래스 예측 
    class_ids = []
    confidences = []
    boxes = []
    for out in outs:
        for detection in out:
            scores = detection[5:]
            class_id = np.argmax(scores)
            confidence = scores[class_id]
            
            #-- 원하는 class id 입력 / coco.names의 id에서 -1 할 것 
            if class_id == 0 and confidence > min_confidence:
                #-- 탐지한 객체 박싱
                
                center_x = int(detection[0] * width)
                center_y = int(detection[1] * height)
                w = int(detection[2] * width)
                h = int(detection[3] * height)
               
                x = int(center_x - w / 2)
                y = int(center_y - h / 2)

                boxes.append([x, y, w, h])
                confidences.append(float(confidence))
                class_ids.append(class_id)

    indexes = cv2.dnn.NMSBoxes(boxes, confidences, min_confidence, 0.4)
    font = cv2.FONT_HERSHEY_DUPLEX
    X = 0
    Y = 0
    W = 0
    H = 0
    COLOR = (0,0,0)
    LABEL =""
    for i in range(len(boxes)):
        if i in indexes:
            x, y, w, h = boxes[i]
            X,Y,W,H = x,y,w,h
            label = "{}: {:.2f}".format(classes[class_ids[i]], confidences[i]*100)
            LABEL = label
            print(i, label)
            color = colors[i] #-- 경계 상자 컬러 설정 / 단일 생상 사용시 (255,255,255)사용(B,G,R)
            COLOR = color
            cv2.rectangle(img, (x, y), (x + w, y + h), color, 2)
            cv2.putText(img, label, (x, y - 5), font, 1, color, 1)
    # print("=== A frame took {:.3f} seconds".format(process_time))
    cv2.imshow("YOLO", img)
    
    cv2.rectangle(frame, (X, Y), (X + W, Y + H), COLOR, 2)
    cv2.putText(frame, LABEL, (X, Y - 5), font, 1, COLOR, 1)
    Video_Out.write(frame)
    #-- YOLO로 처리된 이미지를 저장하려면 기존 frame에다가 원하는 가공처리를 해줘야 한다.
    
    End_Time = time.time()
    Time  = int(End_Time - Start_Time)
    
    if Time == 15: ## 5초마다 저장
        Time = 0
        T = datetime.now()
        T = T.strftime('%Y-%m-%d %H:%M:%S')
        Video_Out = cv2.VideoWriter('./video/Fire_' + str(Number+1)+".mp4", fourcc, 10.0, (int(Width), int(Height)))
        #-- 저장을 하기전에 미리 동영상을 넘겨줘야 한다. 그렇지 않으면 동영상에 데이터가 없음
        if Number != 1 and check ==False: 
            #-- 화재발생 이전이라면 데이터를 삭제
            storage.delete(filename, Token + filename)
            ## delete를 하기 위해서는 storage정보가 있는 Token + filename이 필요
            
        filename = "Fire_" + str(T) + "_(" + str(Number) +").mp4" 
        print("filename is ", filename)  
        print("video/Fire"+str(Number)+".mp4")
        storage.child(filename).put("video/Fire_"+str(Number)+".mp4")
        
        if check == True:
            #-- 화재발생 시 더이상 삭제하지 않고 데이터베이스에 저장
            fileUrl = storage.child(filename).get_url(1) #0은 저장소 위치 1은 다운로드 url 경로
            fileUrl_1 =  storage.child(filename).get_url(0) #0은 저장소 위치 1은 다운로드 url 경로
            Video.document("FIRE"+ datetime.now().strftime('%Y-%m-%d %H:%M:%S')).set({
                'date' : datetime.today().strftime("%Y%m%d_%H%M%S"),
                'downloadurl' : fileUrl,
                'storage_url' : fileUrl_1
            })
            
        Number +=1
        if Number >5:
            check = True 
        
        Start_Time = time.time()
        print("SAVE THE VIDEO ")

    #-- q 입력시 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()