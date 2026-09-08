# Java Project Bootstrapper --- Codex Skill

A reusable Codex skill for bootstrapping Java projects with a verified,
compatible technology stack.

The skill supports Java LTS versions \>= 21, Gradle Kotlin DSL,
web/CLI/desktop applications, framework selection, testing, code
quality, JWT security for REST applications, packaging, documentation,
and GitHub Actions CI.

### 1. Download the skill

Download and extract the `java-project-bootstrapper.zip` archive.

After extraction, you should have:

``` text
java-project-bootstrapper/
├── SKILL.md
├── references/
│   ├── framework-selection.md
│   ├── version-resolution.md
│   ├── security.md
│   └── project-templates.md
└── scripts/
    ├── resolve-versions.sh
    └── validate-project.sh
```

### 2. Copy the skill into your user skills directory

On macOS/Linux:

``` bash
mkdir -p "$HOME/.agents/skills"
cp -R /path/to/java-project-bootstrapper "$HOME/.agents/skills/"
```

Replace `/path/to/java-project-bootstrapper` with the directory
containing the extracted skill.

For example:

``` bash
mkdir -p "$HOME/.agents/skills"
cp -R ~/Downloads/java-project-bootstrapper "$HOME/.agents/skills/"
```

The final location should be:

``` text
$HOME/.agents/skills/java-project-bootstrapper/
```

Verify it:

``` bash
ls -la "$HOME/.agents/skills/java-project-bootstrapper"
```

You should see `SKILL.md`, `references/`, and `scripts/`.

### 3. Restart Codex

Restart your Codex CLI session after installing the skill so that Codex
can discover the new skill.

### 4. Verify the skill

Inside Codex, use:

``` text
/skills
```

The `java-project-bootstrapper` skill should be listed.

You can explicitly invoke it with:

``` text
$java-project-bootstrapper
```

You can also ask Codex naturally for a matching task, for example:

``` text
Create a Java Todo REST API using the Java project bootstrapper.
```

Codex can automatically select a skill when the request matches the
skill's description.

## Example usage

A complete request can look like:

``` text
$java-project-bootstrapper

Create a Todo REST API.

Application name:
Todo API

Description:
A minimal REST API for managing todo items.

Use Java 25.

Use a web application.

Use Spring Boot.

The application should support adding a todo item.

Use Docker packaging.

Enable Playwright E2E tests.
```

The skill will resolve the compatible versions, generate the project,
add the required security and quality tooling, and validate the
generated project.

## Important behavior

### Project name and description are required

The skill will not create a project when either the application name or
description is missing.

### Java version

The selected Java version must:

-   be an LTS release;
-   be Java 21 or newer;
-   be verified against authoritative Java/OpenJDK information.

### Framework versions

The skill does not permanently hard-code framework versions.

Instead, it follows:

``` text
Latest stable
      ↓
Java compatible
      ↓
Framework compatible
      ↓
Gradle compatible
      ↓
Dependency/BOM compatible
      ↓
Packaging compatible
      ↓
Selected version
```

This allows the skill to remain useful as Java, Gradle, frameworks, and
dependencies evolve.

### REST security

Web/REST projects include JWT-based security.

The generated example can use:

-   an in-memory user store;
-   password hashing;
-   JWT authentication;
-   protected REST endpoints;
-   security integration tests.

No database is required.

### Testing

Generated projects can contain:

``` text
Unit tests
Integration tests
Playwright E2E tests (optional)
```

### Code quality

The skill includes:

-   JUnit
-   Mockito
-   PMD
-   Checkstyle
-   Google Java Checkstyle configuration
-   SpotBugs

Additional tools such as JaCoCo, Spotless, dependency verification, and
dependency update automation may be included when appropriate.

### CI

Generated projects include GitHub Actions CI with build, tests, quality
checks, and packaging appropriate to the selected project.

## User-level vs project-level installation

User-level installation:

``` text
$HOME/.agents/skills/java-project-bootstrapper/
```

makes the skill available to your Codex user environment.

If you instead want the skill to belong to a particular repository,
Codex also supports repository-local skills under:

``` text
<repository>/.agents/skills/java-project-bootstrapper/
```

A repository-local skill is useful when the skill is intended to be
version-controlled together with a specific project or team workflow.

## Updating the skill

To update an existing installation:

``` bash
rm -rf "$HOME/.agents/skills/java-project-bootstrapper"
cp -R /path/to/java-project-bootstrapper "$HOME/.agents/skills/"
```

Then restart Codex.

## Troubleshooting

### Skill does not appear in `/skills`

Check that the directory is exactly:

``` text
$HOME/.agents/skills/java-project-bootstrapper/
```

and that the directory contains:

``` text
SKILL.md
```

Check:

``` bash
find "$HOME/.agents/skills/java-project-bootstrapper" -maxdepth 2 -type f
```

Then restart Codex.

### Permission denied when running scripts

Make the scripts executable:

``` bash
chmod +x "$HOME/.agents/skills/java-project-bootstrapper/scripts/"*.sh
```

### The skill is available but not automatically selected

Explicitly invoke it:

``` text
$java-project-bootstrapper
```

You can also describe the task clearly, for example:

``` text
Bootstrap a new Java 25 Spring Boot REST project with JWT security, Gradle Kotlin DSL, SpotBugs, PMD, Checkstyle, unit tests, integration tests, and GitHub Actions.
```

## Official Codex documentation

For the latest Codex skill discovery and installation behavior, consult
the official OpenAI Codex documentation:

https://developers.openai.com/codex/build-skills
