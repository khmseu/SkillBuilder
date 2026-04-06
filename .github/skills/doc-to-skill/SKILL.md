---
name: doc-to-skill
description: "Convert documentation URLs into reusable skills. Analyzes library/framework documentation and generates a SKILL.md file with domain knowledge, best practices, and usage patterns. Use when: creating skills from docs, document framework, generate skill, skill from URL, library documentation skill"
---

# Documentation to Skill Generator

Creates reusable skills from library and framework documentation URLs.

## Workflow

This skill:
1. **Analyzes** the documentation at the provided URL
2. **Extracts** key patterns, best practices, and domain knowledge
3. **Generates** a SKILL.md file with:
   - Clear description of the skill's domain and trigger phrases
   - Key concepts and patterns to follow
   - Common pitfalls and how to avoid them
   - Best practices and conventions
   - Code examples when relevant
4. **Creates** the skill in `.github/skills/<skill-name>/SKILL.md`

## How to Use

Type the slash command and provide the documentation URL:

```
/doc-to-skill

Documentation URL: https://docs.example.com/library
Skill name (optional): my-library-skill
```

The skill will be automatically created and ready to use for future tasks involving that library/framework.

## What Gets Generated

The created skill includes:
- **Description**: Trigger phrases for automatic skill loading
- **Domain Focus**: Clear scope of what the skill covers
- **Best Practices**: Conventions and patterns to follow
- **Anti-Patterns**: Common mistakes and how to avoid them
- **Integration Notes**: How the skill works with other tools
- **Code Examples**: Practical usage patterns

## Example Skill Generated

For a documentation URL like `https://docs.astro.build/`:
- **Skill name**: `astro`
- **Location**: `.github/skills/astro/SKILL.md`
- **Trigger phrases**: "astro", "astro framework", "astro component", "build astro site"
- **Content**: Astro-specific best practices, component patterns, routing, data fetching, deployment

## Notes

- Works best with well-structured, comprehensive documentation
- API references are converted to usage patterns rather than literal API docs
- Creates skills focused on "how to use it well" rather than just "what it does"
- Skills are placed in `.github/skills/` automatically
