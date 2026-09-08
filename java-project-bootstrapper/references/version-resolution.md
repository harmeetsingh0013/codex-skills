# Version resolution

## Principle

"Latest" means:

> newest stable release whose compatibility is verified for the complete selected stack.

Never select versions independently when a platform/BOM manages them.

## Resolution order

1. Determine current Java LTS releases from authoritative Java/OpenJDK sources.
2. Reject Java versions below 21 or non-LTS versions.
3. Select a Gradle version that can run on the selected Java version and supports the required framework/plugin.
4. Select the newest stable compatible framework version.
5. Resolve framework BOM/platform-managed dependencies.
6. Resolve independent libraries such as JUnit/Mockito only after checking Java/framework compatibility.
7. Resolve PMD, Checkstyle, SpotBugs plugin/engine, formatter, coverage, Playwright, and packaging tools.
8. Verify the final dependency graph.
9. Pin the result.

## Stability filter

Reject:
- SNAPSHOT;
- alpha;
- beta;
- milestone;
- RC;
- nightly;
- dev builds.

Exception: only use a prerelease when the user explicitly asks for it.

## Evidence

For each important version, record:
- component;
- selected version;
- why it was selected;
- Java compatibility evidence;
- framework compatibility evidence;
- Gradle compatibility evidence;
- authoritative source.

The final user-facing response should summarize the decisions without pretending that unverified compatibility is verified.

## Framework BOMs

If a framework provides a BOM/platform:
- use it;
- allow it to control managed dependency versions;
- do not override managed versions merely because a newer transitive release exists.

## Reproducibility

Prefer:
- version catalog;
- dependency locking;
- dependency verification.

Never use:
- `1.+`;
- `latest.release`;
- unbounded snapshots.

## Current-information rule

Do not encode today's framework versions permanently into this skill.

This skill is designed to remain valid as the ecosystem changes.

At generation time, use current official sources and package metadata to resolve versions.
