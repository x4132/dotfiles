# Agent Guidelines

These preferences were distilled from my hand-written code and from what I consistently delete out of AI-generated code. Follow them in every project.

# Speaking Guidelines

- Traffic Lights: Red/Green/Yellow don't really mean anything to me. Telling me something is "Yellow" doesn't mean anything to me, and I want to know what's actually going on.

# Code Guidelines

## Primary Goal: don't generate what I'll delete

I remove "slop" from AI-generated code constantly. Never produce:

- **Wrappers that only forward.** A function/class whose body is a single call to another function does not exist - it's syntactic fluff, and especialy with agents, this isn't necessary. Call the real thing.
- **Helpers with one or two call sites.** Inline them where it's feasible. While I don't have a specific number at which to extract, I'd generally start extracting only at ~2-3+ callers, and duplicated _logic_ gets hoisted to one shared home. The goal is to centralize logic and sources of truth, not to minimize codebase size.
- **Speculative API surfaces** No subsystems, exports, config knobs, or "for future use" parameters that nothing consumes yet. Build what the current task needs, nothing more, nothing less.
- **Defensive fallbacks for impossible cases.** No `?? ""` on values that are validated upstream, no lenient parsing (code-fence stripping, truncation repair), no try/catch-log-continue. Trust declared types and fail loudly - bad code isn't something we should tolerate through leniency.
- **Docstrings that restate the signature.** `/** The pod currently holding this identity, or null if unassigned. */` is deletion fodder. Docstrings also generally don't need to restate the function or variable name, unless the documentation is more clear that way.
- **Single-implementation abstraction layers.** Don't make interfaces with only one implementation, Don't create unwieldy dependency injection seams "for testability" — do not distort production types for tests. Import collaborators directly; mock at the test-runner level (`node:test` `t.mock`) instead of injecting `fetcher: typeof fetch` style parameters. Don't forget that the purpose of tests is to validate code as is actually consumed, not a synthetic requirement to check off.
- **Barrel index.ts files.** Barrel files run the risk of circular imports and slows down & inflates builds. If a barrel exists, it's usually only for a library and gated to only objects that need to be exposed.
- **Compatibilty/migration paths kept "just in case."** When the last consumer of something dies, delete the whole thing in the same change — table, types, helpers, all of it. Be opinionated and remove what shouldn't be there.

## Comments

- Comments document current behavior, constraints, and rationale that can be verified from the current code or authoritative documentation. Never use comments as historical records, and never invent or require incidents, dates, measurements, or backstory.
- Write active, natural prose: name the actor with a normal noun phrase (i.e. write `The controlapi package ...`, not `Package controlapi ...`).
- Describe actions rather than classifying things. Say what the package, method, or block does (`NewServer constructs ...`; `Publish deliveries concurrently ...`), not what it is (`NewServer is ...`; `Deliveries are ...`). Use imperative phrasing for implementation instructions and active verbs for declaration comments.
- Do not repeat a declaration's name in its own JSDoc; the declaration already supplies that context. Write `/** Extracts ... */`, not `/** ActionIds extracts ... */`.
- State current behavior directly. Omit alternatives and prior implementations unless they constrain the code now.
- Keep comments accurate when the code changes; remove comments that are obsolete or wrong.
- JSDoc `/** */` on declarations; `//` only for implementation notes inside bodies.
- Don't gold-plate: no JSDoc on private fields or config files unless it adds useful context.

## Types & naming

- **Schema-first, value-derived types.** Define the zod schema (or equivalent) and derive the type; never hand-declare a type that a value can produce (`typeof x`, `z.infer`, `ReturnType`).
- **Declaration-merge schema and type under one PascalCase name**: `export const Pool = z.object(...); export type Pool = z.infer<typeof Pool>;` — no `…Type` suffixes, no lowercase schema consts.
- Validation and defaults live **in the schema or DB default**, not scattered through handlers as `input.x ?? env.DEFAULT` chains.
- Names should not carry redundant words and verbiage (`KameleoHandleConfig`, not `KameleoBrowserHandleConfig`). Keep positional args to a minimum - ideally under 7 args at most.
- `private readonly` over `#private` in classes (`{@link name}` resolves; `{@link #name}` doesn't, and we use typescript throughout so `#private` doesn't add any saftey).
- Model messy wire formats as real sum types / discriminated unions with validation at construction (newtype-style range checks welcome).

## Files & structure

- Place files by **what they are**, not by which module first imported them.
- Helper components/functions live below the main export in the same file until forced out.
- Split pure policy logic from I/O so that it is testable without a full end-to-end setup - but only its logic is non-trivial.

## Errors

- Catch only the exact case you can handle, with a one-line justification (`// Idempotent: a missing deployment means the delete already happened.`), and rethrow everything else.

## Tests

- Test where the failures could actually be real (tricky algorithms, seams, invariants), not just for coverage. One well-aimed test module beats scaffolded constructor tests.

## Commits & workflow

- Never commit unless asked. When asked: lowercase, terse, single-purpose messages that name the change or symptom ("bump valkey so they don't get OOMKilled"). No conventional-commit prefixes unless the repo already uses them.
- Fine-grained staging: renames separate from behavior, formatting separate from logic, migrations staged as reviewable steps ending with "delete the legacy path".

## Infra (Terraform/Terragrunt/Helm)

- Pin images to digests, not moving tags.
