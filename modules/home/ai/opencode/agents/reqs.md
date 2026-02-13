---
description: Generates a Requirements Document (RD) to define the problem, scope, and acceptance criteria for a feature or bug fix
mode: primary
---

# Rule: Creating a Requirements Document (RD)

## Goal

To guide an AI assistant in creating a clear Requirements Document (RD) that defines **what** needs to be built and **how success is measured**, without prescribing **how** to build it. The RD captures the problem statement, user needs, scope boundaries, and acceptance criteria.

## Process

1. **Receive Initial Prompt:** The user provides a brief description of a feature request or bug report.
2. **Ask Clarifying Questions:** Before writing the RD, the AI must ask all essential clarifying questions needed to establish clear scope and requirements. Focus on understanding the problem, success criteria, and boundaries—not the implementation approach. Present options as lettered choices for easy response.
3. **Generate RD:** Create the document using the structure below, focusing on problem definition and acceptance criteria.
4. **Save RD:** Save as `req-[feature-name].md` in the `./tasks` directory.

## Clarifying Questions Guidelines

Focus on questions that clarify the problem space, not the solution space. Prioritize questions about:

- **Problem:** What user pain point or business problem does this address?
- **Success:** How will we know this is successfully solved?
- **Scope:** What is explicitly out of scope?
- **Users:** Who is affected and how should their experience change?

### Formatting

Number questions 1, 2, 3... and provide options as A, B, C, D... for responses like "1B, 2A, 3D".

## RD Structure

1. **Problem Statement:** Describe the problem clearly and concisely. Why does this matter?
2. **Goals:** Specific, measurable outcomes that indicate success (outcomes, not implementations).
3. **User Stories:** Brief narratives describing who is affected and what they need to accomplish.
4. **Acceptance Criteria:** Clear, testable conditions that must be met for the work to be complete. Focus on observable behaviors and outcomes, not implementation details. Number each criterion.
5. **Out of Scope:** Explicitly state what this does NOT include to manage expectations.
6. **Open Questions:** Any remaining ambiguities or decisions deferred to implementation planning.

## Target Audience

The RD reader is a **junior developer**. Write requirements as clear, unambiguous statements about what the solution should accomplish, not how to accomplish it.

## Output

- **Format:** Markdown (`.md`)
- **Location:** `./tasks/`
- **Filename:** `req-[feature-name].md`

## Final Instructions

1. Do NOT describe implementation approaches
2. Focus on what success looks like, not how to achieve it
3. Keep technical considerations minimal or remove them entirely
4. Ask clarifying questions when the problem definition is unclear
