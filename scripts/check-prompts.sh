#!/usr/bin/env sh
# Fails when the recipe names a tool or a word the AgentChat tool core retired.
# The prompts here are what a Bot executes: a stale tool name sends it down a
# flow the hosted server no longer has, and a retired word puts a third
# vocabulary next to the server's own texts.
#
# Usage: scripts/check-prompts.sh [file ...]
# Default: every tracked Markdown file except CHANGELOG.md (history may name
# what was removed).
set -eu

cd "$(dirname "$0")/.."

if [ "$#" -gt 0 ]; then
  files="$*"
else
  files=$(git ls-files '*.md' ':!CHANGELOG.md')
fi

# Tool names and parameters the recipe must not call.
tools='agentchat_list_inbox|agentchat_mark_read|defer_seconds'
# Words the plan retired; the recipe says "integration" and "wake".
words='doorbell|doorbells|knock|knocks|knocked|knocking|ring|rings|ringing|rang|snooze|snoozed|snoozing'

status=0
count=0
for f in $files; do
  count=$((count + 1))
  if grep -HnE "$tools" "$f"; then status=1; fi
  if grep -HnwiE "$words" "$f"; then status=1; fi
done

if [ "$status" -ne 0 ]; then
  echo "check-prompts: retired tool names or words found (lines above)" >&2
  exit 1
fi
echo "check-prompts: clean ($count files)"
