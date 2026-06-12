---
tags:
  - harness/cursor
graph-group: cursor
---

# Cursor Harness Engineering

This document explains **why** the repository's Cursor harness is structured as it is, and how to review it. The philosophy follows Andrej Karpathy's [observations on LLM coding failures](https://x.com/karpathy/status/2015883857489522876) and [Karpathy Guidelines](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md), integrated with the **Architectural Blueprint** in [`CLAUDE.md`](CLAUDE.md).

> **Trade-off:** Favor carefulness over speed. Trivial tasks may use reasonable judgment.

---

## 1. Document Hierarchy

Rules are split by role. **Never contradict** the top-level Architectural Blueprint in `CLAUDE.md`.

| Artifact | Role |
|----------|------|
| [`CLAUDE.md`](CLAUDE.md) | **Canonical source of truth.** Blueprint + Agent Behavioral Guidelines. |
| [`backend/CLAUDE.md`](backend/CLAUDE.md) | Backend module pathing, `apps/` siblings, hexagonal layers. |
| [`frontend/CLAUDE.md`](frontend/CLAUDE.md) | Next.js layout, API integration. |
| `backend/apps/{app}/.docs/CLAUDE.md` | Per-domain rules (e.g. [`titanic`](backend/apps/titanic/_docs/CLAUDE.md)). |
| [`.cursorrules`](.cursorrules) | **Root execution harness** — links scoped `.cursorrules` below. |
| `backend/.cursorrules`, `frontend/.cursorrules`, `apps/*/.docs/.cursorrules` | Scoped execution summaries per stack/domain. |
| This file (`CURSOR..md`) | **Design & review lens.** What the harness counters, quality checks, onboarding. |
| `.cursor/rules/*.mdc` | **Scoped globs.** Backend/frontend patterns when matching paths are edited. |
| `docs/DevOps/**` | **Implementation rules** (layers, DB, API, React). Mandatory before domain coding. |

**When editing rules:** Put execution wording in `.cursorrules`; put architecture and behavioral depth in `CLAUDE.md`; put rationale and review checklists here.

---

## 2. What the Harness Counteracts

Agents tend toward predictable failure modes. The harness **structurally offsets** them.

| Tendency | Harness response |
|----------|------------------|
| Silent assumptions | Think before coding: expose assumptions, ambiguity, trade-offs |
| Over-generalization / over-abstraction | Simplicity first: no out-of-scope code |
| Bloated diffs | Surgical changes: every changed line ties to the request |
| Weak "done" criteria | Goal-driven execution: verifiable success criteria |

These map directly to the four behavioral guidelines in [`CLAUDE.md`](CLAUDE.md) and the summary in [`.cursorrules`](.cursorrules).

---

## 3. Agent Behavioral Guidelines

**Do not duplicate here.** Full rules, examples, and verification patterns:

→ [`CLAUDE.md`](CLAUDE.md) § Agent Behavioral Guidelines

At a glance (subordinate to the Architectural Blueprint):

1. **Think Before Coding**
2. **Simplicity First**
3. **Surgical Changes**
4. **Goal-Driven Execution**

---

## 4. Harness Quality Review

Use this checklist when onboarding, reviewing agent output, or updating the harness itself.

- Are unrelated changes absent from the diff?
- Has over-engineering and rework decreased?
- Did questions and trade-offs surface **before** implementation when needed?
- Is success criteria written as **reproducible action** (test, build, manual scenario)?
- Does the change respect SOLID/DDD layering and `@backend` module pathing from `CLAUDE.md`?
- For `backend/` work: were applicable `docs/DevOps/**` rules read first?

---

## 5. References

- [Andrej Karpathy (X)](https://x.com/karpathy/status/2015883857489522876)
- [karpathy-guidelines / SKILL.md](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md)
- Canonical rules: [`CLAUDE.md`](CLAUDE.md)
- Execution harness: [`.cursorrules`](.cursorrules)
