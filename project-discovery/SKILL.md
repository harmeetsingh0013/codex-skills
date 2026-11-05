---
name: project-discovery
description: Run a bounded initial discovery interview for a 45-minute Java 25 and Spring Boot 4 coding exercise. Ask up to five high-value questions with three options each, then offer a user-controlled checkpoint for finalization, adding requirements, or exactly one optional extension round. Generate a concise project brief and ready-to-run GitHub Spec Kit prompts. Use when starting an interview problem or turning an ambiguous problem statement into an achievable MVP.
---

# Project Discovery — 45-Minute Java/Spring Boot Interview

## Objective and boundaries

Turn the user's interview problem into an implementable, testable MVP **quickly**, not a comprehensive product design. The entire interview is 45 minutes; target **at most 5 minutes** for discovery, leaving time for Spec Kit, coding, and verification. Time constraints are planning targets: do not assert that five minutes have elapsed unless the user reports it or a clock is actually available.

This skill **only** conducts discovery and creates artifacts. Do not run Spec Kit, modify application code, install dependencies, or start implementation. Never continue an interview indefinitely.

## Fixed technical defaults (not interview requirements)

- Java 25, Spring Boot 4.x, Maven.
- Spring Web MVC, Jakarta Bean Validation; Spring Data JPA and H2 **only when persistence is needed**.
- JUnit and Spring Boot Test, MockMvc, Mockito as appropriate; use Spring Boot 4-managed compatible versions instead of pinning libraries.
- A small, layered monolith by default: controller → service → repository; DTOs separate from entities where it adds clarity.
- Constructor injection, centralized API error handling, explicit validation, focused business and integration tests.
- Favor local, in-process solutions over infrastructure, auth, distributed systems, or microservices unless the prompt requires them.

**Precedence:** Explicit interviewer requirements > existing repository constraints and approved decisions > these defaults. Do not question the user about the fixed stack unless there is a conflict that blocks implementation. Do not put all these technology choices into the *functional* specification; they belong in planning and only enduring principles belong in the constitution.

## Default process: at most two rounds, five questions total

### At invocation

1. If the user has not given a problem, ask **only**: "What problem did the interviewer give you? Paste the exact statement if available." This intake is not one of the five design questions. Do not infer a problem.
2. Read the stated problem and, if available, relevant user-provided requirements or project documents. Preserve explicit acceptance criteria and constraints verbatim in meaning.
3. Extract what is known, likely MVP, risks, and unanswered questions. Do not re-ask answered questions.
4. If the statement is already specific enough to implement, ask **zero** questions and go straight to the discovery checkpoint. If the user explicitly requests immediate output, generate artifacts instead.

### Round 1 — requirements (0–3 questions)

Pick **up to three** highest-value unanswered questions from:
- Primary actor and essential workflow / goal.
- Must-have MVP scope and explicit out-of-scope features.
- Business rules, state transitions, and externally visible acceptance behavior.

### Round 2 — implementation-critical ambiguity (0–2 questions)

After the user answers round 1, ask **up to two** new questions ONLY if their answers change the domain model, API behavior, correctness, or feasibility. Common candidates:
- Data/entities and relationships; persistence/consistency needs.
- Critical edge cases: duplicate requests, ordering, invalid inputs, missing resources, concurrency, error conditions.

Round 2 must not merely reword previous questions. If no critical ambiguity remains, stop without round 2.

### Question format

- **Default discovery:** maximum five questions total and two question batches. Number consecutively Q1–Q5. **Only an explicit `CONTINUE` can authorize more questions**, up to three per additional round.
- Each question has **exactly three** distinct context-specific options **A/B/C** with a short trade-off for each. Mark one **Recommended**, with a one-sentence rationale.
- Allow free-form / "Other" answers in addition to A/B/C; do not make a fourth enumerated option.
- Ask the user to reply compactly (e.g. `1B, 2A, 3C`) or override an option.
- Do not ask broad preference questions already fixed by Java 25 + Spring Boot 4.
- Do not ask the user to approve each artifact or reopen discovery after the limit.

### Discovery checkpoint — mandatory after default rounds

After the default questioning phase, **stop asking questions** and show a compact summary of decisions and remaining risks. Offer a single clear choice:

- `FINALIZE` (or `FAST-FORWARD`, `DONE`): create/update the three artifacts and finish.
- `CONTINUE [topic]`: authorize **one and only one** additional round of **up to three** targeted questions, each with A/B/C options, recommendation, and trade-offs. After answers, return to this checkpoint. Do not assume another `CONTINUE`.
- `ADD REQUIREMENT: ...`: incorporate user-provided requirements, check conflicts and impact on existing decisions, then return to checkpoint **without automatically asking a new batch**. If a blocker emerges, mention it and offer `CONTINUE [topic]`.
- `REVISIT Q<n>: ...`: replace or refine that decision, note downstream effects, and return to checkpoint. Don't rerun previous questions.

If user asks for new requirements or an extra round **after** artifacts are generated, resume using the existing project brief and conversation decisions. Do not restart from scratch. Update the three files while preserving unrelated user edits; flag conflicts instead of silently overwriting manually edited content.

### Hard stops and budget

- Never initiate an extra round without an explicit `CONTINUE` command or an unambiguous request for another question round.
- Never ask more than three questions in any authorized extra round; return to checkpoint after each round.
- `FINALIZE`, `FAST-FORWARD`, `SKIP`, `DONE`, or request to generate artifacts means **generate immediately**, no further questioning.
- If the user says the five-minute discovery budget has expired, stop interviewing and finalize with labeled assumptions, without a confirmation gate.
- If the user provides incomplete answers, choose clearly labeled MVP assumptions for noncritical details and flag blockers as **Unresolved**.
- Keep track of the number of questions and extension rounds in the current conversation; recap briefly at the checkpoint. Do not assert actual elapsed time without a clock.
- An extra round is optional and knowingly takes time away from implementation. Prioritize preserving the 45-minute interview goal.

## Discovery decision discipline

For each selected answer, record decision, reason, and trade-off. Distinguish clearly:
- **Given**: from the interviewer/user.
- **Decided**: chosen in discovery.
- **Assumed**: pragmatic default, not confirmed.
- **Unresolved**: a material ambiguity requiring later confirmation.

Prefer a thin vertical slice that can compile, run, and be demonstrated within the interview. Exclude optional login, analytics, notifications, advanced deployment, scalability infrastructure, etc. unless requested.

## Create exactly three project artifacts

Unless the user explicitly asks for chat-only output, create these **relative to the active project root** (create parent directories as needed):

1. `docs/discovery/project-brief.md` — **at most 400 words**; use headings: Problem, Users and goal, MVP scope, Requirements / acceptance criteria, Domain model, Decisions and trade-offs, Assumptions and unresolved, Out of scope. Retain any requirements IDs from the prompt; otherwise assign small stable `FR-01` IDs. Include 2–5 concrete, externally testable acceptance scenarios. Avoid promising unspecified production guarantees.
2. `docs/discovery/constitution-prompt.md` — a **ready-to-paste Codex message** starting with `$speckit-constitution`. Include project-wide, durable principles only: architecture simplicity, correctness, quality, testing, input validation, error handling, security appropriate to scope, and stack constraints where enduring. Reference `docs/discovery/project-brief.md`. State: *Do not add feature requirements to the constitution.* Keep it concise.
3. `docs/discovery/specify-prompt.md` — a **ready-to-paste Codex message** starting with `$speckit-specify`. Describe what and why, target users, functional requirements and acceptance scenarios, edge cases, exclusions, and sources of truth. Reference `docs/discovery/project-brief.md`. Request that ambiguities be flagged rather than silently filled. **Do not prescribe Spring classes, database tables, or frameworks here**; the plan stage handles how.

Never overwrite user-authored files silently: if existing output files contain user changes, preserve them and use an alternate filename or ask only if necessary. Do not invent or modify existing requirements. If files cannot be written, provide their full contents in the response with paths.

## Final response — concise handoff

When `FINALIZE` generates artifacts, show:
- 2–4 sentences summarizing the MVP, decisions, and important assumptions.
- The three artifact paths.
- The immediate next action: paste `docs/discovery/constitution-prompt.md` into Codex; review constitution, then paste `docs/discovery/specify-prompt.md`; continue with `$speckit-plan`, `$speckit-tasks`, `$speckit-implement`, and run tests. Only suggest `$speckit-clarify` if a critical ambiguity survives.

Do not restart questions automatically after creating artifacts. Only re-enter discovery if the user explicitly requests `CONTINUE`, `ADD REQUIREMENT`, or `REVISIT`. Do not claim the app is implemented or validated.
