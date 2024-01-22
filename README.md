## Wirebarley

### 개발환경

- 개발도구: Xcode
- 사용언어: Swift

---

### UI

코드베이스로 UI를 개발하였습니다.

### Architecture

MVVM(Model - View - ViewModel)로 구성하였습니다.

### HTTP 통신 (Exception Domain)

https://currencylayer.com/ 의 무료 플랜은 HTTPS 방식이 아니기 때문에 HTTP로 통신해야 합니다.

Info.plist의 Allow Arbitrary Loads를 YES로 하면 통신이 가능합니다만, 다른 HTTP 통신도 전부 다 허용하기 때문에 보안에 위험이 있습니다.

따라서 Exception Domains 내부에 허용할 URL만 작성하는 방식을 채택하였습니다.

### API 요청 이벤트 방식

키패드와 UIPickerView 위에 버튼을 추가하여서 해당 버튼을 누르면 환율을 새로 업데이트 하는 방식을 채택하였습니다.

이 방식의 장점은 API 요청 횟수를 줄일 수 있다는 점입니다.

단점으로 생각되는 부분은 금액을 입력할때마다 결과값이 바뀌지 않고 버튼을 눌러야 결과 값이 바뀌므로, 실시간으로 바뀌는 UI 보다는 사용성면에서 조금 떨어진다고 생각합니다.
