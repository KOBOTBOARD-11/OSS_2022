# Google Cloud Function (Firebase)

## Functions 설명

- Cloud Function Frebase Cloud Messeging 서비스와 연결하여 Firestore에서 저장되는 초기 화재 정보 및 인원 감지 정보 업로드가 일어날 때마다 애플리케이션으로 알람을 보내는 기능을 구현했다.

## Functions 기능

- `sendFireNotifications()`

  - Firestore에 초기 화재 정보가 저장되면 이벤트 트리거로 인해 애플리케이션으로 화재 감지 알림을 전송한다.

- `sendTestNotifications()`
  - Firestore에 인원 감지 정보가 저장되면 이벤트 트리거로 인해 애플리케이션으로 인원 감지 알림을 전송한다.

## Functions 구조

```
...
├── functions/
│   ├── eslint.js
│   ├── index.js    #source file
│   ├── package-lock.json
│   ├── package.json
├── .firebaserc
├── firebase.json
├── firestore.indexes.json
├── firestore.rules
...
```
