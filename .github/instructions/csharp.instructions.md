applyTo: "**/*.cs"
---

# C# Copilot Instructions

## Development Conventions
- Use **UTF-8** encoding.
- Use **tab characters** (size 4) for indentation, not spaces.

## C# Custom Coding Guidelines
- Prefix all private fields with `_`.
- Avoid inline numeric literals (magic numbers). Use constants or enums.
- Avoid inline string literals. Use resources, constants, or configuration files.
- Prefer `StringBuilder` over string concatenation in loops or repeated operations.
- Never concatenate strings inside a loop.
- Do not compare strings with `""` or `string.Empty`; use `string.IsNullOrEmpty`.
- Avoid hidden string allocations in loops (e.g., prefer `string.Compare`).
- Do not use `try/catch` blocks for flow control.
- Never declare an empty `catch` block.
- Order exception filters from most to least derived.
- Always dispose `IDisposable` objects with `using`.
- Implement `IDisposable` properly for classes referencing external resources.
- Do not implement finalizers unless strictly required.
- Use meaningful names for variables in LINQ queries.
- Place `where` clauses before other LINQ clauses for efficiency.
- Avoid mutual references between assemblies.
- Utility classes should not have public constructors.
- Mark methods and properties that do not access instance data as `static`.
- Declare public members before private members.
- Place `readonly` fields beneath non-readonly fields.
- Use trailing commas in multi-line initializers.
- Declare static members before non-static members.
- Avoid using `Enumerable.Any()` extension method.
- Methods and properties that don't access instance data should be static
