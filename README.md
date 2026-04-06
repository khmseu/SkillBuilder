# SkillBuilder

SkillBuilder is a repository for creating and maintaining GitHub Copilot customizations, with a focus on reusable skills generated from official documentation.

## Purpose

This repo is used to:
- turn official product and library documentation into reusable `.github/skills/*/SKILL.md` files
- store persistent instruction files that shape agent behavior for this workspace
- maintain custom agents for documentation-driven and workflow-specific tasks

## Repository Layout

- `.github/skills/`: reusable skills, one skill per folder
- `.github/instructions/`: repository instructions and persistent behavior rules
- `.github/agents/`: custom agents for specialized workflows
- `agent.md`: repository-level guidance for agents working in this repo

## Working Conventions

- Prefer official documentation sources first when creating or updating skills.
- Keep customization descriptions specific and keyword-rich so they are discoverable.
- Place each skill at `.github/skills/<skill-name>/SKILL.md`.
- Validate created or edited markdown files after changes.
- Keep changes scoped and consistent with the existing repository style.

## Commit Policy

This repository uses Conventional Commits.

- Header format:

```text
<type>[optional scope]: <description>
```

- Use detailed commit bodies for any non-trivial change.
- Reserve header-only commit messages for trivial changes.
- Mark breaking changes with `!` in the header and/or a `BREAKING CHANGE:` footer.

## Typical Workflow

1. Identify the official documentation source.
2. Draft or update the target skill, instruction, or agent file.
3. Keep the content practical and focused on reusable guidance.
4. Validate the file for markdown or frontmatter issues.
5. Summarize the resulting change clearly.

## Existing Customizations

This repository already contains:
- documentation-to-skill workflow support
- Conventional Commits skill and instructions
- Git and ecosystem-specific skills
- custom agents for docs-driven workflows

## Notes

Use `agent.md` for high-level repository guidance and the files under `.github/` for the concrete customizations themselves.
