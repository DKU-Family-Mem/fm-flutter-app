# DKU Family Memory App

단국대학교 가족 추억 앱 프로젝트입니다. 이 앱은 가족들과의 채팅 내용을 AI로 분석하여 다이어리를 자동 생성하는 등 가족의 소중한 추억을 기록하고 공유할 수 있는 앱입니다.
## 패키지 설치

```bash
flutter pub get
```

## 실행 방법

```bash
flutter run
```

## 프로젝트 설정

### Firebase 설정 방법 (팀원용)

안전한 개발을 위해 Firebase 설정은 각자 직접 생성합니다:

1. 관리자로부터 Firebase 프로젝트 접근 권한을 받습니다. (이메일로 초대됨)
2. FlutterFire CLI를 설치합니다:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. 프로젝트 설정 파일을 생성합니다:
   ```bash
   flutterfire configure --project=dku-family-mem
   ```
4. 생성된 `firebase_options.dart` 파일에서 API 키 등의 정보를 `.env` 파일로 옮깁니다.

이렇게 하면 API 키를 직접 공유하지 않고도 안전하게 설정할 수 있습니다.

### 환경 변수 설정

이 프로젝트는 환경 변수를 사용하여 Firebase API 키와 같은 민감한 정보를 관리합니다.

1. 프로젝트 루트에 `.env` 파일을 생성합니다.
2. `.env.example` 파일을 참고하여 필요한 환경 변수를 설정합니다.
3. Firebase 콘솔에서 자신의 프로젝트를 생성하고 필요한 API 키를 얻습니다.

```bash
# .env 파일 예시
# Android
FIREBASE_ANDROID_API_KEY=your_android_api_key
FIREBASE_ANDROID_APP_ID=your_android_app_id
# ... 나머지 환경 변수들
```

