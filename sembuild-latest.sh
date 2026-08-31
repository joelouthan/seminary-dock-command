#!/bin/zsh
# One-button build: finds your most recently modified paper, builds DOCX, opens in Word.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

SEMINARY="$HOME/Documents/Seminary"

# Papers are named CLASSCODE_Louthan_*.md — this excludes syllabi, study guides, etc.
LATEST_MD=$(find -L "$SEMINARY" -name "*_Louthan_*.md" -type f -print0 \
  | xargs -0 ls -t 2>/dev/null \
  | head -1)

if [[ -z "$LATEST_MD" ]]; then
  osascript -e 'display notification "No paper .md file found" with title "Seminary Build"'
  exit 1
fi

CLASSCODE=$(basename "$LATEST_MD" | cut -d_ -f1)
OUTPUT="$SEMINARY/$CLASSCODE/$(basename "${LATEST_MD%.md}").docx"

# A book review carries a `bibref:` key in its YAML front matter and must NOT get
# a cover page (Book Review Style Guide: no title page at 6 pages or under).
# Route to the right pipeline instead of always assuming a term paper.
if awk 'NR==1 && $0!="---"{exit 1} NR>1 && $0=="---"{exit 1} /^bibref:/{found=1} END{exit !found}' "$LATEST_MD"; then
  BUILD_SH="$SEMINARY/templates/build-book-review.sh"
  KIND="book review"
else
  BUILD_SH="$SEMINARY/templates/build.sh"
  KIND="paper"
fi
echo "Detected: $KIND -> $(basename "$BUILD_SH")"

osascript -e "display notification \"$(basename "$LATEST_MD")\" with title \"Seminary Build\" subtitle \"Building $KIND...\""

if /bin/bash "$BUILD_SH" "$LATEST_MD" "$OUTPUT"; then
  open -a "Microsoft Word" "$OUTPUT"
  osascript -e "display notification \"$(basename "$OUTPUT")\" with title \"Seminary Build\" subtitle \"Done\""
else
  osascript -e 'display notification "Build failed — check Terminal" with title "Seminary Build"'
  exit 1
fi
