---
name: project-discovery
description: Run a bounded, two-round project discovery for a Java 25 and Spring Boot 4 application. Ask up to five high-value initial questions with three options each, offer a brief decision checkpoint and optional user-requested follow-up, then produce a concise project brief and ready-to-run GitHub Spec Kit constitution and specify prompts. Use when starting a project or turning an ambiguous problem statement into an achievable MVP.
---

# Project Discovery — Java 25 / Spring Boot 4

## Objective and boundaries

Turn the user's problem into an implementable, testable MVP **efficiently**, not a comprehensive product design. Keep discovery bounded and focused on decisions that affect correctness, scope, and feasibility; leave room for specification, implementation, and verification. Do not introduce arbitrary time limits or mention an evaluation or preparation context in generated artifacts.

This skill **only** conducts discovery and creates artifacts. Do not run Spec Kit, modify application code, install dependencies, or start implementation. Never continue discovery indefinitely.

## Fixed technical defaults (not product requirements)

- Java 25, Spring Boot 4.x, Maven.
- Spring Web MVC, Jakarta Bean Validation; Spring Data JPA and H2 **only when persistence is needed**.
- JUnit and Spring Boot Test, MockMvc, Mockito as appropriate; use Spring Boot 4-managed compatible versions instead of pinning libraries.
- A small, layered monolith by default: controller → service → repository; DTOs separate from entities where it adds clarity.
- Constructor injection, centralized API error handling, explicit validation, and focused tests. Do not introduce integration or end-to-end tests when the approved scope excludes them.
- Favor local, in-process solutions over infrastructure, auth, distributed systems, or microservices unless the prompt requires them.

### Java 25 implementation guidance (project-wide; use only when relevant)

- **Records:** Prefer Java records for immutable request/response DTOs and small value carriers when appropriate. Do not force records onto mutable JPA entities or types that require framework-managed mutation.
- **Switch expressions and pattern matching:** Prefer these features when they materially simplify branching or type-safe business logic. Do not introduce artificial branching solely to demonstrate language features.
- **Sealed interfaces:** Consider sealed interfaces/classes for genuinely closed sets of domain outcomes or states. Avoid extra hierarchies for simple results.
- **Virtual threads (default for Spring Boot applications):** Configure Spring Boot 4.x applications running on Java 25 to use virtual threads by default with `spring.threads.virtual.enabled=true` in the application configuration. Prefer Spring Boot-managed request execution, task execution, and scheduling instead of manually creating or managing threads. Carry this default into `constitution-prompt.md` as an engineering principle and ensure the later technical plan explicitly includes the configuration and verification. Do not claim that every component or third-party executor automatically uses virtual threads: verify the actual runtime configuration. If an explicitly approved runtime constraint or measurable incompatibility prevents virtual-thread use, document the exception and seek approval rather than silently falling back. Virtual threads can improve scalability for workloads with blocking I/O; do not promise a throughput improvement without evidence. They do not replace database transaction isolation, pessimistic locking, or resource-pool sizing.
- **Concurrency and consistency:** Prefer framework-managed concurrency, transactions, database constraints, and appropriately configured JPA locking over manually coordinated threads, intrinsic locks (`synchronized`), `wait`/`notify`, or explicit JVM mutexes. `@Transactional` alone does **not** guarantee that concurrent availability-check-and-insert workflows cannot conflict; where correctness requires it, design an appropriate database-level guard or equivalent high-level coordination and test the guarantee. Do not add concurrency mechanisms where the approved requirements do not need them.
- **Version discipline:** Use supported Java 25 / Spring Boot 4 APIs and framework-managed versions. Avoid preview or incubating Java features unless explicitly approved and build/runtime flags are configured.

These are **engineering preferences**, not product features. Include relevant, durable principles in `constitution-prompt.md` and leave detailed framework/API and concurrency design to Spec Kit planning. Do not inject these implementation choices into the functional `specify-prompt.md` or the project's functional requirements.

### Artifact and communication hygiene

- Never mention personal preparation, session duration, timers, evaluation context, or coaching language in generated project artifacts or ready-to-run Spec Kit prompts unless the user explicitly requests that content in a particular artifact.
- Keep generated artifacts professional and product-focused. Preserve real business deadlines only if the user explicitly states them as product requirements.

**Precedence:** Explicit user-provided requirements > existing repository constraints and approved decisions > these defaults. Do not question the user about the fixed stack unless there is a conflict that blocks implementation. Do not put all these technology choices into the *functional* specification; they belong in planning and only enduring principles belong in the constitution.

## Default process: at most two automatic rounds, five initial questions total

### At invocation

1. If the user has not given a problem, ask **only**: "What problem are you trying to solve? Paste the exact statement if available." This intake is not one of the five design questions. Do not infer a problem.
2. Read the stated problem and, if available, relevant user-provided requirements or project documents. Preserve explicit acceptance criteria and constraints verbatim in meaning.
3. Extract what is known, likely MVP, risks, and unanswered questions. Do not re-ask answered questions.
4. If the statement is already specific enough to implement, ask **zero** questions and proceed to the brief decision checkpoint. Never invent missing business requirements.

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

- **Maximum five questions in the initial discovery**, **maximum two automatic question batches**. Number consecutively Q1–Q5. Extra questions are permitted only if explicitly requested by the user at a checkpoint.
- Each question has **exactly three** distinct context-specific options **A/B/C** with a short trade-off for each. Mark one **Recommended**, with a one-sentence rationale.
- Allow free-form / "Other" answers in addition to A/B/C; do not make a fourth enumerated option.
- Ask the user to reply compactly (e.g. `1B, 2A, 3C`) or override an option.
- Do not ask broad preference questions already fixed by Java 25 + Spring Boot 4.
- Do not ask the user to approve each artifact. After the initial questions, provide one compact decision checkpoint rather than automatically extending discovery.

### Decision checkpoint and user-controlled extension

After the default questions have been answered (or none are needed), show a **compact decision checkpoint**: Given, Decided, Assumed, Unresolved, and the intended MVP boundary. This is a short summary, not another questionnaire. Then offer these actions:

- `FINALIZE` — write the three artifacts now (recommended when critical decisions are clear).
- `CONTINUE` — ask **one** optional additional batch of up to three new, high-value A/B/C questions based on unresolved issues or the user's specified focus; then return to the checkpoint. Never start another batch unless `CONTINUE` is explicitly requested again.
- `ADD REQUIREMENT: <text>` — record the user-supplied requirement verbatim in meaning, check for contradictions and affected decisions, and return to the checkpoint. Ask a clarifying question only if the new requirement cannot be interpreted safely; do not silently change prior choices.
- `REVISIT Q<n>: <new answer or clarification>` — revise that answer and dependent decisions, mark affected assumptions, and return to the checkpoint.
- `FAST-FORWARD`, `SKIP`, or `DONE` — aliases for `FINALIZE`.

If user requests artifacts at any point, immediately finalize without further questions. If the user explicitly asks to finalize immediately, do so; do not wait for checkpoint approval. Never silently reinterpret unapproved recommendations as requirements.

After an optional batch, do not automatically ask more questions. Keep question numbering unique across batches. Do not use the 5-question initial cap to block an explicitly requested extension; **the additional rounds are strictly opt-in**.

For unfinished or incomplete answers, label pragmatic noncritical defaults **Assumed**, and critical unanswered items **Unresolved**. Do not claim they are decided. If a critical unresolved item blocks implementation, note the blocker in the brief rather than inventing its answer.

### Updating discovery after artifact generation

If the user asks to add requirements or continue after files already exist, read the existing project brief and discovery artifacts first, preserve previously Given/Decided items, apply only user-approved changes, and regenerate the same three outputs. Never overwrite unrelated or manually edited content silently; explain conflicts and use alternative filenames when needed. Do not restart from the initial problem or auto-run further rounds.

## Discovery decision discipline

For each selected answer, record decision, reason, and trade-off. Distinguish clearly:
- **Given**: explicitly supplied by the user or source problem statement.
- **Decided**: chosen in discovery.
- **Assumed**: pragmatic default, not confirmed.
- **Unresolved**: a material ambiguity requiring later confirmation.

Prefer a thin vertical slice that can compile, run, and be demonstrated. Exclude optional login, analytics, notifications, advanced deployment, scalability infrastructure, etc. unless requested.

## Create exactly three project artifacts

Unless the user explicitly asks for chat-only output, create these **relative to the active project root** (create parent directories as needed):

1. `docs/discovery/project-brief.md` — **at most 400 words**; use headings: Problem, Users and goal, MVP scope, Requirements / acceptance criteria, Domain model, Decisions and trade-offs, Assumptions and unresolved, Out of scope. Retain any requirements IDs from the prompt; otherwise assign small stable `FR-01` IDs. Include 2–5 concrete, externally testable acceptance scenarios. Avoid promising unspecified production guarantees.
2. `docs/discovery/constitution-prompt.md` — a **ready-to-paste Codex message** starting with `$speckit-constitution`. Include project-wide, durable principles only: architecture simplicity, correctness, quality, testing, input validation, error handling, security appropriate to scope, and stack constraints where enduring. Carry over relevant Java 25 language-feature preferences, explicitly require Spring Boot-managed virtual threads by default (`spring.threads.virtual.enabled=true`) for Java 25 Spring Boot applications, and include the preference for high-level Spring/database-managed concurrency when concurrency is required. Explain that virtual threads are an execution model, not a substitute for database concurrency controls; never mandate every other language feature in every project. Reference `docs/discovery/project-brief.md`. State: *Do not add feature requirements to the constitution.* Keep it concise.
3. `docs/discovery/specify-prompt.md` — a **ready-to-paste Codex message** starting with `$speckit-specify`. Describe what and why, target users, functional requirements and acceptance scenarios, edge cases, exclusions, and sources of truth. Keep implementation mechanisms, Java language-feature preferences, and transaction/locking decisions out of the functional specification. Reference `docs/discovery/project-brief.md`. Request that ambiguities be flagged rather than silently filled. **Do not prescribe Spring classes, database tables, or frameworks here**; the plan stage handles how.

Never overwrite user-authored files silently: if existing output files contain user changes, preserve them and use an alternate filename or ask only if necessary. Do not invent or modify existing requirements. If files cannot be written, provide their full contents in the response with paths.

## Final response — concise handoff

After artifacts are created, show:
- 2–4 sentences summarizing the MVP, decisions, and important assumptions.
- The three artifact paths.
- The immediate next action: paste `docs/discovery/constitution-prompt.md` into Codex; review constitution, then paste `docs/discovery/specify-prompt.md`; continue with `$speckit-plan`, `$speckit-tasks`, `$speckit-implement`, and run tests. Only suggest `$speckit-clarify` if a critical ambiguity survives.

Do not restart questions automatically after creating artifacts. Only resume discovery on explicit user request. Do not claim the app is implemented or validated.
