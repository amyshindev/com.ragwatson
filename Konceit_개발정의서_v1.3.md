# Konceit — 고전 영문학 AI 번역·해설 서비스 개발정의서

**버전**: v1.3
**작성일**: 2026-06-15
**개발 형태**: 개인 프로젝트 (1인)

> **네이밍**: "Konceit" = 르네상스 수사학의 핵심 장치인 **Conceit**(정형화된 비유) + **Korean**(한국어 기반 서비스라는 정체성)의 발음적 결합

---

## 1. 프로젝트 개요

### 1.1 한 줄 정의
중세 영어(Middle English)·르네상스 영문학 텍스트를 입력하면 **① 현대 영어 직역 ② 한국어 의역 ③ 사회·문화적 맥락 주석**을 동시에 제공하고, rhetorical device를 자동 분석·시각화하는 AI 기반 층위별(Layered) 번역·해설 서비스.

### 1.2 배경 및 문제 정의
- 구글 번역, 파파고, DeepL 등 범용 번역기는 현대어 중심으로 학습되어 중세 영어의 격변화나 르네상스 시대의 정형화된 비유를 제대로 처리하지 못함
- ChatGPT 등 범용 LLM도 고전 영문학 학습의 초기 진입에는 도움이 되지만, 심화 연구 수준의 깊이·엄밀함은 부족하다는 연구 결과 존재
- 한국어 기반의 고전 영문학 전문 학습/연구 보조 도구는 시장에 부재

### 1.3 출력 언어 범위
- **한국어 단일 언어로 운영**
- 일본어·중국어 등 다국어 출력은 범위에서 제외 — 한국어 콘텐츠의 깊이(주석 품질·작품 커버리지)에 집중하는 전략

---

## 2. 핵심 가치 제안

| 비교축 | 기존 서비스 | Konceit |
|---|---|---|
| 번역 방향 | 현대→현대, 또는 현대→고어(엔터테인먼트) | 고전 영어 → 현대 영어 + 한국어 동시 제공 |
| 주석 | 부재, 또는 인간이 작성한 정적 자료 | AI 생성 + 누적되는 한국어 주석 DB |
| 수사학 분석 | 설명 자료만 존재, 자동 탐지 도구 없음 | Rhetorical Analysis — figurative language · literary devices 자동 분석·시각화 |
| 언어 | 영어 전용 | 한국어 — Folger의 영문 학술 주석 + 일본의 번역 노하우를 한국어로 재구성 |
| 타겟 | 일반 독자 / 해외 고교생 | 한국 영문학 전공자·고전 번역가·대학원생 |

---

## 3. 핵심 기능

### 3.1 층위별 번역 (Layered Translation)
입력: 원문(구절/연 단위)

출력:
1. **현대 영어 직역** — 원문의 어휘·구문을 현대 영어로 1:1 대응
2. **한국어 의역** — 원문의 의미·정서를 살린 한국어 번역
3. **사회·문화적 주석** — 당대 종교·정치·관습적 맥락, 어휘의 역사적 의미 변화

### 3.2 수사학적 장치 분석 (Rhetorical Analysis)
- 희곡·소네트·시 전반에 걸쳐 나타나는 rhetorical device (figurative language, literary devices, stylistic elements 등) 자동 분석
- 원관념-보조관념 매핑을 시각적으로 설명

### 3.3 대상 텍스트 범위
- **셰익스피어 전 작품**: 희곡 37편 + 소네트 154편 + 시 — Folger Digital Texts에서 전체 확보 (퍼블릭 도메인)
- **온디맨드 생성**: 원문 전체를 DB에 보유하되, 주석·번역은 사용자 요청 시 Claude API로 생성 후 캐싱
- **Phase 2+**: 초서 Canterbury Tales 등 중세 영어 텍스트 (격변화 분석 포함) — 별도 코퍼스 연동 필요

---

## 4. 대상 사용자
- 영문학 전공 대학(원)생
- 고전 번역가 / 번역 지망생
- 영문학 교양 강의 수강생

---

## 5. 경쟁 서비스 분석 요약

| 카테고리 | 대표 사례 | 핵심 한계 |
|---|---|---|
| 엔터테인먼트 고어 변환기 | LingoJam, RIZZ AI | 현대→고어 방향, 정확성 미보장, 한국어 없음 |
| AI 고전 리딩 컴패니언 | Rebind.ai (2024 TIME 발명품) | 19~20세기 소설 중심, 언어학적 레이어 없음, 영어 전용 |
| 현대어 대역 | No Fear Shakespeare | 무료·인간 작성, 셰익스피어 외 미지원, 한국어/수사분석 없음 |
| 범용 AI 번역 | 구글/파파고/딥엘/ChatGPT 등 | 고어 처리 부정확, 한국어 학술 주석 없음 |
| 디지털 인문학 코퍼스 | PPCME2 등 | 언어학자용 raw 데이터, 번역/UX/한국어 없음 |
| 정부지원 고전 AI 번역 선례 | 한문고전 자동번역서비스(ITKC) | 한문→한글 도메인, "고전+AI+정부지원" 틀의 선례 |

**핵심 공백**: "중세/르네상스 영문학 + 한국어 레이어 + 문화적 주석 + rhetorical analysis" 통합 서비스 부재.

**가장 강력한 대체재**: ChatGPT/Claude 자체 → 차별화는 ① 층위별 UX, ② 전문 자료 grounding을 통한 정확도, ③ 작품별로 누적되는 주석 DB에서 나옴 (②의 구체적 자산은 6장 참고).

---

## 6. 핵심 참고 자산: Folger Shakespeare Library & 일본 셰익스피어 연구·번역 전통

### 6.1 Folger Shakespeare Library
- 세계 최대 규모의 셰익스피어 자료 컬렉션 (워싱턴 D.C. 소재)
- **Folger Editions / Folger Digital Texts**: 전 희곡 + 소네트·시 전체를 현대 표기로 편집하고, 각 구절마다 어휘·역사·종교·수사적 맥락을 설명하는 주석(gloss)을 함께 제공 (Mowat & Werstine 편집, 2012년부터 디지털화)
- **역할**: "사회·문화적 주석" 레이어의 영어권 학술 기준점. rhetorical device (figurative language, literary devices 등)가 본문 어디에 있는지 식별하는 출발점으로 활용

### 6.2 일본 셰익스피어 연구·번역 전통
- 메이지 시대 坪内逍遥의 전 37작품 번역 이후 130년 이상의 번역·연구 전통 보유
- 와세다대학 츠보우치 박사 기념 演劇博物館(아시아 유일의 연극 전문 박물관), 松岡和子(1996~2021 전집) 등 현대 표준 번역·연구 다수
- **역할**: 한국어 의역의 해석·운율 처리 노하우 벤치마크 (한국은 1920년대 일본을 통해 셰익스피어를 수입한 영향으로 산문 번역 중심 전통이었던 반면, 일본은 무대 운율 번역 노하우를 오래 축적)

### 6.3 활용 원칙
- **Folger**: 영문 주석·어휘 설명을 한국어로 재구성하며, 한국적 비교 관점을 추가해 독자적 콘텐츠로 재생산
- **일본 자료**: 번역문 자체는 인용·변형하지 않고, 해석·운율 처리의 "관점"만 참고
- **공통**: 참고한 자료가 있을 경우 주석에 출처 명시

### 6.4 저작권 고려사항
- 셰익스피어·초서 원문: 퍼블릭 도메인 → 사용 문제 없음
- **Folger Editions/Digital Texts**: CC BY-NC 3.0 (비영리·출처 표기 조건) → 개인/비영리 단계에서는 출처 표기 후 grounding 자료로 활용 가능. 추후 수익화 시, 직접 재배포 대신 "AI 프롬프트 설계용 참고자료"로 활용 방식 전환 검토 필요
- 일본 번역가들의 번역문: 저작권 보호 대상 → 해석 관점만 참고, 번역문 인용 금지

---

## 7. 기술 아키텍처 (1인 개발 기준)

### 7.1 백엔드
- FastAPI + Pydantic v2
- PostgreSQL + SQLAlchemy(async) + Alembic
- 헥사고날 아키텍처: 도메인(원문/번역/주석/rhetorical_analysis) ↔ AI 어댑터(Claude API) ↔ 영속성 계층 분리

**데이터 흐름 (온디맨드 + 캐싱):**
```
① Folger XML 전체 → DB에 원문 적재 (1회성 배치)
② 사용자가 특정 구절/장면 요청
③ DB에 캐싱된 결과 있으면 → 즉시 반환 (API 호출 없음)
   없으면 → Folger grounding 주석 로드 → Claude API 호출 → 생성
④ 생성 결과를 DB에 캐싱 → 동일 구절 재요청 시 재사용
```

### 7.2 AI 레이어
- Claude API: 층위별 번역(직역/의역/주석) 생성 및 rhetorical analysis (figurative language · literary devices 탐지·설명)
- 작품/장르별 프롬프트 템플릿(소네트 vs 희곡 vs 중세 시) 분리 관리
- **Folger Editions의 해당 작품 주석을 프롬프트 컨텍스트로 제공(grounding)하여 주석·rhetorical analysis 정확도 확보 — MVP부터 적용**
- (Phase 2+) PPCME2 등 학술 코퍼스를 RAG로 연동해 중세 영어 형태 분석 정확도 보강

### 7.3 데이터

| 테이블(개념) | 내용 | 적재 시점 |
|---|---|---|
| `works` | 작품 메타데이터 (제목·장르·작성연도 등) | 배치 1회 |
| `passages` | 원문 구절 — 행/연/장면 단위, Folger XML 파싱 결과 | 배치 1회 |
| `layered_translations` | 직역·의역·주석 3단 출력 — `passage_id` FK | 온디맨드 생성 후 캐싱 |
| `rhetorical_analyses` | rhetorical device 분석 결과 — `passage_id` FK | 온디맨드 생성 후 캐싱 |
| `reference_sources` | Folger/일본 자료 출처·라이선스 메타데이터 | 배치 1회 |

- **원문 소스**: Folger Digital Texts XML (희곡 37편 + 소네트 154편 + 시 전체, 퍼블릭 도메인)
- **Folger grounding 주석**: 로컬 보관 — Claude API 호출 시 프롬프트 컨텍스트로 주입 (CC BY-NC 3.0, 출처 표기)
- **캐싱 전략**: 동일 `passage_id`에 대한 결과가 이미 있으면 DB에서 반환, 없으면 생성 후 저장

### 7.4 프론트엔드
- MVP: 원문 + 3단 출력을 한 화면에 표시하는 단일 페이지
- 추후: 프로토타이핑 도구 활용 검토

---

## 8. MVP 범위

### 8.1 범위
- **원문 DB**: Folger Digital Texts XML 전체 배치 적재 — 셰익스피어 희곡 37편 + 소네트 154편 + 시
- **온디맨드 생성 + 캐싱**: 사용자가 요청하는 구절부터 순차적으로 번역·주석·rhetorical analysis 생성
- **grounding**: 모든 생성 요청에 Folger 학술 주석을 컨텍스트로 주입
- **기능**: 3단 레이어 출력 + rhetorical analysis (tenor·vehicle 다이어그램 포함)
- **초서 등 중세 영어**: Phase 2 — Folger 외 별도 코퍼스(PPCME2 등) 연동이 필요해 MVP에서 제외

### 8.2 완료 기준 (Definition of Done)
- [ ] Folger XML 배치 파싱 → `works` / `passages` DB 적재 완료
- [ ] 임의 구절 요청 시 3단 레이어 출력이 일관된 형식으로 생성됨
- [ ] 동일 구절 재요청 시 캐싱된 결과를 반환함 (Claude API 미호출 확인)
- [ ] Rhetorical Analysis 결과가 tenor·vehicle 다이어그램으로 표현됨
- [ ] 주석에 Folger 출처가 구조화되어 기록됨

---

## 9. 로드맵 (1인 기준, 초안)

| 기간 | 내용 |
|---|---|
| 1~2주 | Folger Digital Texts XML 다운로드, 파싱 스크립트 작성, `works`/`passages` DB 배치 적재 |
| 3~4주 | 도메인 모델 설계(헥사고날), DB 스키마, 캐싱 로직 설계 |
| 5~7주 | AI 프롬프트 설계·검증 (Folger grounding 포함 3단 레이어 + rhetorical analysis) |
| 8~10주 | 온디맨드 생성 API 구현, 캐싱 흐름 통합 테스트 |
| 11~12주 | 프론트엔드 MVP (구절 검색 → 결과 표시 단일 페이지) |
| 13주~ | 영문학 전공자 피드백 → 프롬프트 개선, Phase 2 준비 |

> 1인 개발이므로 위 일정에 1.5~2배의 버퍼를 두는 것을 권장

---

## 10. 향후 확장 (Phase 2+)
- 초서 Canterbury Tales 등 중세 영어 텍스트 + 격변화 분석 (PPCME2 연동)
- 형이상학파 시(John Donne 등) — 셰익스피어와 rhetorical device 비교 분석
- (장기) MED(Middle English Dictionary) 연동으로 중세 어휘 정밀도 고도화

---

## 부록: 조사 과정에서 확인된 참고 레퍼런스
- Folger Shakespeare Library — Folger Editions / Digital Texts (Mowat & Werstine 편집, CC BY-NC 3.0)
- Rebind.ai (2024 TIME Invention of the Year)
- No Fear Shakespeare (SparkNotes)
- Penn-Helsinki Parsed Corpus of Middle English (PPCME2)
- 한문고전 자동번역서비스 (한국고전번역원·ITKC)
- 와세다대학 츠보우치 박사 기념 演劇博物館
- 松岡和子, 신역 셰익스피어 전집 (치쿠마문고, 1996~2021)
- 최종철, 셰익스피어 전집 (민음사, 2024)

---

## 변경 이력
| 버전 | 날짜 | 내용 |
|---|---|---|
| v1.0 | 2026-06-15 | 최초 작성 — 서비스 개념, 경쟁분석, 일본 자산 활용 전략, 1인 개발 기준 MVP/로드맵 정리 |
| v1.1 | 2026-06-15 | 프로젝트명 확정(Konceit), Folger Shakespeare Library를 핵심 참고자산으로 추가(6장 재구성, 7.2/8.1 grounding 반영), 다국어 출력 범위 제외(1.3/10장) |
| v1.2 | 2026-06-29 | "Conceit Detection" → "Rhetorical Analysis" 전면 교체 — figurative language · literary devices · stylistic elements를 포괄하는 상위 용어로 통일 |
| v1.3 | 2026-06-29 | 텍스트 범위 확장 — 소네트 5편 → 셰익스피어 전 작품(희곡 37편+소네트 154편+시). 온디맨드 생성+캐싱 아키텍처 도입(7.1/7.3). MVP DoD·로드맵 전면 개정(8/9장) |
