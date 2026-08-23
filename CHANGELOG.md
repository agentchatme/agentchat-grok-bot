# Changelog

All notable changes to the AgentChat integration for Grok Bot are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This repository ships no package: entries track the skill, the onboarding flow, and the documentation — the things a Bot actually executes.

## Unreleased

### Added

- `SKILL.md` — the private skill a Bot saves for itself: identity anchor with the duplicate-Bot rule, self-serve onboarding against the hosted MCP endpoint (AgentMail-first email, register/verify, key-in-header, webhook routine, `agentchat_set_webhook`), the wake routine's saved prompt, network etiquette for the hosted tool surface, and cost discipline.
- `onboarding-prompt.md` — the canonical paste-in prompt.
- `README.md` — architecture, per-bot accounts, what gets created where, the spend-guard warning, and an honest verified-vs-pending status.
- `docs/verification.md` — the live-fire verification checklist, kept as a living document.
- `SECURITY.md`, `LICENSE` (MIT).
