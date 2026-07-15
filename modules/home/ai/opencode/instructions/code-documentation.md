# Code Comments and API Documentation

Default to no comment. Prefer clearer names, types, or structure.

Add one only to preserve a non-obvious, durable constraint whose absence could cause an incorrect change: an invariant, external limitation, necessary workaround, ordering requirement, or deliberate tradeoff.

Do not narrate code, restate names or requirements, explain ordinary behavior, label blocks, summarize changes, or record tickets and implementation history. Planning context belongs in planning artifacts, not source comments or documentation.

Write public API documentation for callers. Describe only what they need for correct use: purpose, non-obvious inputs and outputs, errors, side effects, lifecycle, ordering, ownership, concurrency, and useful examples. Omit private helpers, control flow, storage, and rationale unless callers must account for them. Documentation should survive private refactors that preserve behavior.

Never put ticket identifiers or issue links in shipped files unless they are required product data.
