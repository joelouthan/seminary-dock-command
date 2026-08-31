#!/bin/zsh
# One-button fix: finds your most recently modified paper and shortens
# full Bible book names to CBTS style-sheet abbreviations in place.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

SEMINARY="$HOME/Documents/Seminary"
FIX_SH="$SEMINARY/templates/fix-bible-refs.sh"

# Papers are named CLASSCODE_Louthan_*.md — this excludes syllabi, study guides, etc.
LATEST_MD=$(find -L "$SEMINARY" -name "*_Louthan_*.md" -type f -print0 \
  | xargs -0 ls -t 2>/dev/null \
  | head -1)

if [[ -z "$LATEST_MD" ]]; then
  osascript -e 'display notification "No paper .md file found" with title "Seminary Fix Refs"'
  exit 1
fi

osascript -e "display notification \"$(basename "$LATEST_MD")\" with title \"Seminary Fix Refs\" subtitle \"Checking...\""

OUTPUT=$(/bin/bash "$FIX_SH" "$LATEST_MD" 2>&1)
STATUS=$?

if [[ $STATUS -ne 0 ]]; then
  osascript -e 'display notification "Fix failed — check Terminal" with title "Seminary Fix Refs"'
  exit 1
fi

if [[ "$OUTPUT" == *"No references needed shortening"* ]]; then
  osascript -e "display notification \"$(basename "$LATEST_MD")\" with title \"Seminary Fix Refs\" subtitle \"Nothing to change\""
else
  osascript -e "display notification \"$(basename "$LATEST_MD")\" with title \"Seminary Fix Refs\" subtitle \"Abbreviated — .bak saved\""
fi
