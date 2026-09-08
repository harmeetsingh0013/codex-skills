# Project templates

## Baseline layout

```text
project/
├── .github/
│   └── workflows/
│       └── ci.yml
├── docs/
│   └── runbook.md
├── gradle/
│   ├── libs.versions.toml
│   └── wrapper/
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   ├── test/
│   │   └── java/
│   ├── integrationTest/
│   │   └── java/
│   └── e2eTest/
│       └── java/
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── gradlew
├── gradlew.bat
├── README.md
├── .gitignore
└── ...
```

Only create `integrationTest` and `e2eTest` source sets when needed.

## Web architecture

```text
Security
   ↓
REST Controller/Resource
   ↓
Application Service
   ↓
In-memory Repository/Store
```

Keep the example small.

## CLI architecture

```text
CLI Command
   ↓
Application Service
   ↓
In-memory Store
```

## Desktop architecture

```text
UI
   ↓
Application Service
   ↓
In-memory Store
```

## Todo example

Minimal capability:
- authenticate for REST;
- add one Todo item;
- return/display the added item.

Do not implement:
- database;
- full CRUD;
- pagination;
- search;
- user registration;
- refresh tokens;
- unrelated domain features.

## Quality tasks

Expose predictable tasks such as:

```text
./gradlew test
./gradlew integrationTest
./gradlew e2eTest
./gradlew quality
./gradlew build
```

Only expose `e2eTest` when Playwright is enabled.

## Documentation

README should provide a quick start.

Runbook should provide operational detail and troubleshooting.

## CI

CI should reproduce the important local validation steps.

Do not add deployment infrastructure unless requested.
