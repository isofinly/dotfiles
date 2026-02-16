## General best practices

- Run shell scripts through shellcheck.

### SESSION.md

While working, if you come across any bugs, missing features, or other oddities about the implementation, structure, or workflow, **add a concise description of them to SESSION.md** to defer solving such incidental tasks until later. You do not need to fix them all straight away unless they block your progress; writing them down is often sufficient. **Do not write your accomplishments into this file.**

## Git workflow

Make sure you use git mv to move any files that are already checked into git.

When writing commit messages, ensure that you explain any non-obvious trade-offs we've made in the design or implementation.

Wrap any prose (but not code) in the commit message to match git commit conventions, including the title. Also, follow semantic commit conventions for the commit title.

When you refer to types or very short code snippets, place them in backticks. When you have a full line of code or more than one line of code, put them in indented code blocks.

Prefer to write git commit messages by using a temporary file rather than using command-line arguments to the `git` command. Remove the temporary file afterwards.

## Documentation preferences

### Documentation examples

- Use realistic names for types and variables.

## Code style preferences

Document when you have intentionally omitted code that the reader might otherwise expect to be present.

Add TODO comments for features or nuances that were deemed not important to add, support, or implement right away.

### Literate Programming

Apply literate programming principles to make code self-documenting and maintainable across all languages:

#### Core Principles

1. **Explain the Why, Not Just the What**: Focus on business logic, design decisions, and reasoning rather than describing what the code is doing.
2. **Top-Down Narrative Flow**: Structure code to read like a story with clear sections that build logically:
   ```rust
   // =========================================================================
   // Plugin Configuration Extraction
   // =========================================================================

   // First, we extract plugin metadata from Cargo.toml to determine
   // what files we need to build and where to put them.
   ```
3. **Inline Context**: Place explanatory comments immediately before relevant code blocks, explaining the purpose and any important context.
   ```python
   # Convert timestamps to UTC for consistent comparison across time zones.
   # This prevents edge cases where local time changes affect rebuild detection.
   utc_timestamp = datetime.utcfromtimestamp(file_stat.st_mtime)
   ```
4. **Avoid Over-Abstraction**: Prefer clear, well-documented inline code over excessive function decomposition when logic is sequential.
5. **Self-Contained When Practical**: Reduce dependencies on external shared utilities when the logic is straightforward enough to inline.

#### Implementation Benefits

- **Maintainability**: Future developers can quickly understand both implementation and design rationale
- **Debugging**: When code fails, documentation helps identify which logical step failed and why
- **Knowledge Transfer**: Code serves as documentation of the problem domain, not just the solution
- **Reduced Cognitive Load**: Readers don't need to mentally reconstruct the author's reasoning

#### When to Apply

Use literate programming for:
- Complex algorithms with multiple phases or decision points
- Code implementing business logic rather than simple plumbing
- Code where the "why" is not immediately obvious from the "what"
- Integration points between systems where context matters

Avoid over-documenting:
- Simple utility functions where intent is clear from the signature
- Trivial getters/setters or obvious wrapper code
- Code that's primarily syntactic sugar over well-known patterns

# Common failure modes when helping

## The XY Problem

The XY problem occurs when someone asks about their attempted solution (Y) instead of their actual underlying problem (X).

### The Pattern

1. User wants to accomplish goal X
2. User thinks Y is the best approach to solve X
3. User asks specifically about Y, not X
4. Helper becomes confused by the odd/narrow request
5. Time is wasted on suboptimal solutions

### Warning Signs to Watch For

- Focus on a specific technical method without explaining why
- Resistance to providing broader context when asked
- Rejecting alternative approaches outright
- Questions that seem oddly narrow or convoluted
- "How do I get the last 3 characters of a filename?" (when they want file extension)

### How to Avoid It (As Helper)

- **Ask probing questions**: "What are you trying to accomplish overall?"
- **Request context**: "Can you explain the bigger picture?"
- **Challenge assumptions**: "Why do you think this approach will work?"
- **Offer alternatives**: "Have you considered...?"

### Red Flags in User Requests

- Very specific technical questions without motivation
- Unusual or roundabout approaches to common problems
- Dismissal of "why do you want to do that?" questions
- Focus on implementation details before problem definition

### Key Principle

Always try to understand the fundamental problem (X) before helping with the proposed solution (Y). The user's approach may not be optimal.

## Design goals

The design goals focus on building software that is safe, fast, and easy to maintain.

### Control and limits

Predictable control flow and bounded system resources are essential for safe execution.

- Simple and explicit control flow: Favor straightforward control structures over complex logic. Simple control flow makes code easier to understand and reduces the risk of bugs. Avoid recursion if possible to keep execution bounded and predictable, preventing stack overflows and uncontrolled resource use.

- Set fixed limits: Set explicit upper bounds on loops, queues, and other data structures. Fixed limits prevent infinite loops and uncontrolled resource use, following the fail-fast principle. This approach helps catch issues early and keeps the system stable.

### Memory and types

Clear and consistent handling of memory and types is key to writing safe, portable code

- Minimize variable scope: Declare variables in the smallest possible scope. Limiting scope reduces the risk of unintended interactions and misuse. It also makes the code more readable and easier to maintain by keeping variables within their relevant context.

### Error handling

Correct error handling keeps the system robust and reliable in all conditions.

- Use assertions: Use assertions to verify that conditions hold true at specific points in the code. Assertions work as internal checks, increase robustness, and simplify debugging.
  - Assert function arguments and return values: Check that functions receive and return expected values.
  - Validate invariants: Keep critical conditions stable by asserting invariants during execution.
  - Use pair assertions: Check critical data at multiple points to catch inconsistencies early.
  - Fail fast on programmer errors: Detect unexpected conditions immediately, stopping faulty code from continuing.

- Handle all errors: Check and handle every error. Ignoring errors can lead to undefined behavior, security issues, or crashes. Write thorough tests for error-handling code to make sure your application works correctly in all cases.

### Design for performance

Early design decisions have a significant impact on performance. Thoughtful planning helps avoid bottlenecks later.

- Design for performance early: Consider performance during the initial design phase. Early architectural decisions have a big impact on overall performance, and planning ahead ensures you can avoid bottlenecks and improve resource efficiency.

- Napkin math: Use quick, back-of-the-envelope calculations to estimate system performance and resource costs. For example, estimate how long it takes to read 1 GB of data from memory or what the expected storage cost will be for logging 100,000 requests per second. This helps set practical expectations early and identify potential bottlenecks before they occur.

- Batch operations: Amortize expensive operations by processing multiple items together. Batching reduces overhead per item, increases throughput, and is especially useful for I/O-bound operations.

### Efficient resource use

Focus on optimizing the slowest resources, typically in this order:

- Network: Optimize data transfer and reduce latency.
- Disk: Improve I/O operations and manage storage efficiently.
- Memory: Use memory effectively to prevent leaks and overuse.
- CPU: Increase computational efficiency and reduce processing time.

### Developer experience

- Include units or qualifiers in names: Append units or qualifiers to variable names, placing them in descending order of significance (e.g., latency_ms_max instead of max_latency_ms). This clears up meaning, avoids confusion, and ensures related variables, like latency_ms_min, line up logically and group together.

- Document the 'why': Use comments to explain why decisions were made, not just what the code does. Knowing the intent helps others maintain and extend the code properly. Give context for complex algorithms, unusual approaches, or key constraints.

## Facts

- Every project has its own `flake.nix`.
- System packages are managed by flake as well. Here's list (it is not exhaustive) of globally availble tools (beyond basic macOS):
  - duckdb
  - python
  - gnumake
  - pkg-config
  - libtool
  - ripgrep
  - fzf
  - git
  - git-cliff
  - gh
  - nmap
  - p7zip
  - unrar
  - jq
  - yq
  - coreutils
  - findutils
  - gnused
  - gnugrep
  - gawk
  - killall
- Every feature, change or anything that is beyond several simple LoC change must be done in its own git branch.
- Use availble linting tools before committing. You are not allowed to disable lints without user approval.

