---
tags:
  - harness/claude-root
graph-group: claude-root
---

# ARCHITECTURAL BLUEPRINT & CORE RULES (TOP-LEVEL)

Canonical source for the **entire monorepo**. Scoped stacks and domains link out below — do not duplicate their detail here.

> **Precedence:** This file wins over `.cursorrules`, `CURSOR..md`, and child `CLAUDE.md` files on **structure, SOLID/DDD boundaries, and cross-repo concerns**. Child files win on **stack- or domain-specific implementation** when this file is silent.

---

## 1. Core Paradigm: Harness Engineering & PKS

- **Karpathy's Harness Engineering:** Build programmatic scaffolding where LLM agents and human workflows interact seamlessly.
- **Wiki + LLM Personal Knowledge System (PKS):** Personal markdown wiki data and LLM context/embedding pipelines are first-class domain citizens.

---

## 2. Design Principles & Architecture

- **Strict SOLID Compliance:** Maximize SRP and ISP. Decouple domain logic from LLM, DB, and UI infrastructure.
- **Hexagonal + Clean + DDD (summary):**
  - **Domain:** Pure models, value objects, repository **interfaces** — no framework, DB, or LLM SDK imports.
  - **Application:** Use cases / interactors orchestrate workflows.
  - **Adapters:** HTTP routers, ORM, PG repositories, external APIs.

---> **Backend layer layout, `PYTHONPATH`, and `@backend` import rules** live in [`backend/CLAUDE.md`](backend/CLAUDE.md).

---> **React / Next.js UI rules** live in [`frontend/CLAUDE.md`](frontend/CLAUDE.md).

---> **Per-domain app rules** (sibling apps under `backend/apps/`) live in each app's `.docs/CLAUDE.md`, e.g. [`backend/apps/titanic/_docs/CLAUDE.md`](backend/apps/titanic/_docs/CLAUDE.md).

---

## 3. Document Hierarchy

| Level | File | When to read |
|-------|------|----------------|
| **Repository root** | [`CLAUDE.md`](CLAUDE.md) (this file) | Always — blueprint + agent behavior |
| **Backend** | [`backend/CLAUDE.md`](backend/CLAUDE.md) | Any change under `backend/` |
| **Frontend** | [`frontend/CLAUDE.md`](frontend/CLAUDE.md) | Any change under `frontend/` |
| **Domain app** | `backend/apps/{app}/.docs/CLAUDE.md` | Work inside that app package (e.g. `titanic`, `audio`, `user`) |

**Sibling app pattern:** `backend/apps/` grows by adding peer packages (`titanic`, `audio`, `user`, …). Each app owns its hexagonal tree and optional `.docs/CLAUDE.md`. Shared infrastructure stays in `backend/core/`, `backend/apps/db/`, etc.

**Implementation playbooks (human + agent):**

| Stack | Deep rules |
|-------|------------|
| Backend | [`docs/DevOps/Backend/BACKEND_RULES.md`](docs/DevOps/Backend/BACKEND_RULES.md) |
| Frontend | [`docs/DevOps/Frontend/REACT_RULES.md`](docs/DevOps/Frontend/REACT_RULES.md) |
| Index | [`docs/DevOps/README.md`](docs/DevOps/README.md) |

**Harness execution summary:** [`.cursorrules`](.cursorrules) · **Design rationale:** [`CURSOR..md`](CURSOR..md)

---

# Agent Behavioral Guidelines

Subordinate to the Architectural Blueprint above. When behavioral guidance conflicts with core architecture or layering, the blueprint wins.

> **Trade-off:** Favor carefulness over speed. Trivial tasks may be handled with reasonable judgment.

## 1. Think Before Coding

**Do not assume. Do not hide ambiguity. Surface trade-offs.**

Before implementing:

- State your assumptions explicitly. Ask when uncertain.
- If multiple interpretations exist, present alternatives instead of choosing arbitrarily.
- If a simpler approach exists, say so. Push back on the request when justified.
- When unclear, stop. Identify specifically what is confusing and ask questions.

## 2. Simplicity First

**Write only the minimum code required to solve the problem. Do not add speculative code.**

- Do not add features beyond what was requested.
- Do not create abstraction layers for one-off code.
- Do not add unrequested "flexibility" or configurability.
- Do not handle edge cases for scenarios that are unrealistic in practice.
- If something written in 200 lines can be written in 50, rewrite it.

**Self-check:** "Would a senior engineer consider this code overly complex?" If yes, simplify.

## 3. Surgical Changes

**Touch only what is necessary. Clean up only what your change leaves behind.**

When modifying existing code:

- Do not "improve" adjacent code, comments, or formatting.
- Do not refactor code that is not broken.
- Follow existing style even when it differs from your own.
- If you find dead code unrelated to the task, **mention it only** — do not delete it without a request.

For leftovers caused by your change:

- Remove imports, variables, and functions made unnecessary **by your change**.
- Leave pre-existing dead code in place unless explicitly asked to remove it.

**Verification:** Every changed line must connect directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria and loop until they are met.**

Turn vague tasks into verifiable goals:

- "Add validation" → "Write tests for invalid input and make them pass"
- "Fix bug" → "Write a reproduction test and make it pass"
- "Refactor X" → "Confirm tests pass before and after"

For multi-step work, state a short plan:

```text
1. [step] → verify: [what to check]
2. [step] → verify: [what to check]
3. [step] → verify: [what to check]
```

Success criteria must be explicit enough to iterate independently.

---

## How to Verify These Guidelines Work

- Unnecessary changes in diffs decrease
- Rework caused by over-complexity decreases
- Pre-implementation questions lead to clearer decisions

## References

- [Andrej Karpathy (X)](https://x.com/karpathy/status/2015883857489522876)
- [karpathy-guidelines (GitHub)](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md)
- Backend scope: [`backend/CLAUDE.md`](backend/CLAUDE.md)
- Frontend scope: [`frontend/CLAUDE.md`](frontend/CLAUDE.md)
- Titanic domain: [`backend/apps/titanic/_docs/CLAUDE.md`](backend/apps/titanic/_docs/CLAUDE.md)
