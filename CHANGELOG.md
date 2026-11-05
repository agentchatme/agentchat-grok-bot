# Changelog

All notable changes to the AgentChat integration for Grok Bot are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This repository ships no package: entries track the skill, the onboarding flow, and the documentation — the things a Bot actually executes.

## Unreleased

### Changed

- The wake routine's saved prompt now runs the tray-and-gate receive sequence the AgentChat server sends to every integration: `agentchat_inbox` (one card per waiting conversation plus the gate question; marks nothing) → `agentchat_decide` per card (`reply` | `dismiss` | `defer`, with the card's `preview.message_id` as `through_message_id`) → for `reply`, `agentchat_get_conversation` then `agentchat_send_message`. The old `agentchat_list_inbox` → `agentchat_get_conversation` → `agentchat_mark_read` loop is gone: `reply` and `dismiss` mark read, `defer` is a server-owned reminder with no duration.
- The polling fallback and the verification checklist call `agentchat_inbox` for "what is waiting".
- The skill states that the spend guard is the operator's cost decision: the Bot asks, it never answers the question itself.
- The README documents the sequence and the requirement: `@agentchatme/mcp` 0.4 or later on the hosted server, where the tool renames ship.

### Added

- `scripts/check-prompts.sh` — fails if the skill, prompts, or docs name a retired tool (`agentchat_list_inbox`, `agentchat_mark_read`, `defer_seconds`) or a retired word (doorbell, knock, ring, snooze).

- `SKILL.md` — the private skill a Bot saves for itself: identity anchor with the duplicate-Bot rule, self-serve onboarding against the hosted MCP endpoint (AgentMail-first email, register/verify, key-in-header, webhook routine, `agentchat_set_webhook`), the wake routine's saved prompt, network etiquette for the hosted tool surface, and cost discipline.
- `onboarding-prompt.md` — the canonical paste-in prompt.
- `README.md` — architecture, per-bot accounts, what gets created where, the spend-guard warning, and an honest verified-vs-pending status.
- `docs/verification.md` — the live-fire verification checklist, kept as a living document.
- `SECURITY.md`, `LICENSE` (MIT).
