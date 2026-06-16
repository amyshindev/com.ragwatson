---
tags:
  - harness/konceit-root
graph-group: konceit
---

# KONCEIT — ARCHITECTURAL BLUEPRINT & CORE RULES

Konceit은 단일 FastAPI 앱(모노레포 아님)이므로, 이 한 파일이 **루트 블루프린트 + 백엔드 룰 + Cursor 실행 요약**을 통합한다.

> **출처:** [`Konceit_개발정의서_v1.1.md`](./Konceit_개발정의서_v1.1.md) § 7. 기술 아키텍처
> **Trade-off:** Favor carefulness over speed. Trivial tasks may be handled with reasonable judgment.

---

## 1. Core Paradigm

- **Hexagonal + Clean + DDD:**
  - **Domain:** 순수 모델·값 객체·리포지토리 **인터페이스** — FastAPI/SQLAlchemy/Claude SDK import 금지
  - **Application:** 유스케이스(인터랙터)가 워크플로우를 오케스트레이션
  - **Adapters:** HTTP 라우터, PG 리포지토리, **AI 어댑터(Claude API)**, **Grounding 어댑터(Folger/PPCME2)**
- AI(Claude API)는 부가 기능이 아니라 **핵심 도메인 연산을 수행하는 어댑터**다 — 층위별 번역·conceit 탐지의 실제 로직이 여기서 일어난다.

---

## 2. Tech Stack

| 항목 | 선택 |
|---|---|
| API | FastAPI + Pydantic v2 |
| DB | PostgreSQL + SQLAlchemy(async) + Alembic |
| AI | Claude API (Anthropic) |
| Entry | `main.py` — 라우터 등록 + 미들웨어만, 비즈니스 로직 없음 |
| 패키지 루트 | `konceit/` (예: `from konceit.domain.entities import Passage`) |

---

## 3. Domain Model (도메인 엔티티)

| 엔티티 | 설명 |
|---|---|
| `Work` | 작품 (예: Shakespeare's Sonnets) |
| `Passage` | 원문 구절/연 단위 |
| `LayeredTranslation` | 현대 영어 직역 / 한국어 의역 / 사회·문화적 주석 3종 |
| `ConceitAnnotation` | 탐지된 수사학적 장치 — 원관념·보조관념 매핑 |
| `ReferenceSource` | Folger / 일본 자료 등 출처·라이선스 메타데이터 |

---

## 4. Layer Layout

```text
adapter/inbound/api/v1/*_router.py        → HTTP, Pydantic schemas, Depends
dependencies/*_provider.py                → 리포지토리 + 인터랙터 wiring
app/use_cases/*_interactor.py             → 오케스트레이션 (예: GenerateLayeredTranslation)
app/ports/input/*_use_case.py             → inbound port (ABC)
app/ports/output/*_repository.py          → outbound port (ABC)
adapter/outbound/ai/*_claude_adapter.py   → Claude API — 번역/주석/conceit 탐지
adapter/outbound/grounding/*_adapter.py   → Folger(MVP) / PPCME2(Phase 2+) 컨텍스트 로딩
adapter/outbound/pg/*_pg_repository.py    → SQLAlchemy(async)
domain/entities/                          → 순수 도메인
```

(모든 경로는 `konceit/` 하위 기준)

**Depends 규칙:** 의존성은 `dependencies/*_provider.py`와 라우터의 `Depends(...)`에서만 해결. 인터랙터 내부에 `Depends` 금지.

---

## 5. AI 어댑터 & 프롬프트 (`adapter/outbound/ai/`, `prompts/`)

```text
prompts/
  sonnet/            ← MVP (Sonnet 18, 130, 116, 73, 12)
  play/              ← Phase 3+
  middle_english/    ← Phase 2 (Canterbury Tales)
```

- **Grounding (MVP 필수):** `adapter/outbound/grounding/folger_adapter.py` — 해당 `Passage`에 대응하는 Folger Shakespeare Editions 주석을 읽어 프롬프트 컨텍스트에 주입
- **Grounding (Phase 2+):** `adapter/outbound/grounding/ppcme2_adapter.py` — 중세 영어 형태 분석 RAG
- 모든 grounding 호출은 사용된 `ReferenceSource`를 응답에 함께 기록 (출처 추적용)

---

## 6. 데이터 & 영속성 (`adapter/outbound/pg/`)

| 테이블(개념) | 내용 |
|---|---|
| `passages` | 원문 (작품-구절 단위, 퍼블릭 도메인 텍스트) |
| `layered_translations` | 직역/의역/주석 — `passage_id` FK, 누적 |
| `conceit_annotations` | conceit 탐지 결과 — `passage_id` FK |
| `reference_sources` | Folger/일본 자료 출처 + 라이선스(CC BY-NC 등) 메타 |

DB 쓰기는 라우터/트랜잭션 경계에서 `commit`/`rollback`. 스키마 변경은 Alembic 마이그레이션으로 관리.

---

## 7. 프론트엔드

- MVP: 원문 + 3단 출력(직역/의역/주석) + conceit 다이어그램을 한 화면에 표시하는 단일 페이지
- 별도 `frontend/CLAUDE.md` 불필요 — 현재 규모에서는 이 파일이 전체를 커버

---

# Agent Behavioral Guidelines

> **Trade-off:** Favor carefulness over speed. Trivial tasks may use reasonable judgment.

## 1. Think Before Coding
- 가정하지 말 것. 모호함을 숨기지 말고 트레이드오프를 드러낼 것.
- 여러 해석이 가능하면 임의로 고르지 말고 옵션을 제시.
- 예: "conceit 결과를 어떻게 저장할까?" → JSON 컬럼 vs 별도 테이블 — 트레이드오프 명시 후 질문

## 2. Simplicity First
- 요청된 것 이상의 기능/추상화/설정 옵션 추가 금지
- 1인 개발 + MVP 5개 소네트 규모에서 "확장성"을 이유로 미리 일반화하지 말 것
- **Self-check:** "시니어 엔지니어가 보면 과하다고 할까?" → 그렇다면 단순화

## 3. Surgical Changes
- 요청과 직접 관련 없는 코드/포맷팅 "개선" 금지, 기존 스타일 유지
- 변경으로 인해 불필요해진 import/변수만 제거 — 기존 dead code는 언급만

## 4. Goal-Driven Execution
- 모호한 작업 → 검증 가능한 목표로 변환
  - "conceit 탐지 추가" → "Sonnet 18에 대해 Petrarchan conceit 탐지 테스트 작성 후 통과"
  - "Folger grounding 연동" → "프롬프트에 Folger 주석이 컨텍스트로 포함되는지 테스트로 확인"
- 멀티스텝 작업은 짧은 계획 제시:
  ```text
  1. [step] → verify: [확인 방법]
  2. [step] → verify: [확인 방법]
  ```

---

## Self-check (작업 전/후)
- [ ] `domain/`에 FastAPI/SQLAlchemy/Claude SDK import가 섞이지 않았는가?
- [ ] AI 호출은 `adapter/outbound/ai/`에만 위치하는가?
- [ ] Folger/PPCME2 grounding 사용 시 `ReferenceSource`가 함께 기록되는가?
- [ ] DB 쓰기에 commit/rollback이 있는가?
- [ ] `.env`/API 키가 diff에 없는가?

---

## References
- 아키텍처 출처: [`Konceit_개발정의서_v1.1.md`](./Konceit_개발정의서_v1.1.md) § 7
- Agent Behavioral Guidelines 방법론: [Andrej Karpathy (X)](https://x.com/karpathy/status/2015883857489522876), [karpathy-guidelines (GitHub)](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md)
