# Security requirements

## Scope

Security is mandatory for REST/web examples.

JWT is the default authentication mechanism for REST APIs.

Do not force JWT onto purely local CLI or desktop applications that have no remote security boundary.

## REST security architecture

Preferred flow:

Client
→ Bearer JWT
→ framework security middleware
→ authentication
→ authorization
→ REST endpoint
→ application service
→ in-memory store

Use the selected framework's supported security implementation:
- Spring Boot → Spring Security
- Quarkus → Quarkus Security
- Helidon → Helidon Security

Do not write custom JWT parsing or cryptographic primitives when the framework provides supported facilities.

## JWT validation

Validate:
- signature;
- expiration;
- relevant standard claims;
- token structure;
- authentication state;
- authorization rules where used.

Reject:
- malformed tokens;
- invalid signatures;
- expired tokens;
- missing authentication for protected endpoints.

Do not log bearer tokens.

## Credentials

For a local demo:
- keep users in memory;
- store password hashes, never plaintext passwords;
- use a framework-supported password hashing mechanism;
- make demo credentials obvious and replaceable.

Never hard-code production secrets.

Use environment variables/configuration for signing keys or secrets.

Prefer asymmetric signing where supported and appropriate.

## Minimal endpoint model

A web Todo example may expose:

POST /api/auth/login

POST /api/todos
Authorization: Bearer <JWT>

The Todo endpoint must be protected.

Do not implement a complete IAM system unless requested.

## In-memory data

Use:
- `Map`;
- `List`;
- `ConcurrentMap`;
- `ConcurrentHashMap`.

For web applications, prefer thread-safe collections when concurrent access is possible.

No database is required.

Document that in-memory data disappears on restart.

## Security tests

Integration tests must cover:
1. successful authentication;
2. unauthenticated protected request → 401;
3. malformed JWT → 401;
4. expired JWT → 401;
5. valid JWT → success;
6. authorization failure where roles exist.

If Playwright is enabled, add an authenticated happy path and, where practical, an unauthenticated negative scenario.

## Production disclaimer

The generated example demonstrates the security boundary. It is not automatically a production identity-management solution.

For production, document that teams should consider:
- external identity providers;
- key rotation;
- secret management;
- refresh-token strategy;
- account lifecycle;
- audit logging;
- rate limiting;
- CSRF considerations where applicable;
- threat modeling.
