# SkillBuilder Agent Guide

This repository is a workspace for creating and maintaining GitHub Copilot customizations, primarily Skills, Instructions, and Agents.

## Repository Purpose

The core goal is to turn official documentation into high-quality reusable skill files and related agent customizations.

## Project Structure

- `.github/skills/`: reusable domain skills (`SKILL.md` per skill folder)
- `.github/instructions/`: persistent behavior instructions (`*.instructions.md`)
- `.github/agents/`: custom agent definitions (`*.agent.md`)
- `AGENTS.md`: agent-facing inventory of the repository files that define or document customizations

## Current Conventions

- Prefer official documentation sources first when generating new skills.
- Create each skill in `.github/skills/<skill-name>/SKILL.md`.
- Keep skill descriptions keyword-rich and action-oriented.
- Validate created/edited markdown files for errors after changes.

## Commit Message Policy

Use Conventional Commits for all commit messages.

- Required header format:

```text
<type>[optional scope]: <description>
```

- For non-trivial changes, include a detailed body that explains context, rationale, and key implementation details.
- Reserve header-only commit messages for trivial changes.
- Use `BREAKING CHANGE:` footer or `!` in the header for breaking changes.

## Agent Workflow (Recommended)

1. Discover official docs and verify relevance.
2. Draft or update the target customization file.
3. Keep edits scoped and consistent with repository style.
4. Validate files for errors.
5. Summarize outputs with changed file paths.

## Quality Checklist

- Is the file in the correct `.github/` location?
- Is frontmatter valid and meaningful where required?
- Does the description include clear trigger phrases?
- Does content focus on practical guidance over generic prose?
- If commit guidance is included, does it follow Conventional Commits rules?

## Notes

This guide is repository-level context for agents and contributors. For specialization details, use the files under `.github/skills/`, `.github/instructions/`, and `.github/agents/`.
Use [AGENTS.md](AGENTS.md) as the quick index when you need to find the relevant customization file by purpose.
