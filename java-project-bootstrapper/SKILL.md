---
name: java-project-bootstrapper
description: Create and validate production-quality Java projects using a selected Java LTS version (21+), Gradle Kotlin DSL, a compatible framework, tests, security, code-quality tooling, packaging, documentation, and GitHub Actions. Use when the user asks to bootstrap, scaffold, initialize, or create a new Java CLI, desktop, or web project.
---

# Java Project Bootstrapper

## Mission

Create a complete, buildable, testable Java project from user requirements.

The user's explicit requirements take precedence over this skill. Never invent current versions, compatibility, framework capabilities, APIs, commands, release status, or security behavior.

For current ecosystem facts, use authoritative sources and verify them at generation time. Prefer:
- OpenJDK/Oracle Java documentation
- official framework documentation/release notes
- Gradle documentation and Plugin Portal
- Maven Central
- official GitHub repositories/releases
- official Playwright documentation
- official GitHub Actions documentation

This skill is an orchestration workflow. Detailed rules live in:
- `references/framework-selection.md`
- `references/version-resolution.md`
- `references/security.md`
- `references/project-templates.md`

Use those references when their topic is relevant.

## Hard requirements

Do not generate the project until the user has supplied:
1. Application/project name
2. Application/project description

If either is missing, ask for it and stop project generation.

The selected Java version must:
- be an LTS release;
- be >= 21;
- be verified from an authoritative Java source.

The project must use:
- Gradle Wrapper;
- Gradle Kotlin DSL;
- Java Toolchains;
- Maven Central unless a documented exception is required.

The generated project must include, as applicable:
- JUnit;
- Mockito;
- PMD;
- Checkstyle using Google's official Java convention configuration;
- SpotBugs;
- unit tests;
- integration tests;
- optional Playwright Java E2E tests;
- README.md;
- `docs/runbook.md`;
- GitHub Actions CI;
- the selected packaging/build type.

Generated example code, unit tests, and integration tests must not use deprecated APIs. Prefer current supported replacements, even when the deprecated form would be shorter or easier to scaffold. If a requested example would require a deprecated API, use a non-deprecated alternative or explain that the requested combination is incompatible.

For web/REST applications, the example must include a security layer with JWT authentication and protected REST endpoints. Follow `references/security.md`.

No database is required for the example. Use in-memory collections such as `List`, `Map`, or thread-safe `ConcurrentMap`/`ConcurrentHashMap` as appropriate.

## Interaction flow

Collect only information not already supplied.

Recommended order:
1. project name;
2. project description;
3. Java LTS version;
4. application type: CLI, desktop, or web;
5. framework, when applicable;
6. minimal example/use case, unless already provided;
7. packaging/build type;
8. Playwright E2E yes/no.

Do not ask questions whose answers are already explicit in the user's request.

Before generating files, present a concise resolved plan containing:
- Java version;
- Gradle version;
- framework/version;
- major dependency/tool versions;
- packaging type;
- test strategy;
- security strategy;
- important compatibility decisions.

If a required combination cannot be verified, do not guess. Explain the incompatibility and offer a compatible alternative.

## Version-resolution policy

Never interpret "latest" as "highest number found."

Resolve:

latest stable
→ Java-compatible
→ framework-compatible
→ Gradle-compatible
→ dependency/BOM-compatible
→ packaging-compatible
→ selected version

Exclude alpha, beta, milestone, RC, snapshot, nightly, and other prereleases unless the user explicitly asks for them.

Prefer framework BOM/platform dependency management. Do not independently override versions managed by a framework BOM unless there is a documented reason.

Pin the resolved versions in the generated project. Prefer Gradle version catalogs and dependency locking for reproducibility.

Consult `references/version-resolution.md`.

## Application types

### Web

Offer verified framework choices. Initially support:
- Spring Boot
- Quarkus
- Helidon

Only offer a framework if current compatibility with the selected Java LTS can be established.

For REST examples:
- implement a minimal vertical slice;
- include JWT security;
- expose a protected REST endpoint;
- use in-memory storage;
- include unit and integration tests;
- add Playwright E2E if selected.

Example Todo flow:
- `POST /api/auth/login`
- `POST /api/todos` with `Authorization: Bearer <JWT>`

Do not add a database.

### CLI

Support a framework-free option and a verified CLI framework such as Picocli when appropriate.

For a Todo example, provide a command conceptually equivalent to:
`todo add "Buy milk"`

Use in-memory storage. If the CLI communicates with a remote secured API, use the API's authentication mechanism. Do not add JWT to a purely local CLI just to satisfy a checklist.

### Desktop

Support verified Java desktop technologies such as JavaFX when compatible with the selected JDK.

For a local-only example, do not introduce remote authentication. If the desktop application calls a secured REST backend, implement the appropriate authentication flow.

## Minimal example policy

Generate only a small, working vertical slice.

For a Todo example, "add item" is enough.

Do not add:
- databases;
- ORM;
- messaging;
- microservices;
- unnecessary abstractions;
- full CRUD;
- unrelated features.

Prefer:
`Security → API/UI/CLI → application service → in-memory store`

For web applications, use thread-safe in-memory storage when concurrent requests are possible.

## Security

For REST/web applications, JWT security is mandatory.

Use the selected framework's supported security facilities rather than writing custom JWT parsing or cryptography.

Security must include:
- signature validation;
- expiration validation;
- malformed-token rejection;
- authentication on protected endpoints;
- authorization when roles are used;
- password hashing for local demo credentials;
- no plaintext passwords;
- no hard-coded production secrets;
- security-focused integration tests.

Use environment/configuration for secrets and keys.

The example may use an in-memory user store. It must not require a database.

Consult `references/security.md`.

## Testing

Create separate test categories where useful:
- `src/test/java` for unit tests;
- `src/integrationTest/java` for integration tests;
- `src/e2eTest/java` for Playwright E2E tests when selected.

Provide separate Gradle tasks:
- `test`
- `integrationTest`
- `e2eTest` when enabled.

Integration tests must exercise the real application boundary and security behavior, not merely assert that configuration loads.
Treat deprecation warnings in generated application code, unit tests, and integration tests as defects. Fix them before declaring the project complete unless the user explicitly requested a legacy API example and no supported alternative exists.

When Playwright is selected, add at least one meaningful happy-path E2E test and, for web applications, one useful negative security scenario where practical.

## Code quality

Include:
- JUnit;
- Mockito;
- PMD;
- Checkstyle;
- SpotBugs.

Use the official Google Checkstyle configuration appropriate to the selected Checkstyle release.

Create a convenient `quality` task that runs the relevant static-analysis checks and tests as appropriate.

Also consider:
- Spotless or another formatter;
- JaCoCo;
- dependency verification;
- dependency locking;
- Dependabot or Renovate.

Do not add unnecessary tools merely to satisfy a checklist; document each selected tool.

Reports should live under predictable `build/reports/` paths.
Do not leave deprecated API usage in generated source, tests, or examples merely because the build still passes. If a compiler or static-analysis warning reveals a deprecated API in any generated code path, revise the code until the warning is gone.

## Packaging

Offer only packaging types supported by the selected stack.

Typical choices:
- executable/JVM artifact;
- Docker;
- native.

Native is conditional. Verify native-image/framework/JDK support before offering it.

For Docker:
- use a suitable runtime image;
- prefer a multi-stage build when useful;
- avoid root execution where practical;
- do not bake secrets into the image.

For native:
- use the framework's supported native-image tooling;
- verify the build before declaring success.

## Gradle

Always generate:
- `gradlew`;
- `gradlew.bat`;
- `gradle/wrapper/...`;
- `build.gradle.kts`;
- `settings.gradle.kts`.

Use Java Toolchains.

Use `gradle/libs.versions.toml` when appropriate.

Avoid dynamic versions such as:
- `1.+`;
- `latest.release`;
- snapshots.

Prefer dependency locking and verification where practical.

## Documentation

Generate `README.md` containing:
- name;
- description;
- technology stack;
- prerequisites;
- local setup;
- run instructions;
- test commands;
- quality commands;
- report locations;
- security/authentication instructions;
- API/CLI examples;
- packaging instructions.

Generate `docs/runbook.md` containing:
- prerequisites;
- environment setup;
- running locally;
- unit tests;
- integration tests;
- E2E tests;
- quality checks;
- report locations;
- build/package commands;
- Docker/native instructions;
- CI instructions;
- common failures;
- troubleshooting;
- dependency upgrade procedure;
- security configuration.

## GitHub Actions

Generate `.github/workflows/ci.yml`.

CI should:
1. checkout;
2. install the selected JDK;
3. use the Gradle Wrapper;
4. configure caching appropriately;
5. run unit tests;
6. run integration tests;
7. run E2E tests when enabled;
8. run Checkstyle, PMD, SpotBugs;
9. build/package;
10. upload useful test/quality artifacts.

For Docker/native packaging, add the appropriate validation job.

Do not invent deployment infrastructure or secrets. CD/release workflows are optional and should be added only when requested or clearly required.

## Validation

Do not declare success merely because files were generated.

Run, as applicable:
- `./gradlew clean build`
- `./gradlew test`
- `./gradlew integrationTest`
- `./gradlew e2eTest`
- `./gradlew quality`
- selected packaging commands.

For Docker, validate the image build. For native, validate the native build.

If validation fails:
1. inspect the error;
2. fix generated code/configuration;
3. rerun the failing validation;
4. continue until successful or until an external/environmental blocker is clearly identified.

## Final response

After generation, report:
- project location;
- selected Java/framework/Gradle versions;
- test strategy;
- security approach;
- packaging type;
- commands used for validation;
- any external/environmental limitations.

Never claim a command was run if it was not actually run.

## Supporting files

Read:
- `references/framework-selection.md` when choosing application/framework/packaging combinations;
- `references/version-resolution.md` when resolving versions;
- `references/security.md` for web security and JWT;
- `references/project-templates.md` when deciding project layout.

Use scripts only for deterministic local assistance. They are not a substitute for current official documentation.
