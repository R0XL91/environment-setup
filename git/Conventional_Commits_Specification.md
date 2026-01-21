# Conventional Commits Specification

This document outlines the specification for Conventional Commits v1.0.0.

## Commit Message Format

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

## Summary

- The commit message **MUST** be structured as shown above.
- `type` **MUST** be a noun describing the nature of the change (e.g. `feat`, `fix`).
- An optional `scope` can be provided to clarify the area of the codebase affected.
- A `!` MAY be added before the colon to indicate a breaking change.
- The `description` **MUST** be a short summary of the change.
- The `body` and `footer` sections are optional, and separated by a blank line.
- A `BREAKING CHANGE:` footer or a `!` in the header indicates a breaking change.
- Commit messages **MUST NOT** be case sensitive, but `BREAKING CHANGE` **MUST** be in uppercase.

## Types (Common Examples)

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `build`: Changes that affect the build system or external dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files

## Breaking Changes

A breaking change **MUST** be indicated in one of the following ways:

- Adding `!` immediately before the `:` in the header
- Including a `BREAKING CHANGE:` section in the body or footer

### Example

```text
feat(auth)!: add OAuth2 login support

BREAKING CHANGE: OAuth2 replaces the old login method, which is no longer supported.
```

## Commit Checklist (Markdown Template)

```markdown
### Commit Checklist

- [ ] **Type**: Use a valid type (feat, fix, chore, etc.)
- [ ] **Scope** (optional): If included, is specific and lowercase
- [ ] **Description**: Concise summary of the change
- [ ] **Body** (optional): Additional context or motivation
- [ ] **Footer** (optional):
  - [ ] References (e.g., `Refs #123`)
  - [ ] Breaking changes (e.g., `BREAKING CHANGE: ...`)
- [ ] Breaking change flag (`!`) is used if applicable
```

---

For full details, see the official spec: [https://www.conventionalcommits.org/en/v1.0.0/](https://www.conventionalcommits.org/en/v1.0.0/)
