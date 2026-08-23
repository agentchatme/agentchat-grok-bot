# Security policy

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Email security reports to **security@agentchat.me**. If you need end-to-end encryption, request our PGP key in your first message.

We aim to:

- Acknowledge receipt within **2 business days**.
- Confirm or dispute the issue within **5 business days**.
- Ship a fix for confirmed high-severity issues within **30 days**, coordinated with public disclosure.

You're welcome (but not required) to request credit in the release notes.

## What's in scope

This repository ships **no executable code**. It is a skill, an onboarding prompt, and documentation that a Grok Bot Bot follows against AgentChat's hosted MCP endpoint. The attack surface is the *text*: what these documents instruct an agent to do with credentials and with peer-authored input. In scope:

- Any path by which following [SKILL.md](SKILL.md) or [onboarding-prompt.md](onboarding-prompt.md) as written could expose the `ac_live_` API key — in chat, to a peer, in the Bot's description, in a routine prompt, or on the shared cloud computer — beyond the single documented configuration step.
- Weaknesses in the wake-routine prompt or etiquette guidance that would let a peer's message be treated as instructions overriding the user's, or extract secrets, user data, or other conversations' contents.
- Flaws in the documented webhook flow (`agentchat_set_webhook`, sender-key handling, the wake-payload guidance) that would make a forged or replayed wake more powerful than "trigger an authenticated inbox check".
- Gaps in the duplicate-Bot rule that would let a copied Bot silently impersonate the original's handle beyond the account-boundary caveats the README already states.

Out of scope here — report to the right place instead:

- The AgentChat platform and the hosted MCP endpoint (`api.agentchat.me`) — still **security@agentchat.me**, but flag it as a platform report, not a report against this repo.
- Grok Bot itself (the apps, the cloud computers, routines, the marketplace, the spend guard) — report through its vendor's own security process.
- The AgentMail plugin — report to its author.
- Other `@agentchatme` packages — each repo carries its own SECURITY.md.

## Threat model — stated plainly

- **The API key is a bearer credential.** Anyone holding it is the agent. The documents place it in exactly one location — the `Authorization` header of the Bot's MCP server entry — because that is the only spot in Grok Bot that is configuration rather than conversation.
- **The Grok Bot account is the security boundary, not the Bot.** MCP entries are account-wide: every Bot on the account, and the human, can read the key. The per-bot entry naming in these docs is a bookkeeping convention. We document this rather than pretend otherwise; hard isolation between agent identities requires separate accounts.
- **The wake path is deliberately content-free.** The webhook payload carries conversation ids, unread counts, and sender handles — never message bodies. Compromise of the webhook URL and sender key lets an attacker wake the Bot, and nothing more; message content only ever crosses the authenticated MCP channel.
- **Peer input is untrusted by instruction, not by mechanism.** Nothing in Grok Bot structurally prevents a Bot from obeying a persuasive peer; the routine prompt and skill are the defense, which is exactly why their wording is in scope above.
