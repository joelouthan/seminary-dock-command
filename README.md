# seminary-scripts

<div align="center">
  <img src="Star_Trek_First_Contact_Data_processing_speed.gif" alt="Me trying to get through seminary like" />
  <p><em>Me trying to get through seminary like</em></p>
</div>

Personal command-line toolkit for writing seminary papers in Markdown and exporting them to Word (DOCX) via [pandoc](https://pandoc.org). Built around a workflow of drafting in Markdown, citing with Zotero/Better BibTeX, and building to a styled DOCX with a Turabian CSL and a reference-doc template.

These scripts are personal tools, not a polished package — paths assume a specific local folder layout (see **Dependencies** below). Shared here as a reference / backup, not a plug-and-play install.

## Scripts

- **`seminary`** — Interactive numbered menu for all the commands below. Run it in a terminal and pick an option.
- **`sembuild-latest.sh`** — Finds the most recently edited paper, builds it to DOCX, and opens it in Word. Fires macOS notifications at each step.
- **`sembuild-latest-h1-breaks.sh`** — Same as above, but uses a build variant that inserts page breaks at each top-level (`#`) heading — used for sermon manuscripts.
- **`semfixrefs-latest.sh`** — Finds the most recently edited paper and shortens full Bible book names to the seminary's style-sheet abbreviations (e.g. "Genesis 3:16" → "Gen. 3:16"), wherever a book name is directly followed by a chapter number. Backs up to `.bak` first.

## Dependencies

These scripts assume:

- A `~/Documents/Seminary` folder containing:
  - `templates/build.sh`, `templates/build-book-review.sh`, and `templates/build-with-sermon-breaks.sh` — the actual pandoc build pipelines (reference doc, CSL, Lua filters).
  - `templates/fix-bible-refs.sh` — the `sed`-based abbreviation script that `semfixrefs-latest.sh` calls.
  - Papers named `CLASSCODE_Louthan_*.md` (e.g. `BI11_Louthan_Preaching_Christ_from_the_Old_Testament.md`).

- Shell functions defined in `~/.zshrc`: `seminary-new`, `seminary-build`, `seminary-new-review`, `seminary-build-review`, `seminary-import`, `seminary-fix-refs`, `sem-wc`, `sem-cover-wc` — the `seminary` menu script sources `~/.zshrc` to call these directly.

- macOS (`osascript` for notifications, `open -a "Microsoft Word"`).

None of the above ships in this repo — it's the private, paper-specific half of the workflow. This repo is just the automation layer on top.

## Setup (for reference)

Each script here is symlinked into `~/bin` (which is on `$PATH`):

```bash
ln -s ~/Projects/seminary-scripts/seminary ~/bin/seminary
ln -s ~/Projects/seminary-scripts/sembuild-latest.sh ~/bin/sembuild-latest.sh
ln -s ~/Projects/seminary-scripts/sembuild-latest-h1-breaks.sh ~/bin/sembuild-latest-h1-breaks.sh
ln -s ~/Projects/seminary-scripts/semfixrefs-latest.sh ~/bin/semfixrefs-latest.sh
```

This keeps one source of truth (the file in this repo) while staying callable by name from any terminal.

## License

MIT — see [LICENSE](LICENSE).
