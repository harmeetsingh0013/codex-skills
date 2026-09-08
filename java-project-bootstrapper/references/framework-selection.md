# Framework selection

## Purpose

Select an application framework only after checking current compatibility with the selected Java LTS and Gradle.

Initial framework matrix:

| Application | Options |
|---|---|
| Web | Spring Boot, Quarkus, Helidon |
| CLI | Framework-free Java, Picocli when appropriate |
| Desktop | JavaFX when verified compatible |

This list is extensible. Do not present an option whose current compatibility cannot be verified.

## Web decision rules

### Spring Boot
Use official Spring Boot system requirements and release documentation.

Prefer the Spring Boot BOM/dependency management for managed dependencies.

Verify:
- Java range;
- Gradle version range;
- plugin compatibility;
- packaging support;
- native-image support if native is requested.

### Quarkus
Use official Quarkus platform/release documentation.

Prefer the Quarkus platform/BOM.

Verify:
- Java range;
- Gradle plugin/platform compatibility;
- native support;
- test tooling.

### Helidon
Use official Helidon documentation/releases.

Verify:
- minimum/recommended Java;
- Gradle compatibility;
- web/security modules;
- native support if requested.

## CLI

Prefer framework-free Java for very small local CLI programs.

Use Picocli when:
- command parsing is non-trivial;
- subcommands/options are useful;
- the user explicitly wants a CLI framework.

Do not add a framework without a reason.

## Desktop

Use JavaFX only after verifying compatibility with the selected JDK.

Keep the first example small:
- input;
- action;
- in-memory result/list.

## Packaging selection

Calculate valid choices from:
- application type;
- framework;
- selected Java LTS;
- framework support;
- native-image availability.

Do not offer native when compatibility is unverified.

## Source priority

Use, in order:
1. official framework documentation;
2. official release notes;
3. official repository/release page;
4. official Gradle/Maven metadata when necessary.

Community posts can help locate information but should not be the sole evidence for compatibility decisions.
