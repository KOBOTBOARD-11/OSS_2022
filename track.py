import argparse
import time
import datetime
import os
from pickle import TRUE

# from Firebase.tmp import Number3333

# limit the number of cpus used by high performance libraries
os.environ["OMP_NUM_THREADS"] = "1"
os.environ["OPENBLAS_NUM_THREADS"] = "1"
os.environ["MKL_NUM_THREADS"] = "1"
os.environ["VECLIB_MAXIMUM_THREADS"] = "1"
os.environ["NUMEXPR_NUM_THREADS"] = "1"

import sys
import numpy as np
from pathlib import Path
import torch
import torch.backends.cudnn as cudnn

FILE = Path(__file__).resolve()
ROOT = FILE.parents[0]  # yolov5 strongsort root directory
WEIGHTS = ROOT / 'weights'
current_Time = datetime.datetime.now()
FIREFLAG = False

if str(ROOT) not in sys.path:
    sys.path.append(str(ROOT))  # add ROOT to PATH
if str(ROOT / 'yolov5') not in sys.path:
    sys.path.append(str(ROOT / 'yolov5'))  # add yolov5 ROOT to PATH
if str(ROOT / 'strong_sort') not in sys.path:
    sys.path.append(str(ROOT / 'strong_sort'))  # add strong_sort ROOT to PATH
ROOT = Path(os.path.relpath(ROOT, Path.cwd()))  # relative

import logging
from yolov5.models.common import DetectMultiBackend
from yolov5.utils.dataloaders import VID_FORMATS, LoadImages, LoadStreams
from yolov5.utils.general import (LOGGER, check_img_size, non_max_suppression, scale_coords, check_requirements, cv2,
                                  check_imshow, xyxy2xywh, increment_path, strip_optimizer, colorstr, print_args, check_file)
from yolov5.utils.torch_utils import select_device, time_sync
from yolov5.utils.plots import Annotator, colors, save_one_box
from strong_sort.utils.parser import get_config
from strong_sort.strong_sort import StrongSORT

# remove duplicated stream handler to avoid duplicated logging
logging.getLogger().removeHandler(logging.getLogger().handlers[0])

from ast import Num
from distutils.command.config import config
# from datetime import datetime
from tabnanny import check
import pyrebase
import json
from firebase_admin import firestore
from firebase_admin import credentials
import firebase_admin

config = {
    "apiKey": "AIzaSyBzK5MOjxppv-telPGe6YXJzdA8Ytt5LRE",
    "authDomain": "oss-test-1e565.firebaseapp.com",
    "projectId": "oss-test-1e565",
    "storageBucket": "oss-test-1e565.appspot.com",
    "messagingSenderId": "439803635150",
    "appId": "1:439803635150:web:86adb68c64c6fec8bef79f",
    "serviceAccount" : "/home/kobot/Yolov5_DeepSort_Pytorch/Firebase/oss-booriya-firebase-adminsdk-2u20l-5aba030f8d.json", #비밀키 추가
    "databaseURL" : "https://oss-test-1e565-default-rtdb.asia-southeast1.firebasedatabase.app/",
  }

firebase = pyrebase.initialize_app(config)
storage = firebase.storage()
Token = "oss-test-1e565.appspot.com"                #fire storage  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1!!!!!!!!

credpath = r"/home/kobot/Yolov5_DeepSort_Pytorch/Firebase/oss-booriya-firebase-adminsdk-2u20l-5aba030f8d.json" # -> 다운받은 serviceAcc 경로
login = credentials.Certificate(credpath)
firebase_admin.initialize_app(login)
db = firestore.client()                             #fire database !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@torch.no_grad()
def run(
        source='0',#!!!!!!!!!!!!!!!!!!!!!!! 서버 주소로 교체 예정
        yolo_weights=WEIGHTS / '/home/kobot/yolov5/runs/train/exp2/weights/best.pt',  # model.pt path(s),!!!!!!!!!!!!!!!!!
        strong_sort_weights=WEIGHTS / 'osnet_x0_25_msmt17.pt',  # model.pt path,
        config_strongsort=ROOT / 'strong_sort/configs/strong_sort.yaml',
        imgsz=(640, 640),  # inference size (height, width)
        conf_thres=0.25,  # confidence threshold
        iou_thres=0.45,  # NMS IOU threshold
        max_det=1000,  # maximum detections per image
        device='',  # cuda device, i.e. 0 or 0,1,2,3 or cpu
        show_vid=False,  # show results
        save_txt=False,  # save results to *.txt
        save_conf=False,  # save confidences in --save-txt labels
        save_crop=False,  # save cropped prediction boxes
        save_vid=False,  # save confidences in --save-txt labels
        nosave=False,  # do not save images/videos
        classes=None,  # filter by class: --class 0, or --class 0 2 3
        agnostic_nms=False,  # class-agnostic NMS
        augment=False,  # augmented inference
        visualize=False,  # visualize features
        update=False,  # update all models
        project=ROOT / 'runs/track',  # save results to project/name
        name='exp',  # save results to project/name
        exist_ok=False,  # existing project/name ok, do not increment
        line_thickness=3,  # bounding box thickness (pixels)
        hide_labels=False,  # hide labels
        hide_conf=False,  # hide confidences
        hide_class=False,  # hide IDs
        half=False,  # use FP16 half-precision inference
        dnn=False,  # use OpenCV DNN for ONNX inference
):

    source = str(source)
    save_img = not nosave and not source.endswith('.txt')  # save inference images
    is_file = Path(source).suffix[1:] in (VID_FORMATS)
    is_url = source.lower().startswith(('rtsp://', 'rtmp://', 'http://', 'https://'))
    webcam = source.isnumeric() or source.endswith('.txt') or (is_url and not is_file)
    if is_url and is_file:
        source = check_file(source)  # download

    # Directories
    if not isinstance(yolo_weights, list):  # single yolo model
        exp_name = yolo_weights.stem
    elif type(yolo_weights) is list and len(yolo_weights) == 1:  # single models after --yolo_weights
        exp_name = Path(yolo_weights[0]).stem
    else:  # multiple models after --yolo_weights
        exp_name = 'ensemble'
    exp_name = name if name else exp_name + "_" + strong_sort_weights.stem
    save_dir = increment_path(Path(project) / exp_name, exist_ok=exist_ok)  # increment run
    (save_dir / 'tracks' if save_txt else save_dir).mkdir(parents=True, exist_ok=True)  # make dir

    # Load model
    device = select_device(device)
    model = DetectMultiBackend(yolo_weights, device=device, dnn=dnn, data=None, fp16=half)
    stride, names, pt = model.stride, model.names, model.pt
    imgsz = check_img_size(imgsz, s=stride)  # check image size

    # Dataloader
    if webcam:
        show_vid = check_imshow()
        cudnn.benchmark = True  # set True to speed up constant image size inference
        dataset = LoadStreams(source, img_size=imgsz, stride=stride, auto=pt)
        nr_sources = len(dataset)
    else:
        dataset = LoadImages(source, img_size=imgsz, stride=stride, auto=pt)
        nr_sources = 1
    vid_path, vid_writer, txt_path = [None] * nr_sources, [None] * nr_sources, [None] * nr_sources

    # initialize StrongSORT
    cfg = get_config()
    cfg.merge_from_file(config_strongsort)

    # Create as many strong sort instances as there are video sources
    strongsort_list = []
    for i in range(nr_sources):
        strongsort_list.append(
            StrongSORT(
                strong_sort_weights,
                device,
                half,
                max_dist=cfg.STRONGSORT.MAX_DIST,
                max_iou_distance=cfg.STRONGSORT.MAX_IOU_DISTANCE,
                max_age=cfg.STRONGSORT.MAX_AGE,
                n_init=cfg.STRONGSORT.N_INIT,
                nn_budget=cfg.STRONGSORT.NN_BUDGET,
                mc_lambda=cfg.STRONGSORT.MC_LAMBDA,
                ema_alpha=cfg.STRONGSORT.EMA_ALPHA,

            )
        )
        strongsort_list[i].model.warmup()
    outputs = [None] * nr_sources

    # Run tracking
    FLAG = False #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    FIREFLAG = False
    COUNT = 0 #처음부터 측정
    FIRECOUNT = 0 #화재 발생 후 부터 측정
    NUMBER = 0
    TIME = 0 
    HUMANCOUNT = 0
    z = 0
    location = '국민대 미래관 6층'
    roomName = '코봇 동아리방'
    save_path = str(Path('videoBox/fire/' + 'fire_' + str(z)).with_suffix('.mp4'))
    start_time = time.time()
    
    
    model.warmup(imgsz=(1 if pt else nr_sources, 3, *imgsz))  # warmup
    dt, seen = [0.0, 0.0, 0.0, 0.0], 0
    curr_frames, prev_frames = [None] * nr_sources, [None] * nr_sources
    for frame_idx, (path, im, im0s, vid_cap, s) in enumerate(dataset):
        t1 = time_sync()
        im = torch.from_numpy(im).to(device)
        im = im.half() if half else im.float()  # uint8 to fp16/32
        im /= 255.0  # 0 - 255 to 0.0 - 1.0
        if len(im.shape) == 3:
            im = im[None]  # expand for batch dim
        t2 = time_sync()
        dt[0] += t2 - t1

        # Inference
        visualize = increment_path(save_dir / Path(path[0]).stem, mkdir=True) if visualize else False
        pred = model(im, augment=augment, visualize=visualize)
        t3 = time_sync()
        dt[1] += t3 - t2

        # Apply NMS
        pred = non_max_suppression(pred, conf_thres, iou_thres, classes, agnostic_nms, max_det=max_det)
        dt[2] += time_sync() - t3

        
        # Process detections
        for i, det in enumerate(pred):  # detections per image
            seen += 1
            if webcam:  # nr_sources >= 1
                p, im0, _ = path[i], im0s[i].copy(), dataset.count
                p = Path(p)  # to Path
                # s += f'{i}: ' # number part !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                txt_file_name = p.name
                save_path = str(save_dir / p.name)  # im.jpg, vid.mp4, ...
            else:
                p, im0, _ = path, im0s.copy(), getattr(dataset, 'frame', 0)
                p = Path(p)  # to Path
                # video file
                if source.endswith(VID_FORMATS):
                    txt_file_name = p.stem
                    save_path = str(save_dir / p.name)  # im.jpg, vid.mp4, ...
                # folder with imgs
                else:
                    txt_file_name = p.parent.name  # get folder name containing current img
                    save_path = str(save_dir / p.parent.name)  # im.jpg, vid.mp4, ...
            curr_frames[i] = im0

            txt_path = str(save_dir / 'tracks' / txt_file_name)  # im.txt
            # s += '%gx%g ' % im.shape[2:]  # print string # image size part !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            imc = im0.copy() if save_crop else im0  # for save_crop

            annotator = Annotator(im0, line_width=2, pil=not ascii)
            if cfg.STRONGSORT.ECC:  # camera motion compensation
                strongsort_list[i].tracker.camera_update(prev_frames[i], curr_frames[i])

            if det is not None and len(det):
                # Rescale boxes from img_size to im0 size
                det[:, :4] = scale_coords(im.shape[2:], det[:, :4], im0.shape).round()

                # Print results
                for c in det[:, -1].unique():
                    n = (det[:, -1] == c).sum()  # detections per class !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    s += f"{n} {names[int(c)]}{'s' * (n > 1)} "  # add to string # delete (,) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    num = n

                xywhs = xyxy2xywh(det[:, 0:4])
                confs = det[:, 4]
                clss = det[:, 5]

                # pass detections to strongsort
                t4 = time_sync()
                outputs[i] = strongsort_list[i].update(xywhs.cpu(), confs.cpu(), clss.cpu(), im0)
                t5 = time_sync()
                dt[3] += t5 - t4

                # draw boxes for visualization
                if len(outputs[i]) > 0:
                    for j, (output, conf) in enumerate(zip(outputs[i], confs)):
    
                        bboxes = output[0:4]
                        id = output[4]
                        cls = output[5]

                        if save_txt:
                            # to MOT format
                            bbox_left = output[0]
                            bbox_top = output[1]
                            bbox_w = output[2] - output[0]
                            bbox_h = output[3] - output[1]
                            # Write MOT compliant results to file
                            with open(txt_path + '.txt', 'a') as f:
                                f.write(('%g ' * 10 + '\n') % (frame_idx + 1, id, bbox_left,  # MOT format
                                                               bbox_top, bbox_w, bbox_h, -1, -1, -1, i))

                        if save_vid or save_crop or show_vid:  # Add bbox to image
                            c = int(cls)  # integer class
                            id = int(id)  # integer id
                            
                            # if(c == 0) :
                            #     LOGGER.info("사람입니다.")
                            # elif(c == 1) :
                            #     LOGGER.info("불입니다.")
                            # elif(c == 2) :
                            #     LOGGER.info("연기입니다.")
                            
                            if(c == 1) : # 화재 감지
                                LOGGER.info("!!! === 화 재 발 생 === !!!")
                                FIREFLAG = True
                                
                            #c -> 종류
                            #n -> 수/양
                            if c == 0:
                                HUMANCOUNT = ((n.to("cpu")).numpy())
                                print("사람수는 : " + str(HUMANCOUNT))
                                
                            
                            label = None if hide_labels else (f'{id} {names[c]}' if hide_conf else 
                                (f'{id} {conf:.2f}' if hide_class else f'{id} {names[c]} {conf:.2f}'))
                            annotator.box_label(bboxes, label, color=colors(c, True))
                            if save_crop:
                                txt_file_name = txt_file_name if (isinstance(path, list) and len(path) > 1) else ''
                                save_one_box(bboxes, imc, file=save_dir / 'crops' / txt_file_name / names[c] / f'{id}' / f'{p.stem}.jpg', BGR=True)

                # n = n.to("cpu")
                # LOGGER.info(str(n.numpy())) # 인원수
                # current_Time = datetime.datetime.now()    
                # LOGGER.info(current_Time.strftime('%Y년 %m월%d일 %H시%M분%S초\n'))

            else:
                current_Time = datetime.datetime.now()
                strongsort_list[i].increment_ages()
                LOGGER.info('@@@ NO DETECTIONS @@@\n')
                # LOGGER.info(current_Time.strftime('%Y년 %m월%d일 %H시%M분%S초')) OPTIONAL

            # Stream results
            end_time = time.time()
            TIME = int(end_time - start_time)
            im0 = annotator.result()
            fps, w, h = 50, im0.shape[1], im0.shape[0]
            
            if FLAG == False:
                VOUT = cv2.VideoWriter(save_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))
                FLAG = True
            if show_vid:
                cv2.imshow(str(p), im0)
                cv2.waitKey(1)  # 1 millisecond
            VOUT.write(im0)
            prev_frames[i] = curr_frames[i] # 이 코드없으면 강제 종료
            
            
            print(" COUNT TIME :" + str(TIME))
            if TIME == 5:
                
                print("============================================================")
                z += 1
                save_path = str(Path('videoBox/fire/' + 'fire_' + str(z)).with_suffix('.mp4')) #동영상 파일 저장 경로
                VOUT = cv2.VideoWriter(save_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))
                image_path = str(Path('humanPic/' + 'human_' + str(z) + ".jpg")) #이미지 파일 저장 경로
                cv2.imwrite(image_path, im0)
                start_time = time.time()
            
                
                
                if COUNT >= 1 and FIREFLAG == False: 
                    storage.delete("before_fire/video/" + str(NUMBER), Token + './videoBox/fire/fire_' + str(NUMBER) + '.mp4')
                # --------------------화재 발생 전
                
                storage.child("before_fire/video/" + str(NUMBER+1)).put('/home/kobot/Yolov5_DeepSort_Pytorch/videoBox/fire/fire_' + str(NUMBER+1) + '.mp4')
                storage.child("before_fire/image/" + str(NUMBER+1)).put('/home/kobot/Yolov5_DeepSort_Pytorch/humanPic/human_' + str(NUMBER+1) + '.jpg')
                NUMBER += 1
                COUNT += 1
                            
                if FIREFLAG == True and FIRECOUNT == 0:
                    print("fireflag : " + str(FIREFLAG))
                    Video = db.collection("first_fireC")
                    FIRECOUNT += 1
                    Video.document("first_fireD").set({
                        'detected_Time' : datetime.datetime.now().strftime("['%Y년 %m월 %d일 %H시 %M분 %S초']"),
                        'FireVideo' : storage.child("before_fire/video/" + str(NUMBER)).get_url(1),
                        'FireImage' : storage.child("before_fire/image/" + str(NUMBER)).get_url(1),
                        'Location' : location,
                        'Room_name' : roomName,
                        'HumanCount' : str(HUMANCOUNT)
                    })
                
                if FIREFLAG == True and FIRECOUNT >= 1 and TIME == 5:
                    Video = db.collection("fire situation_C")
                    FIRECOUNT += 1
                    Video.document("fire situation_D").set({
                        'detected_Time' : datetime.datetime.now().strftime("['%Y년 %m월 %d일 %H시 %M분 %S초']"),
                        'FireVideo' : storage.child("before_fire/video/" + str(NUMBER)).get_url(1),
                        'FireImage' : storage.child("before_fire/image/" + str(NUMBER)).get_url(1),
                        'Location' : location,
                        'Room_name' : roomName,
                        'HumanCount' : str(HUMANCOUNT),
                        'FIRECOUNT': FIRECOUNT
                    })
                
                    
                    
                    
            
            # if NUMBER != 1 and check ==False: 
                # 화재발생 이전이라면 데이터를 삭제
                # storage.delete(filename, Token + filename)
                # delete를 하기 위해서는 storage정보가 있는 Token + filename이 필요
            
            
            # storage.child("before_fire").put('/home/kobot/Yolov5_DeepSort_Pytorch/videoBox/fire_7.mp4')
            
    # if TIME == 15: ## 15초마다 저장
    #     TIME = 0
    #     T = datetime.now()
    #     T = T.strftime('%Y.%m.%d %H:%M:%S\n')
    #     VIDEOOUT = cv2.VideoWriter('./videoBox/fire/fire_' + str(NUMBER+1)+".mp4", fourcc, 10.0, (int(Width), int(Height)))
    #     #-- 저장을 하기전에 미리 동영상을 넘겨줘야 한다. 그렇지 않으면 동영상에 데이터가 없음
    #     if NUMBER != 1 and check ==False: 
    #         #-- 화재발생 이전이라면 데이터를 삭제
    #         storage.delete(filename, Token + filename)
    #         ## delete를 하기 위해서는 storage정보가 있는 Token + filename이 필요
            
    #     filename = "Fire_" + str(T) + "_(" + str(NUMBER) +").mp4" 
    #     print("filename is ", filename)  
    #     print("video/Fire"+str(NUMBER)+".mp4")
    #     storage.child(filename).put("video/Fire_"+str(NUMBER)+".mp4")
        
    #     NUMBER +=1

            # storage.child("fire").put('/home/kobot/Yolov5_DeepSort_Pytorch/videoBox/fire/fire_7.mp4')
            # storage.download("fire","fb_fire.mp4")
            # --------------------------------------------------------

            # credpath = r"Firebase/oss-booriya-firebase-adminsdk-2u20l-5aba030f8d.json" # -> 다운받은 serviceAcc 경로
            # login = credentials.Certificate(credpath)
            # firebase_admin.initialize_app(login)
            # db = firestore.client()
            # Video = db.collection("fire")
                

    # Print results
    t = tuple(x / seen * 1E3 for x in dt)  # speeds per image
    LOGGER.info(f'Speed: %.1fms pre-process, %.1fms inference, %.1fms NMS, %.1fms strong sort update per image at shape {(1, 3, *imgsz)}' % t)
    if save_txt or save_vid:
        s = f"\n{len(list(save_dir.glob('tracks/*.txt')))} tracks saved to {save_dir / 'tracks'}" if save_txt else ''
        LOGGER.info(f"Results saved to {colorstr('bold', save_dir)}{s}")
    if update:
        strip_optimizer(yolo_weights)  # update model (to fix SourceChangeWarning)


def parse_opt():
    parser = argparse.ArgumentParser()
    parser.add_argument('--yolo-weights', nargs='+', type=Path, default=WEIGHTS / '/home/kobot/yolov5/runs/train/exp2/weights/best.pt', help='model.pt path(s)')
    parser.add_argument('--strong-sort-weights', type=Path, default=WEIGHTS / 'osnet_x0_25_msmt17.pt')
    parser.add_argument('--config-strongsort', type=str, default='strong_sort/configs/strong_sort.yaml')
    parser.add_argument('--source', type=str, default='0', help='file/dir/URL/glob, 0 for webcam')  
    parser.add_argument('--imgsz', '--img', '--img-size', nargs='+', type=int, default=[640], help='inference size h,w')
    parser.add_argument('--conf-thres', type=float, default=0.5, help='confidence threshold')
    parser.add_argument('--iou-thres', type=float, default=0.5, help='NMS IoU threshold')
    parser.add_argument('--max-det', type=int, default=1000, help='maximum detections per image')
    parser.add_argument('--device', default='', help='cuda device, i.e. 0 or 0,1,2,3 or cpu')
    parser.add_argument('--show-vid', action='store_true', help='display tracking video results')
    parser.add_argument('--save-txt', action='store_true', help='save results to *.txt')
    parser.add_argument('--save-conf', action='store_true', help='save confidences in --save-txt labels')
    parser.add_argument('--save-crop', action='store_true', help='save cropped prediction boxes')
    parser.add_argument('--save-vid', action='store_true', help='save video tracking results')
    parser.add_argument('--nosave', action='store_true', help='do not save images/videos')
    # class 0 is person, 1 is bycicle, 2 is car... 79 is oven
    parser.add_argument('--classes', nargs='+', type=int, help='filter by class: --classes 0, or --classes 0 2 3')
    parser.add_argument('--agnostic-nms', action='store_true', help='class-agnostic NMS')
    parser.add_argument('--augment', action='store_true', help='augmented inference')
    parser.add_argument('--visualize', action='store_true', help='visualize features')
    parser.add_argument('--update', action='store_true', help='update all models')
    parser.add_argument('--project', default=ROOT / 'runs/track', help='save results to project/name')
    parser.add_argument('--name', default='exp', help='save results to project/name')
    parser.add_argument('--exist-ok', action='store_true', help='existing project/name ok, do not increment')
    parser.add_argument('--line-thickness', default=3, type=int, help='bounding box thickness (pixels)')
    parser.add_argument('--hide-labels', default=False, action='store_true', help='hide labels')
    parser.add_argument('--hide-conf', default=False, action='store_true', help='hide confidences')
    parser.add_argument('--hide-class', default=False, action='store_true', help='hide IDs')
    parser.add_argument('--half', action='store_true', help='use FP16 half-precision inference')
    parser.add_argument('--dnn', action='store_true', help='use OpenCV DNN for ONNX inference')
    opt = parser.parse_args()
    opt.imgsz *= 2 if len(opt.imgsz) == 1 else 1  # expand
    print_args(vars(opt))
    return opt

def main(opt):
    check_requirements(requirements=ROOT / 'requirements.txt', exclude=('tensorboard', 'thop'))
    run(**vars(opt))

if __name__ == "__main__":
    opt = parse_opt()
    main(opt)