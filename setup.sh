#!/usr/bin/env bash
# First-time setup for ai-campaign-kit.
# Installs the skills into Claude Code, asks about your brand, writes
# campaign-copy/references/brand.md, and checks the tools the workflow needs.
# Safe to re-run: it asks before replacing anything that already exists.
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"   # override for testing
TOKEN_FILE="${FIGMA_TOKEN_FILE:-$HOME/.figma-token}"

say()  { printf '\n\033[1m%s\033[0m\n' "$*"; }
note() { printf '  %s\n' "$*"; }

# ask VAR "Question" "default"  -> reads one line, falls back to the default
ask() {
  local __var=$1 q=$2 def=${3:-} ans
  if [ -n "$def" ]; then read -r -p "  $q [$def]: " ans || true; else read -r -p "  $q: " ans || true; fi
  printf -v "$__var" '%s' "${ans:-$def}"
}

yes_no() {  # yes_no "Question" default(y|n) -> exit 0 on yes
  local ans def=$2
  read -r -p "  $1 [$( [ "$def" = y ] && echo Y/n || echo y/N )]: " ans || true
  ans=${ans:-$def}
  [ "$ans" = y ] || [ "$ans" = Y ] || [ "$ans" = yes ]
}

say "ai-campaign-kit setup"
note "Skills go to: $SKILLS_DIR"
note "Press Enter to accept a [default]. Re-run this script any time to change answers."

# ---------- 1. skills ----------
say "1/4  Installing skills"
mkdir -p "$SKILLS_DIR"
for src in "$KIT"/skills/*/; do
  name=$(basename "$src"); dest="$SKILLS_DIR/$name"
  if [ -e "$dest" ]; then
    if yes_no "'$name' already exists in your skills. Replace it (a backup is kept)?" n; then
      mv "$dest" "$dest.bak-$(date +%Y%m%d-%H%M%S)"
    else
      note "kept your existing '$name'"; continue
    fi
  fi
  cp -R "$src" "$dest"
  note "installed $name"
done

# ---------- 2. brand ----------
BRAND_FILE="$SKILLS_DIR/campaign-copy/references/brand.md"
say "2/4  Your brand"
if [ ! -d "$SKILLS_DIR/campaign-copy" ]; then
  note "campaign-copy is not installed, skipping brand questions."
elif [ -e "$BRAND_FILE" ] && ! yes_no "A brand profile already exists. Answer the questions again and replace it?" n; then
  note "kept $BRAND_FILE"
else
  note "The kit does not ship anyone's guidelines. Claude derives yours from your own"
  note "material on the first campaign. Here you only say where that material is."
  note "Answers go into brand.md, which stays on your machine. Leave blank what you don't have."
  echo
  ask brand_name   "Brand name"
  ask category     "What you sell, in a few words"
  ask languages    "Ad languages (comma-separated codes)" "EN"
  ask workspace    "Folder where campaign folders should live" "$HOME/campaigns-workspace"
  echo
  note "Sources Claude will derive your guidelines from (paths or URLs, separate with ';')."
  ask src_ads      "Past ads you rate: a folder of images, or links (3+ is best)"
  ask src_rejected "Ads or copy that were rejected, if you kept any"
  ask src_site     "Your website"
  ask src_book     "Brand book or tone-of-voice document"
  ask src_legal    "Compliance, legal or claims documents"
  ask src_figma    "Figma file with your visual style (URL)"
  ask src_logo     "Logo (Figma node, file path or URL)"
  ask src_compet   "Competitors or ads you admire from any brand (optional)"
  ask approver     "Who signs off copy and compliance (role, not a name)"

  mkdir -p "$(dirname "$BRAND_FILE")"
  cat > "$BRAND_FILE" <<EOF
# Brand profile

Created by setup.sh on $(date +%Y-%m-%d). Only the facts and sources below were given.
Every other section is DERIVED by the campaign-copy skill from those sources (section 0 of
the skill) and approved by the person before use. Empty means not derived yet: never fill
a section from memory or from another brand.

## Facts

| Field | Value |
|---|---|
| brand.name | $brand_name |
| brand.category | $category |
| brand.languages | $languages |
| brand.workspace | $workspace |
| brand.approver | $approver |

## Sources

- **Past ads (rated):** $src_ads
- **Rejected work:** $src_rejected
- **Website:** $src_site
- **Brand book / tone of voice:** $src_book
- **Compliance / legal:** $src_legal
- **Figma style file:** $src_figma
- **Logo:** $src_logo
- **Admired references:** $src_compet

## Voice card
_Not derived yet._

## Ad stack
_Not derived yet._

## Hook routes
_Not derived yet. Grows with every campaign: winners, losers and why._

## Compliance
_Not derived yet._

## Visual identity
_Not derived yet._

## Format layouts
_Not derived yet._

## Taste log
_Empty. One line per reviewer decision on a visual, with the reason._

## Transcreation glossary
_Empty. One row per approved local choice: language, source line, local line, why._

## Open questions
EOF
  note "wrote $BRAND_FILE"
  if [ -n "$workspace" ]; then
    ws=${workspace/#\~/$HOME}   # expand a leading ~
    mkdir -p "$ws/campaigns"
    if [ ! -e "$ws/campaigns/_template" ]; then
      cp -R "$KIT/templates/campaign" "$ws/campaigns/_template"
      note "campaign template copied to $ws/campaigns/_template"
    fi
  fi
fi

# ---------- 3. connections ----------
say "3/4  Figma and Higgsfield"
note "Figma: connect the official Figma connector in Claude (claude.ai -> Settings -> Connectors -> Figma)."
note "You need edit access to the campaign file."
echo
if yes_no "Save a Figma personal access token so Claude can read your Figma comments?" n; then
  note "Create one at figma.com -> Settings -> Security -> Personal access tokens,"
  note "with the scope 'File comments: Read' (add 'Write' if Claude should reply)."
  read -r -s -p "  Paste the token (hidden): " tok || true; echo
  if [ -n "${tok:-}" ]; then
    (umask 077; printf '%s\n' "$tok" > "$TOKEN_FILE"); chmod 600 "$TOKEN_FILE"
    note "saved to $TOKEN_FILE (readable only by you). Never paste it into a chat."
  else
    note "no token entered, skipped"
  fi
fi
echo
note "Higgsfield (images, video, audio): use Higgsfield's official MCP server."
note "Install guide: https://higgsfield.ai/mcp   Server: https://mcp.higgsfield.ai/mcp"
if command -v claude >/dev/null 2>&1; then
  if yes_no "Add the Higgsfield MCP server to Claude Code now?" y; then
    claude mcp add --transport http higgsfield https://mcp.higgsfield.ai/mcp \
      && note "added. Run /mcp inside Claude Code to sign in to Higgsfield." \
      || note "could not add it automatically; follow the install guide above."
  fi
else
  note "Claude Code CLI not found. Follow the install guide above once it is installed."
fi

# ---------- 4. tools ----------
say "4/4  Tools for the motion version"
for t in python3 ffmpeg; do
  if command -v "$t" >/dev/null 2>&1; then note "ok       $t"; else note "MISSING  $t  (macOS: brew install $t)"; fi
done

say "Done. Restart Claude Code, then try:"
note "\"New campaign SPRING20, here is the brief: <path>\""
