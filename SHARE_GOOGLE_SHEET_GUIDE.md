# ⚠️ 구글 시트 공유 권한 설정 필요

## 🔴 현재 문제
```
❌ The caller does not have permission
```

서비스 계정이 구글 시트에 접근할 수 없습니다.

---

## ✅ 해결 방법 (5분 소요)

### 1단계: 구글 시트 열기
스프레드시트 ID로 접속:
```
https://docs.google.com/spreadsheets/d/1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA/edit
```

---

### 2단계: 공유 버튼 클릭
우측 상단의 **"공유"** 또는 **"Share"** 버튼 클릭

---

### 3단계: 서비스 계정 이메일 추가
"사용자 및 그룹 추가" 입력란에 다음 이메일 입력:

```
sheets-importer@cruise-7683b.iam.gserviceaccount.com
```

---

### 4단계: 권한 설정
- 권한: **뷰어(Viewer)** 선택
- "알림 보내기" 체크 해제 (선택사항)
- **"전송"** 또는 **"Send"** 클릭

---

### 5단계: 확인
공유 목록에 다음이 표시되어야 함:
```
✅ sheets-importer@cruise-7683b.iam.gserviceaccount.com (뷰어)
```

---

## 🎯 완료 후 다시 실행

```powershell
node scripts/step1-import-users-from-sh-m.js
```

---

## 💡 참고 사항

### 왜 필요한가요?
- Google Sheets API는 서비스 계정 인증을 사용합니다
- 서비스 계정은 일반 Gmail 계정처럼 작동합니다
- 시트를 읽으려면 명시적으로 공유 권한이 필요합니다

### 안전한가요?
- ✅ 읽기 전용(뷰어) 권한만 부여됩니다
- ✅ 데이터를 수정하거나 삭제할 수 없습니다
- ✅ 프로젝트 전용 서비스 계정입니다

### 다른 시트도 공유해야 하나요?
- 아니요, **하나의 스프레드시트만** 공유하면 됩니다
- 스프레드시트 내의 모든 탭(SH_M, 렌터카, 공항 등)이 자동으로 접근 가능합니다

---

## 🔍 시트 구조 확인 (선택사항)

공유 후 시트에 다음 탭들이 있는지 확인하세요:

- [ ] SH_M (사용자 정보)
- [ ] 렌터카 또는 렌트카
- [ ] 공항
- [ ] 호텔
- [ ] 크루즈
- [ ] 차량 또는 크루즈 차량
- [ ] 투어

**SH_M 시트의 필수 컬럼:**
- 이메일 (Email)
- 이름 (Name) - 선택사항
- 전화번호 - 선택사항

---

## 📞 추가 도움

공유 완료 후에도 오류가 발생하면:
1. 5분 정도 대기 (권한 반영 시간)
2. 스크립트 재실행
3. 시트 URL이 올바른지 확인

**스프레드시트 ID 확인:**
`.env.local` 파일의 `GOOGLE_SHEETS_ID` 값:
```
GOOGLE_SHEETS_ID=1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA
```

이 값이 실제 시트 URL과 일치하는지 확인하세요.
