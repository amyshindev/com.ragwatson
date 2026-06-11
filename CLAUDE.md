# ARCHITECTURAL BLUEPRINT & CORE RULES (TOP-LEVEL)

## 1. Core Paradigm: Harness Engineering & PKS
- **Karpathy's Harness Engineering:** The system must be built as a programmatic scaffolding (harness) where LLM agents and human workflows interact seamlessly.
- **Wiki + LLM Personal Knowledge System (PKS):** Personal markdown-based wiki data and LLM context/embedding pipelines must be treated as first-class domain citizens.

## 2. Design Principles & Architecture
- **Strict SOLID Compliance:** Every module, class, and function must rigorously adhere to SOLID principles. Maximize SRP (Single Responsibility) and ISP (Interface Segregation) to decouple domain logic from LLM infrastructure.
- **Hexagonal + Clean + DDD (Domain-Driven Design):**
  - **Domain Layer:** Must contain pure domain models, value objects, and repository interfaces. Absolutely ZERO external framework, DB, or LLM SDK dependencies.
  - **Application Layer:** Orchestrates use cases (e.g., executing a harness workflow, indexing wiki files).
  - **Infrastructure/Adapters:** Implements concrete LLM clients, vector databases, and local file systems.

## 3. Strict Module Pathing Rules (@backend)
- **Root Omission:** For all internal paths under @backend, completely omit `backend` and `apps` directories from the root structure.
- **Explicit Core Entry:** The absolute module path for the core system must explicitly begin with `backend.core.` (e.g., `backend.core.domain.models...`).

---

# Agent Behavioral Guidelines

These practices are **subordinate** to the Architectural Blueprint above. When behavioral guidance conflicts with core architecture, SOLID/DDD layering, or module pathing rules, the top-level blueprint takes precedence.

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

Success criteria must be explicit enough to iterate independently. Weak criteria like "just make it work" invite repeated clarification.

---

## How to Verify These Guidelines Work

- Unnecessary changes in diffs decrease
- Rework caused by over-complexity decreases
- Pre-implementation questions lead to clearer decisions

## References

- [Andrej Karpathy (X)](https://x.com/karpathy/status/2015883857489522876) — original observations
- Community summary: [karpathy-guidelines (GitHub)](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md)
