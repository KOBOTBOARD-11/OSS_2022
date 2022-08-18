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


credpath = r"serviceAcc.json" ## 다운받은 service Acc 경로
login = credentials.Certificate(credpath)
firebase_admin.initialize_app(login)

db = firestore.client()
# collection = db.collection("Video").stream()
docs = db.collection(u'Video').stream()

for doc in docs:
    # print(f'{doc.id} => {doc.to_dict()}')
    print(doc.id)
    storageURL = doc.to_dict().get("storage_url")
    downloadURL = doc.to_dict().get("downloadurl")
    print(storageURL)
    print(downloadURL)
    
    



