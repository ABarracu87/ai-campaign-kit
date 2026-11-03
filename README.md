# ai-campaign-kit

## Turn one brief into a full ad campaign that sounds like your brand.

Hand Claude a creative brief. You get concepts, master visuals, every static ad format, every language and a motion version. Everything is built in your Figma file and ready for your comments. Claude learns your voice, layout and taste from your own past work, so the ads sound like you and not like the average of the internet.

```bash
git clone https://github.com/ABarracu87/ai-campaign-kit && cd ai-campaign-kit && ./setup.sh
```

Free and open source (MIT). It runs inside [Claude Code](https://claude.com/claude-code).

---

## What one brief gets you

| | |
|---|---|
| **Concepts** | 8–10 creative routes in one table (hook, sub-line, sticker, image idea), with a shortlist of 3 and the reasons |
| **Master visuals** | 4K hero images generated through Higgsfield, with clean space for your copy |
| **Static formats** | Every size your brief asks for, built in your Figma file. The default set is Meta 1080×1080, 1080×1350, 1080×1920 and Performance Max 1200×1200, 960×1200, 1200×628 |
| **Languages** | Transcreated, not translated, one row per language, right-to-left scripts mirrored |
| **Motion** | A 15-second video: the picture animated by AI, your copy layered on top so it stays sharp and editable |
| **A paper trail** | Every round versioned, every rejected option listed with its reason, open questions kept on the front page |

## Why it sounds like you

Most AI tools write from a generic template. This kit ships **no one's guidelines**. It ships the method for finding yours.

1. **Point it at your material:** past ads you rate, your website, your brand book, your compliance documents, your Figma style file.
2. **Claude works out your guidelines:** your voice, ad layout, compliance rules, visual taste and format measurements. Each rule cites the ad or page it came from.
3. **You approve them.** Nothing reaches an ad until you have said yes.
4. **It keeps learning.** Every pick and every rejection is saved with your reason. Rules drawn from one or two examples stay marked as tentative until a second campaign confirms them.

Your guidelines live in one file on your machine. They never go into the repo.

## How a campaign runs

You direct, Claude does the rounds. Each step is one sentence.

| Step | You say | You get |
|---|---|---|
| 0. Once | "Derive our brand guidelines" | Your voice, ad stack, compliance list and visual identity, with the evidence, to approve |
| 1. Brief | "New campaign SPRING20, here is the brief: <path>" | A campaign folder, with the offer, eligibility, disclaimer and compliance pulled out |
| 2. Copy | "Give me 8–10 concepts" | The concept table and a shortlist |
| 3. Visuals | "Make master visuals for A, C and F in Figma: <file>" | Text-free 4K masters on a Figma page |
| 4. Formats | "Build all static formats for A" | Every size, laid out from your measurements |
| 5. Feedback | Comment in Figma, then "read my comments" | Claude reads them and applies them |
| 6. Languages | "Transcreate into ES, DE and IT" | One row per language, fitted to every frame |
| 7. Motion | "Make the animated version" | A storyboard to approve, a proof, then the full set |

## What's in the box

| | |
|---|---|
| `setup.sh` | Guided first-time setup: installs the skills, asks where your brand material is, connects Figma and Higgsfield, checks your tools |
| `campaign-copy` skill | The playbook. How to derive each guideline, then how to run each step with it |
| `copy` skill | Copywriting craft: angle, headlines, buttons, research, the final pass |
| `figma-build` skill | Keeps Figma builds from failing silently. Also available on its own as [figma-build-skill](https://github.com/ABarracu87/figma-build-skill) |
| `compose.py` | Assembles the motion ad from the AI video, your Figma text layers and audio, into a ready-to-upload MP4 |
| Campaign template | The folder layout every campaign uses |

## What you need

- **Claude Code.**
- **Figma**, with edit access to your campaign file. Connect it in Claude: claude.ai → Settings → Connectors → Figma.
- **A Higgsfield account** for images, video and audio, through [Higgsfield's official MCP server](https://higgsfield.ai/mcp). Higgsfield charges in credits, and video is the most expensive step. Claude asks for the cost and waits for your yes before generating a video. Check Higgsfield's site for which plans include the MCP.
- **`python3` and `ffmpeg`**, for the motion version. On macOS: `brew install ffmpeg`.

## Setup takes one command

```bash
./setup.sh
```

It asks:
- **Before replacing** any skill with the same name that you already have. A backup is kept.
- **The basics:** brand name, what you sell, languages, and where campaign folders should live.
- **Who signs off** copy and compliance.
- **Where your material is:**
  - Past ads you rate (3 or more is best) and any rejected work.
  - Your website and brand book.
  - Your compliance documents.
  - Your Figma style file and logo.
  - References you admire.
- **Optionally, a Figma token** so Claude can read your Figma comments. The Figma connector can't read comments. The token is stored in `~/.figma-token`, readable only by you.
- **Whether to add the Higgsfield MCP server** to Claude Code. Afterwards, run `/mcp` inside Claude Code to sign in.

Then it checks for `python3` and `ffmpeg`.

Restart Claude Code, then type: *"Derive our brand guidelines."*

## Frequently asked questions

**Do I need to write a brand guide first?**
No. Claude derives one from the ads and pages you already have. If you have a brand book, it reads that too.

**What if I have no past ads?**
Claude proposes a starting voice and layout and tells you they are proposals, not derived from your work. Your picks in the first campaign then become the evidence.

**Does it replace a designer or copywriter?**
No. It replaces the rounds of drafting. A person still chooses the concept, comments on the layouts and approves every rule.

**Is my brand data shared?**
Your guidelines are saved in `~/.claude/skills/campaign-copy/references/brand.md` on your machine. The repo ignores that file. Images and video are generated through your own Higgsfield account.

**Are the translations ready to publish?**
They are transcreated and fitted to every frame, but a native speaker must review them before shipping, starting with non-Latin scripts.

**Who checks compliance?**
Claude checks every line against the rules derived from your documents and the platforms' current ad policies. The person you name in setup signs off. Facts nobody has confirmed go to open questions, never into copy.

**Can I use it with my existing skills?**
Yes. Setup asks before replacing anything with the same name and keeps a backup.

## Before you ship any campaign

- A native speaker reviews every language.
- Your music and generated-media licence covers paid ads.
- The disclaimer stays clear of each platform's UI. Reels and Stories cover the bottom of the frame.

---

```bash
git clone https://github.com/ABarracu87/ai-campaign-kit && cd ai-campaign-kit && ./setup.sh
```

MIT licence. `figma-build` is also MIT, from [figma-build-skill](https://github.com/ABarracu87/figma-build-skill).
