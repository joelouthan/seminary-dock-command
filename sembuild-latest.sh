#!/bin/zsh
# One-button build: finds your most recently modified paper, builds DOCX, opens in Word.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

SEMINARY="$HOME/Documents/Seminary"
BUILD_SH="$SEMINARY/templates/build.sh"

# Papers are named CLASSCODE_Louthan_*.md — this excludes syllabi, study guides, etc.
LATEST_MD=$(find "$SEMINARY" -name "*_Louthan_*.md" -type f -print0 \
  | xargs -0 ls -t 2>/dev/null \
  | head -1)

if [[ -z "$LATEST_MD" ]]; then
  osascript -e 'display notification "No paper .md file found" with title "Seminary Build"'
  exit 1
fi

CLASSCODE=$(basename "$LATEST_MD" | cut -d_ -f1)
OUTPUT="$SEMINARY/$CLASSCODE/$(basename "${LATEST_MD%.md}").docx"

osascript -e "display notification \"$(basename "$LATEST_MD")\" with title \"Seminary Build\" subtitle \"Building...\""

if /bin/bash "$BUILD_SH" "$LATEST_MD" "$OUTPUT"; then
  open -a "Microsoft Word" "$OUTPUT"
  osascript -e "display notification \"$(basename "$OUTPUT")\" with title \"Seminary Build\" subtitle \"Done\""
else
  osascript -e 'display notification "Build failed — check Terminal" with title "Seminary Build"'
  exit 1
fi
