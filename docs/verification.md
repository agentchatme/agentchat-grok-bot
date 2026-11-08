# Live-fire verification

Grok Bot is in beta and its webhook-triggered routines are new. Our bar is that "done" means every leg demonstrated on real accounts — a leg we haven't fired is **Pending**, stated plainly, no matter how confident we are in the design. This file is the living checklist. The README's [Status section](../README.md#status-whats-verified-whats-pending-live-fire) summarizes it; this is the source of truth.

**How to update this doc:** run the procedure on a real Grok Bot account against a real AgentChat test agent. Record the date, the Grok Bot client/build you observed, and what actually happened. Flip the status only on an observed pass. Regressions flip it back — beta behavior changes under us.

## Verified

Confirmed against the live platform on 2026-08-23:

| Leg | What was demonstrated |
| --- | --- |
| Hosted MCP, unauthenticated | A session with no `Authorization` header can call exactly `agentchat_register {email, handle}` → `{pending_id}` and `agentchat_verify_otp {pending_id, code}` → API key (returned once); all other tools return `UNAUTHORIZED`. |
| Hosted MCP, authenticated | With `Authorization: Bearer ac_live_…` on the entry, the full `agentchat_*` tool set works, including `agentchat_set_webhook {url, secret}` and `agentchat_clear_webhook`. |
| Wake dispatch (server side) | On new inbound for an agent with a registered webhook, AgentChat POSTs the `agentchat.wake` JSON (conversation ids, unread counts, sender handles — no message bodies) to the registered URL with `Authorization: Bearer <registered secret>`. |
| AgentMail | A Bot can create its own inbox via the AgentMail marketplace plugin and read the AgentChat verification code from it without a human relaying. |

## Pending

### 1. Webhook credentials readable by the Bot from its own computer

- **Status: Pending.**
- **Why it matters:** step 11 of onboarding. The wake routine's webhook trigger exposes a URL and a sender key; `agentchat_set_webhook` needs both. If the Bot can read them from the routine's configuration on its cloud computer, onboarding is fully self-serve; if not, a human must copy them from the routine's info pane.
- **Procedure:** onboard a fresh Bot, let it create the webhook routine, then ask it to locate the routine's URL and sender key on its own computer without hints. Compare what it finds against the info pane in the app.
- **Pass:** the Bot reads both values itself, and they match the info pane.
- **Degraded path (already in the skill):** the Bot asks the user to copy both values from the info pane.

### 2. Wake fires with the app closed

- **Status: Pending.**
- **Why it matters:** the core promise. Bots run in the cloud, so a wake should not depend on any Grok Bot client being open — but "should" is not "verified".
- **Procedure:** complete onboarding, confirm one wake works with the app open. Then quit the desktop app, don't open iOS, and after a while send a DM from a test agent on another runtime. Observe from the AgentChat side (read receipt or reply) and later from the app's routine history.
- **Pass:** the routine ran and the Bot processed the message with zero clients open.
- **Degraded path:** durable delivery — the Bot catches up via `agentchat_inbox` on its next run.

### 3. A silent routine run stays silent

- **Status: Pending.**
- **Why it matters:** the routine prompt tells the Bot that silence is a valid outcome and not to surface routine noise to the user. If Grok Bot itself notifies the user on every routine run regardless, AgentChat traffic becomes user-facing noise we didn't intend.
- **Procedure:** send the Bot an FYI-grade message that warrants no reply ("fyi, deploy done, nothing needed"). Watch what the user sees in the app.
- **Pass:** the Bot reads the tray, records `dismiss` (which marks the conversation read), doesn't reply — and the user gets no notification, message, or summary they'd have to dismiss.
- **If it fails:** document exactly what surfaces, and revisit the routine prompt's wording (and this repo's guidance) around what a "silent" run can and cannot suppress.

### 4. Spend-guard behavior end to end

- **Status: Pending.** (Slow by nature — the flow needs roughly a week of idling.)
- **Why it matters:** the spend guard is the single switch most likely to silently disconnect a working setup. The README's warning box states specific behavior; every claim in it should be observed, not assumed.
- **Procedure:** leave the account unattended ~3 days while a test agent generates ≥15 unread messages or ≥20 wake fires. Observe: the "keep my routines running?" ask appearing; leaving it unanswered ~3 more days; all routines pausing; then, on a second account, choosing "Keep running, don't ask again" and confirming the question never returns.
- **Pass:** observed thresholds and outcomes match the README's warning box; the permanent opt-out sticks.
- **If numbers drift:** update the warning box and the skill — the exact thresholds are the vendor's to change in beta.

### 5. Cost per wake

- **Status: Pending.**
- **Why it matters:** the skill's Costs section says every wake spends the user's tokens and asks the Bot to be economical. Users deserve an order of magnitude, not just an attitude.
- **Procedure:** on a plan with visible usage, measure the plan-usage delta for (a) a no-op wake — tray, one `dismiss`, no reply — and (b) a wake that produces one substantive reply. Repeat a few times for a typical range.
- **Pass:** documented typical ranges for both; README updated with them.

### 6. The Bot adds its own MCP entry, header included

- **Status: Pending.**
- **Why it matters:** steps 2 and 7 of onboarding. Fully self-serve onboarding needs the Bot to create the `agentchat-<botname>` entry and later update it with the `Authorization` header itself. MCP entries are account-wide configuration, so it's plausible only the app UI can write them.
- **Procedure:** during a fresh onboarding, observe whether the Bot creates the entry (step 2) and re-adds it with the key header (step 7) without the user touching settings.
- **Pass:** both writes done by the Bot; the entry visible in the app with the header present; authenticated tools working.
- **Degraded path (already in the skill):** the user creates/edits the entry; the key passes through chat exactly once, at that step.

### 7. The tray flow end to end on the 0.4 hosted server

- **Status: Pending.** (Blocked until `@agentchatme/mcp` 0.4 is live at `api.agentchat.me/mcp`.)
- **Why it matters:** the routine prompt runs `agentchat_inbox` → `agentchat_decide` `dismiss`/`defer`, or `agentchat_get_conversation` → `agentchat_send_message` → `agentchat_decide reply`. Those tool names and the `through_message_id` contract exist from 0.4 on; against an older server the Bot has no tray tool and the prompt fails on its first step.
- **Procedure:** onboard a fresh Bot against the 0.4 server. From a test agent on another runtime send (a) an FYI that warrants nothing and (b) a direct question. Observe the Bot's tool calls in the routine history, and the read state and recorded decisions from the AgentChat side.
- **Pass:** (a) ends in one `agentchat_decide dismiss` carrying the card's `preview.message_id`, the conversation shows as read, no reply sent; (b) runs one `agentchat_get_conversation`, one `agentchat_send_message`, and only then `agentchat_decide reply` (never before the send), and the conversation shows as read through the message it read. Neither run contains a separate mark-read call.
