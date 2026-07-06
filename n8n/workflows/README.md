# Automata Gmail Workflow (n8n)

ExaONE이 작성한 메일을 Gmail로 발송하는 n8n 워크플로입니다.

## Import (CLI)

n8n 2.x는 JSON 배열 형식 + `id` 필드 + `--projectId`가 필요합니다.

> **참고:** `n8n list:project` 는 n8n 2.27.x 에 없습니다. PROJECT_ID는 DB 조회로 확인하세요:
> `docker run --rm -v comragwatson_n8n_data:/data alpine sh -c "apk add --no-cache sqlite >/dev/null && sqlite3 -header -column /data/database.sqlite 'SELECT id, name FROM project;'"`

```bash
docker stop n8n
docker run --rm --entrypoint n8n \
  -v comragwatson_n8n_data:/home/node/.n8n \
  -v ./n8n/workflows/automata-gmail-import-array.json:/tmp/import.json:ro \
  n8nio/n8n import:workflow --input=/tmp/import.json --projectId=twiOq01ZuQGyJOrB
docker run --rm --entrypoint n8n -v comragwatson_n8n_data:/home/node/.n8n \
  n8nio/n8n publish:workflow --id=automata-gmail-send-001
docker start n8n
```

이미 배포된 경우 워크플로 ID: `automata-gmail-send-001`

## Gmail credential (UI 1회)

1. http://localhost:5678 → **Automata Gmail Send** 워크플로 열기
2. **Gmail Send** 노드 → Credential 연결 (Google OAuth)
3. 저장 후 Published 상태 유지

## Webhook

| 항목 | 값 |
|------|-----|
| Method | POST |
| Path | `automata` |
| URL (로컬) | `http://127.0.0.1:5678/webhook/automata` |
| URL (Docker backend) | `http://n8n:5678/webhook/automata` |

## 페이로드 (`workflow: gmail-send`)

```json
{
  "workflow": "gmail-send",
  "to": "recipient@example.com",
  "subject": "[Automata] 제목",
  "body": "메일 본문"
}
```

## Phase A 검증 (curl)

```bash
curl -X POST http://127.0.0.1:5678/webhook/automata \
  -H "Content-Type: application/json" \
  -d "{\"workflow\":\"gmail-send\",\"to\":\"YOUR_EMAIL\",\"subject\":\"n8n test\",\"body\":\"Hello from automata\"}"
```

Gmail 수신함에 메일이 도착하면 성공입니다.
