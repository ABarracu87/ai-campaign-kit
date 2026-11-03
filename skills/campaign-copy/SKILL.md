---
name: campaign-copy
description: Promo and ad campaigns end to end, from a creative brief to on-image copy, concepts, master visuals, static ad formats in Figma, transcreations and a motion version. It ships no brand's guidelines. It carries the procedures for deriving them (voice, ad stack, hooks, compliance, visual taste, format layouts, transcreation) from the brand's own material, stores them in references/brand.md, and applies them. Use whenever a campaign, promo, discount code, brief, ad creative, Meta or Performance Max copy is mentioned, or the person asks to derive or update brand guidelines. Load `copy` for general craft; this skill overrides it for campaigns.
---

# Campaign copy

This skill contains **no guidelines**. It contains the way to derive them. Every rule a
campaign follows comes from the brand's own material, is written into
`references/brand.md`, and is approved by the person before use.

Every derivation below follows the same loop:

1. **Inputs:** read the named sources from `brand.md → Sources`. If a source is missing, ask for it. Never fill the gap from memory, from the category's clichés or from another brand.
2. **Extract:** list what you observe, with the source of each observation (file, URL, frame).
3. **Generalise:** turn repeated observations into rules. One example is an observation, not a rule. Mark rules that rest on one or two examples as `[tentative]`.
4. **Approve:** show the rules to the person with the evidence beside them. Only approved rules go into `brand.md`.
5. **Record decisions:** every reviewer pick or rejection during a campaign adds one line to the relevant section of `brand.md`, with the reason. The guidelines improve with each campaign.

Never present a derived rule as a fact about the brand until step 4 has happened.

## 0. First run: derive the brand

When `brand.md` sections read "Not derived yet", run sections 2–5, 7, 8 and 9 in derivation mode before writing any campaign copy. If `brand.md` is missing, ask the person to run `setup.sh` from the kit.

Say which sections you could not derive and why (for example "no past ads, so the ad stack is a proposal, not a derivation").

## 1. Set up the campaign

```
{brand.workspace}/campaigns/<CODE>/
  brief/  copy/  master-image/  figma/  translations/  video/  exports/
```
Copy the brief into `brief/` and convert it to text (`textutil -convert txt` on macOS). Version every round: `01_…_v1.md`, `02_…_v2.md`. Never overwrite an earlier round, because the team compares rounds.

Pull out of the brief, quoting it:
1. Offer, code and dates
2. Eligibility. Any ambiguity ("above $10k") becomes an open question, never an assumption.
3. Any second benefit and its condition
4. Disclaimer, word for word
5. Banned words, required lines and brand-term translations
6. Formats, sizes and character limits

Where the brief conflicts with `brand.md`, the brief wins for this campaign. Flag the conflict.

## 2. Derive the voice card

**Inputs:** past ads, website, brand book, and rejected work if any.

**Extract, per source:** who is speaking to whom (person, formality); average and longest sentence length; how jokes are made, if at all (wordplay, irony, insider slang, none); words that recur; words that never appear; how numbers and offers are phrased; punctuation habits.

**Generalise into a voice card** of 5–8 lines, each with a do and a don't taken from the sources. Include:
- **Register:** how serious, and how that shows.
- **Vocabulary:** the insider words the audience uses. These become the raw material for hooks.
- **Length limits** for hooks and sub-lines, measured from the ads that worked.
- **Translation constraint:** if `{brand.languages}` has more than one language, the words must survive transcreation, so flag idioms that won't.

**Check:** rewrite one past ad's copy using only the card. If the person can't tell it from the original's voice, the card is good enough.

## 3. Derive the ad stack

**Inputs:** at least 3 past static ads, ideally ones that performed.

**Extract:** deconstruct each ad top to bottom. List each element in order (logo, eyebrow, hook, sub-line, offer figure, code, CTA, sticker, labels, disclaimer), with its relative size, weight and position.

**Generalise:** the elements and their order that appear in most of the ads become the stack. Note:
- **Primary element:** which one is biggest, usually the offer.
- **Second benefits:** how they're carried, for example as a sticker or a line.
- **Conditions:** where they live (an asterisk to the disclaimer, or inline).
- **Required labels:** for example an AI-generated label. Check the legal sources and the target platforms' current policies for these. Don't assume.

**Check:** does every past ad fit the stack, allowing for the optional elements? List the ones that don't and ask whether they were exceptions.

## 4. Hooks: derive the routes, then let the reviewer choose

The hook is the creative line. A route is a repeatable way of making one: an insider joke, a reversal, a plain promise, a question, a number shock, and so on.

**Inputs:** the voice card, the brief, past ads, and `brand.md → Hook routes`.

**First campaign:** read the past ads' hooks and name the route each one uses. Then write concepts across **at least four different routes**, including at least one route the brand hasn't used before. Don't pick a route in advance. The reviewer's choices reveal which ones fit the brand.

**Every round:**
- Give 8–10 concepts in one table: route / hook / sub-line / sticker / master-image idea.
- Mark a shortlist of 3 with one-line reasons.
- Add a transcreation note: rank the concepts from easiest to hardest to adapt across `{brand.languages}`.
- Each hook gets a one-second test: can a stranger get it on one read?
- Each hook gets a safety test: does it imply a result the brand can't promise? Check against `brand.md → Compliance`.

**Record:** after the pick, add the winning and rejected routes to `brand.md → Hook routes`, with the reviewer's reason in their words. "Too dry", "too clever" and "off-brand" are all useful signals. After two or three campaigns, the routes that keep winning are the brand's method.

**When a round is rejected for being too dry or too safe:** don't produce more variants of the same route. Ask for a hook from any brand that the reviewer rates, and derive the route from it.

## 5. Derive the compliance list

**Inputs:** the legal and compliance sources, the brief, and the current advertising policies of the platforms you're running on (Meta, Google and so on). Read the platforms' policies at the time of the campaign. They change.

**Extract** four lists, each item quoting its source:
- **Cannot say:** banned words and claims.
- **Must say:** required lines and labels.
- **Conditional:** claims allowed only with a condition attached.
- **Unverified:** product facts that copy might depend on but nobody has confirmed.

**Approve** with `{brand.approver}`. Unverified facts always go to open questions, never into copy.

**Check every line of every round** against the list before showing it.

## 6. Deliverable format

Write a markdown file in `copy/` containing:
- the concept table;
- the shortlist with reasons;
- the disclaimer's condition line;
- notes;
- `## Open questions`;
- `## Rejected`, one line per rejected option.

In chat, show the table and the shortlist, then ask for a pick. After approval, the order is: master visual, Figma formats, transcreations, motion.

## 7. Master visuals: derive the taste

**Inputs:** past ads, the Figma style file, admired references, and `brand.md → Taste log`.

**First campaign:**
- Describe the past visuals: subject count, what the subject is made of, whether it moves or poses, colours, lighting and composition.
- Write 2–3 image directions that vary these on purpose: one subject or several, still or in action, literal or metaphorical.
- Generate each direction through the Higgsfield MCP. Generate 2 variants of each and no text.
- Show the variants side by side and ask the reviewer to pick and to reject, **with a reason for each**.

**Critique questions to ask of every image, before the reviewer sees it:**
- Can it be described in five words? If not, it's probably too busy.
- Is there one clear hero, or are symbols competing?
- Did the model add elements the prompt didn't ask for?
- Does the image land the feeling, or just diagram the headline?
- Is something happening, or is the subject just posing?
- Is the key prop big enough to read at feed size?
- Is there clean space where the ad stack will sit?

These are questions, not rules. The reviewer's answers decide which of them matter for this brand.

**Record:** every pick and rejection goes into `brand.md → Taste log` with the reason. Rules that recur across rounds become `[tentative]`, then confirmed after a second campaign. Turn confirmed rules into prompt instructions (for example "a single …, no other objects").

## 8. Static formats in Figma: derive the layouts

Load `figma-build` before writing any Figma code.

**Sizes come from the person, never from this skill.** Use the brief's sizes first, then `brand.static_sizes` from `brand.md`. If neither lists any, ask for them before building. Never assume platform defaults or reuse another campaign's sizes. Name frames after the size and the person's label for it, e.g. `<CODE>_<WxH>_<label>_<LANG>_v<N>`, unless the brief names them.

**Visual identity (first run):** read type, colours, shapes and logo from the Figma style file or website. Pull exact values from the file (styles, variables, node fills), not from screenshots. Write them to `brand.md → Visual identity` and get approval.

**Layout per format:** derive it, don't copy it.
- **Build one format first,** the first size in the person's list unless they choose another, from the stack and the identity. Get approval.
- **Measure the approved frame:** the position and size of each element as a fraction of the frame, the copy column's width, and the gap between the hero and the subject. Write the measurements to `brand.md → Format layouts`.
- **For each other size the person listed, start from the target placement's safe zones,** meaning the areas the platform UI covers (Reels and Stories cover the top and bottom). Don't just stretch the square. Tall formats usually need their own arrangement. Propose one, then get feedback through Figma comments.
- **No hard crops:** extend the master to each ratio with the image model ("extend and reframe this exact image…"), then check the new area for a seam.

**Checks before hand-off, for every frame:**
- Copy doesn't overlap the disclaimer.
- The hero doesn't overlap the subject.
- Nothing important sits in a platform's UI zone.
- No gradient or scrim ends in a hard edge.
- The detail that makes the joke is visible.

**Record:** the reviewer's comment-driven fixes go into `Format layouts` as measurements, so the next campaign starts from them.

## 9. Transcreation: derive the local voice

**Inputs:**
- The approved English copy and the voice card.
- `brand.md → Transcreation glossary`.
- For each language, current local ads in the same category (search for them, or ask for examples).

**Procedure, per language:**
1. Start from what a local insider would say, never from a literal translation. Find the local equivalent of the joke. Some slang stays in English. Find out which from the local ads.
2. Look up the local ad conventions for CTAs and for framing an offer. Literal CTAs read as foreign.
3. Check idioms for negative connotations in that language (an English "price drop" phrase can read as disaster elsewhere).
4. Translate the disclaimer faithfully. It isn't transcreated.
5. Use the brief's brand-term translations exactly.

**Source of truth:** `translations/<concept>_static_v<N>.json`, one block per language, with one key per stack element.

**Figma:**
- One row per language under EN, with frames cloned from EN and renamed `_EN_` → `_<LANG>_`.
- **Fonts:** check that the brand font covers each script. Pick a fallback per script and record it in `Visual identity`.
- **Fitting:** shrink the hero first, then wrap the hook and sub-line. Then run an overflow guard: copy bottom + margin ≤ disclaimer top. If a language's offer word is long, propose options (two lines, a symbol) rather than silently shrinking.
- **Right-to-left scripts:** right-align all text, reverse the order of children in horizontal rows, and mirror the image and horizontal gradients. Bidi can reorder symbols ("35%" becomes "%35"), so a native reviewer must confirm.

**Record:** each approved local choice goes into the glossary with the reason. **Native-speaker review is required before shipping**, non-Latin scripts first.

## 10. Motion version

The procedure is general. Sizes and lengths come from the brief, then `brand.motion_sizes`; if neither has them, ask. Timings come from the storyboard, never from a previous campaign.

1. **Storyboard first:** beats with timings, which element enters when, and what the picture does. Get a yes before spending credits.
2. **AI animates the picture, never the text.** Generate an image-to-video plate from the approved master through the Higgsfield MCP, at the length the person asked for, with no text and no generated audio. Video is the expensive step: ask the MCP for the credit cost and confirm it with the person before running.
3. **Text as layers:** export one transparent full-frame PNG per stack element from a "<CODE> — video layers" Figma page, made of clones of the approved frame. Hide the other elements with **opacity 0, not visible=false**: hiding collapses auto-layout and moves everything.
4. **Compose** with `tools/compose.py <plate> <layers> <out> --size W H --duration S --scale W H --crop X Y`, with the size and length from the person's list. Set its `TIMELINE` and `SFX` from the storyboard. Pass the same scale and offset as the image layer in the Figma frame, so the motion matches the static.
5. **Sync to the plate, not the prompt:** pull frames every 0.3 s around each key beat. Models rarely land a beat at the time the prompt asked for, so move the text and sound cues to where the beat actually happens.
6. **Make one proof in the first motion size, in the first language, before the full set.**
7. **Spec:** take it from the brief or the platform. Check that the music and generated media are licensed for paid ads.
