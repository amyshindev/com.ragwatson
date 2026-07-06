# Automata Gmail Inbound (n8n)

Gmail 수신함에 새 메일이 오면 n8n이 홈페이지 백엔드 API로 전달합니다.

## 흐름

```text
Gmail Trigger (1분 폴링)
  → Map Mail Fields
  → POST http://backend:8000/automata/inbound/mail
  → 메모리 저장 (GET /automata/inbound/mail 로 조회)
```

## 사전 준비

### 1. 백엔드 `.env` (선택 — 보안 권장)

```env
AUTOMATA_INBOUND_SECRET=your-random-secret-here
```

n8n 컨테이너도 `backend/.env`를 읽어 같은 값을 `X-Automata-Inbound-Secret` 헤더로 보냅니다.  
비워 두면 로컬 개발용으로 인증 없이 수신합니다.

백엔드를 **호스트에서만** 실행할 때는 n8n 환경변수를 바꿉니다.

```env
AUTOMATA_BACKEND_URL=http://host.docker.internal:8000
```

### 2. PROJECT_ID 확인 (n8n 2.27.x)

`docker exec n8n n8n list:project` 는 **이 버전에 없습니다** (`Command "list:project" not found`).

DB에서 확인:

```bash
docker run --rm -v comragwatson_n8n_data:/data alpine sh -c "apk add --no-cache sqlite >/dev/null && sqlite3 -header -column /data/database.sqlite 'SELECT id, name, type FROM project;'"
```

현재 인스턴스 PROJECT_ID: **`twiOq01ZuQGyJOrB`**

워크플로 목록: `docker exec n8n n8n list:workflow`

### 3. Import (CLI)

```bash
docker stop n8n
docker run --rm --entrypoint n8n \
  -v comragwatson_n8n_data:/home/node/.n8n \
  -v ./n8n/workflows/automata-gmail-inbound-import-array.json:/tmp/import.json:ro \
  n8nio/n8n import:workflow --input=/tmp/import.json --projectId=twiOq01ZuQGyJOrB
docker run --rm --entrypoint n8n -v comragwatson_n8n_data:/home/node/.n8n \
  n8nio/n8n publish:workflow --id=automata-gmail-inbound-001
docker start n8n
```

워크플로 ID: `automata-gmail-inbound-001`

### 4. Gmail credential (UI 1회)

1. http://localhost:5678 → **Automata Gmail Inbound** 워크플로 열기
2. **Gmail Trigger** 노드 → Gmail OAuth 연결 (발송 워크플로와 동일 계정 가능)
3. **Active** 켜기 (Published)

## API

| Method | Path | 용도 |
|--------|------|------|
| POST | `/automata/inbound/mail` | n8n → 수신 메일 저장 |
| GET | `/automata/inbound/mail?page=1&page_size=50` | 홈페이지 수신함 조회 |

### POST body (n8n → backend)

```json
{
  "message_id": "18f2abc...",
  "from": "sender@example.com",
  "from_name": "홍길동",
  "subject": "제목",
  "body": "본문"
}
```

`from`은 `"이름 <email@example.com>"` 형식도 허용합니다.

### 검증 (curl)

```bash
curl -X POST http://127.0.0.1:8000/automata/inbound/mail \
  -H "Content-Type: application/json" \
  -d "{\"from\":\"test@example.com\",\"subject\":\"테스트\",\"body\":\"본문입니다.\"}"

curl "http://127.0.0.1:8000/automata/inbound/mail?page=1&page_size=10"
```

## 발송 워크플로

기존 발송: [`README.md`](README.md) · `automata-gmail-import-array.json`
