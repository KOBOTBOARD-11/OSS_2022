import numpy as np
import cv2
import asyncio
import websockets
import base64

async def hello():
    async with websockets.connect("ws://localhost:6000") as websocket:
        while(True):
            raw_data = await websocket.recv()
            data = cv2.imdecode(np.frombuffer(base64.b64decode(raw_data), dtype='uint8'), cv2.IMREAD_COLOR)
            print(data)
            global imdata
            imdata = data
            cv2.imshow('test', imdata)
            if cv2.waitKey(1) > 0: break
        cv2.destroyAllWindows()


asyncio.run(hello())