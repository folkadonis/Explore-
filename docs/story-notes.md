# Story notes: fixes for the story bible

These are suggested changes to `story-bible.pdf`. Each one names the problem, the proposed fix, and the scenes it touches. The first two matter most.

---

## 1. Too close to *Prince of Persia: The Sands of Time* (high priority)

Taking inspiration from Sands of Time's genre and feel is fine. Two specific elements are lifted almost directly, though, and players and reviewers will notice:

| Bible element | Sands of Time | Problem |
|---|---|---|
| Death line "No, no, wait. That's not how it happened." | "No, no, no, that's not how it happened." | Nearly word for word, and it's the game's best-known line. |
| Ending: time rewinds, the hero tells the whole story to the woman he travelled with, she doesn't remember it, he leaves | The same ending, beat for beat | The whole frame story is borrowed. |

**Fix A: death lines.** Keep the idea (failure becomes Ilan misremembering) but make the wording and delivery our own. Tie the lines to his arc stage instead of using one catchphrase:

- Stage 1 (cocky): "Wait. I'm telling it wrong." / "I'd never fall for that." / "Ask anyone. I didn't fall."
- Stage 2 (lone fixer): "I got up. I always get up."
- Stage 3 (partner): "Kayal would say I'm skipping the boring part."
- Stage 4 (tempted): "...Let me think about how that part went."
- Stage 5 (guardian): "No. Kayal was waiting. I got up."

The prototype already uses these.

**Fix B: the frame story.** Recommended: **the story is carved, not told.**

- Opening shot: an older Ilan at dusk, chiselling a frieze into the outer wall of the Mirror Temple. This is the wall his father died building. Narration plays over his chisel strokes.
- Ending: the camera pulls back to show the finished frieze, the whole adventure in stone. Nobody in Kanchi can read it as being about him; he has carved the hero without a face.
- Kayal, now Mirror-keeper, walks past with a palm-leaf ledger, stops, and looks at the frieze and then at the ground beneath him. **No shadow.** She opens the ledger to a page in her own handwriting (see fix 2) and smiles.
- This pays off Ilan's original want ("his name carved in stone like the kings") as an irony: the story is in stone and his name isn't. That's the whole theme in one image.
- Narration still works over gameplay: he's describing what he's carving. Kayal's interjections become the temple's young apprentices asking questions as they watch him work.

Alternative if you want to keep a spoken frame: Ilan tells the story to **Prince Aditya**, now king, who has forgotten him. That's a different relationship (lost friendship rather than lost romance), but the shape is still close to the original. Fix B as written is the stronger break.

---

## 2. How does Kayal remember Ilan? (high priority)

The bible says restoring the Mirror erases the restorer "from every memory," and also that Kayal "is the one who chooses to remember him." Those two statements contradict each other unless there's a rule.

**Fix: the Mirror erases memories, not ink.**

- Plant (Ch. 3): in the Bronze Foundry, Kayal shows Ilan the **Keeper's Ledger**, a palm-leaf book listing every past restorer. The murals show heroes with chiselled-blank faces; only the ledger keeps their names. This is how she knew the cost before he did.
- Plant (Ch. 5): in the tower climb, Kayal writes Ilan's name and a description in the ledger: "He casts no shadow now. If you are reading this, you knew him."
- Payoff (epilogue): she doesn't remember him. She reads about him. When she sees a man with no shadow at the temple wall, she recognises him from her own words. "Chooses to remember" becomes literal: she chooses to believe the ledger.
- This also gives Kayal's secret fear ("useless without her father's guidance") a payoff: the ledger is a keeper's real job, and she does it without her father.

---

## 3. What does Kaalavan remember after the rewind?

The epilogue has him "older and quieter," leaving court without a word. If nobody remembers, the player will wonder why.

**Fix:** anyone who **held a shard** keeps a dream-echo: no facts, only a feeling. Kaalavan held shards, so he wakes on the coronation morning with the feeling that he said goodbye to Valli. That is enough to let him leave in peace. Say this in one line of epilogue narration: "Kaalavan woke from a dream he couldn't name. He left court that evening."

---

## 4. Set up Nizhal as final boss earlier

Nizhal's turn starts in Ch. 3 (red flicker) and flips in Ch. 4. For the final boss to land, players need to sense his will before they see it.

- **Ch. 1:** Nizhal moves half a beat late after a Shadow Step, a small idle animation of him "catching up." Easy to miss the first time, obvious on replay.
- **Ch. 2:** during the drowning, before Kayal's arrow, Nizhal could anchor himself and save Ilan, but hesitates. One line: "I wondered what would happen to me if you drowned."
- **Ch. 3:** keep the red flicker.
- **Ch. 4 (gameplay tell):** 1 in 6 Shadow Steps lands a few metres off target, toward a spot Nizhal prefers. Narration: "My shadow had opinions now."

---

## 5. The Ch. 4 "unwinnable" duel

Fights the player is meant to lose tend to feel unfair. Make it a **survival fight with a clear goal**: hold out until the pillars align (about 90 seconds), protecting the last shard pedestal. Kaalavan takes the shard anyway in the cutscene, but the player succeeded at the task they were given.

---

## 6. Small consistency notes

- **Lamp-bearers in a noon-locked city.** Their lamps should be shard-light (violet-white, "un-shadowing" light), not fire. That explains why they kill shadow powers when the sun can't.
- **Statues and shadows.** Statues have no shadows of their own (theirs were torn away), but the prototype lets statues cast shadows, because frozen objects still block the sun. Pick one rule and state it in the bible. Recommended: **stone blocks light like any stone**; only *living* shadows were torn away.
- **Runtime check.** 10 + 35 + 40 + 45 + 45 + 50 = 225 minutes, about 3.75 hours before the epilogue. That matches "about 3 to 4 hours."
- **Tamil names.** Nizhal (shadow), Nizhalars, Kaalavan, and Kalyani stepwell are consistent. "Nizhal Kannadi" (shadow mirror) works well as the Mirror's formal name; keep using it in inscriptions.

---

## 7. New beats added in the screenplay rewrite

These came out of writing the Prologue and Chapter 1 in full. They're already in `docs/scripts/`.

- **The keeper's letter.** In the prologue Ilan carries a palm-leaf letter from Keeper Sendan to the palace. Kaalavan takes it, saying he'll deliver it. At the end of Ch. 1 Ilan finds it half-burnt: *"...do not let the Mirror leave the tower. The minister has asked for..."* In Ch. 2 Kayal recognises her father's handwriting. This gives Ilan's guilt a physical object and makes Kaalavan's plan visible early without a speech.
- **Kaalavan's anklet.** He wears a child's silver anklet tied to his wrist. It's Valli's. Shown without comment in the prologue, Ch. 1 and Ch. 4; in Ch. 5 he unties it and lets it fall into the Mirror when he lets her go.
- **Mason's marks.** Chola masons cut personal marks into the blocks they set. Ilan's father's mark (a crescent with a dot) is the solution to Mayan's door, and it's the shadow-memory Ilan finds in the Mirror itself: his father, still carving.
- **The stone rule.** The curse turns flesh and cloth to stone; metal stays metal. Gold crowns and bells stay bright among the statues, and Aditya's crown becomes the brightest thing in the city.
- **Birds fell.** Pigeons in flight turned to stone and shattered. It's a small, specific image that sells the curse better than a wide shot.

## 8. Period accuracy

The game is set around 1000 CE. Some things in the original bible, and in most "ancient India" art, are anachronistic:

| Don't use | Why | Use instead |
|---|---|---|
| Marigold garlands | Marigolds came from the Americas in the 1500s | Kanakambaram (crossandra, native orange), jasmine, lotus, oleander |
| Chillies, tomatoes, potatoes | New World crops | Black pepper, ginger, rice, ghee, jaggery, plantain, coconut |
| "Kalyani stepwell" look from Gujarat or Rajasthan | Different region and era | Tamil temple tank (kulam) with stepped sides; keep the name |
| Paper scrolls | Not used in Tamil country then | Palm-leaf manuscripts (olai chuvadi) and copper plates |
| Devanagari script | Wrong script for the region | Tamil script, with Grantha for Sanskrit words |

## 9. Visual style change

The story bible specifies "PS2-era low-poly, warm sunset palette." On your direction, the target is now **realistic, AAA-level visuals**. The warm palette and violet shadows carry over, and the full specification is in `docs/art-direction.md`. The bible's image-prompt style suffix is replaced by the one in `art/prompts.md`.
