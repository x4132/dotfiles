# Personal code style (Alex / x4132)

These preferences were distilled from my hand-written code and from what I consistently delete out of AI-generated code. Follow them in every project unless a project CLAUDE.md overrides.

## The prime directive: don't generate what I'll delete

I remove "slop" from AI-generated code constantly. Never produce:

- **Wrappers that only forward.** A function/class whose body is a single call to another function does not exist. Call the real thing.
- **Helpers with one or two call sites.** Inline them. Extract only at ~3+ callers, and duplicated *logic* gets hoisted to one shared home — the rule is one home per concept, not fewer lines or more files.
- **Speculative surface.** No subsystems, exports, config knobs, or "for future use" parameters that nothing consumes yet. Build what the current task needs.
- **Defensive fallbacks for impossible cases.** No `?? ""` on values that are validated upstream, no lenient parsing (code-fence stripping, truncation repair), no try/catch-log-continue. Trust declared types; fail loudly at the boundary and nowhere else.
- **Docstrings that restate the signature.** `/** The pod currently holding this identity, or null if unassigned. */` is deletion fodder.
- **Single-implementation abstraction layers.** No interface + sole impl, no DI seam added "for testability" — do not distort production types for tests. Import collaborators directly; mock at the test-runner level (`node:test` `t.mock`) instead of injecting `fetcher: typeof fetch` style parameters.
- **Barrel index.ts files.** Explicit subpath exports or direct imports. If a barrel exists, it's gated: only cross-boundary shapes go in.
- **Compat/migration paths kept "just in case."** When the last consumer of something dies, delete the whole thing in the same change — table, types, helpers, all of it.

## Comments

- Comments document current behavior, constraints, and rationale that can be verified from the current code or authoritative documentation. Never use comments as historical records, and never invent or require incidents, dates, measurements, or backstory.
- Write active, natural prose: name the actor with a normal noun phrase (`The controlapi package ...`, not `Package controlapi ...`).
- Describe actions rather than classifying things. Say what the package, method, or block does (`NewServer constructs ...`; `Publish deliveries concurrently ...`), not what it is (`NewServer is ...`; `Deliveries are ...`). Use imperative phrasing for implementation instructions and active verbs for declaration comments.
- State current behavior directly. Omit alternatives and prior implementations unless they constrain the code now.
- Keep comments accurate when the code changes; remove comments that are obsolete or wrong.
- JSDoc `/** */` on declarations; `//` only for implementation notes inside bodies.
- Don't gold-plate: no JSDoc on private fields or config files unless it adds useful context.

## Documentation

- Document every function you add or materially change, including private functions and tests. Explain its current contract, policy, constraints, or non-obvious rationale without restating the signature.
- Give every new authored file a concise package- or file-level purpose statement where its format supports comments. For generated files, document the source schema or generator input and regenerate the output instead of editing generated documentation.
- Document the interface the actual consumer uses, not every technically exported symbol. An exported package API used only to assemble its own executable is an implementation detail, not a supported integration surface.
- Service READMEs describe how to run and operate the service: its command, configuration, endpoints, externally observable behavior, delivery guarantees, and deployment expectations.
- Keep internal wiring, callbacks, storage queries, and constructor sequences in code documentation unless the package is intentionally offered as a library for external integration.

## Types & naming

- **Schema-first, value-derived types.** Define the zod schema (or equivalent) and derive the type; never hand-declare a type that a value can produce (`typeof x`, `z.infer`, `ReturnType`).
- **Declaration-merge schema and type under one PascalCase name**: `export const PoolInsertSchema = ...; export type PoolInsertSchema = z.infer<typeof PoolInsertSchema>;` — no `…Type` suffixes, no lowercase schema consts.
- Validation and defaults live **in the schema or DB default**, not scattered through handlers as `input.x ?? env.DEFAULT` chains.
- Names carry no redundant words (`KameleoHandleConfig`, not `KameleoBrowserHandleConfig`). Prefer object-literal parameters over positional args.
- `private readonly` over `#private` in classes (`{@link name}` resolves; `{@link #name}` doesn't).
- Model messy wire formats as real sum types / discriminated unions with validation at construction (newtype-style range checks welcome).

## Files & structure

- Small, single-concern files, kebab-case. Place files by **what they are**, not by which module first imported them (host-selection is browser policy, not a router — it goes in `browser/`).
- Helper components/functions live below the main export in the same file until forced out.
- Split pure policy from I/O so the policy is testable without infra — but only when the policy is genuinely non-trivial.

## Errors

- Throw-based, typed, narrow: small custom error classes with `this.name` set, carrying the data the catcher needs. Retryability is data, not class hierarchy.
- Catch only the exact case you can handle, with a one-line justification (`// Idempotent: a missing deployment means the delete already happened.`), and rethrow everything else.
- Strict parsing: `parse`-and-throw at trust boundaries; `safeParse` only for genuinely hostile input.

## Tests

- `node:test` + `node:assert/strict`, hand-written fakes and `fixture()` factories — no mocking libraries, no vitest/jest.
- Test where the failure surface is real (tricky algorithms, seams, invariants), not for coverage. One well-aimed test module beats scaffolded constructor tests.
- Test names are behavioral sentences.

## Commits & workflow

- Never commit unless asked. When asked: lowercase, terse, single-purpose messages that name the change or symptom ("bump valkey so they don't get OOMKilled"). No conventional-commit prefixes unless the repo already uses them.
- Fine-grained staging: renames separate from behavior, formatting separate from logic, migrations staged as reviewable steps ending with "delete the legacy path".

## Infra (Terraform/Terragrunt/Helm)

- Pin images to digests, not moving tags.
