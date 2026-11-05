# Shadows of Kanchi

A third-person action-platformer with realistic, AAA-level visuals, set in Vel Nadu, a fictional kingdom inspired by the Chola empire around 1000 CE. A young temple guard shatters the Shadow Mirror, the city turns to stone, and his own living shadow becomes his only guide. The hero's powers only work where shadows fall.

## What's here

| Path | What it is |
|---|---|
| `prototype/index.html` | Playable 3D Chapter 1 slice in the browser (three.js, real-time sun shadows). Open the file, no build step; needs an internet connection to load three.js. |
| `docs/story-bible.pdf` | The original story bible |
| `docs/story-notes.md` | Suggested fixes to the bible (originality, plot holes, setup) |
| `docs/scripts/` | Full screenplays for the Prologue and Chapter 1 |
| `docs/art-direction.md` | Visual spec: lighting, palette, architecture, characters, props, avoid list |
| `docs/levels/` | Room-by-room level designs for all five chapters |
| `art/prompts.md` | Concept art prompts, ready to generate |

## Playing the prototype

Open `prototype/index.html` in a browser. On a phone, turn it sideways.

| Action | Keyboard | Touch |
|---|---|---|
| Move | A / D or ← → | ◀ ▶ |
| Jump | Space or W | Jump |
| Shadow Step | K or Shift | Step |
| Cut (ropes, enemies) | J | Cut |

**The rule:** Shadow Step teleports you into a shadow ahead, up to about 9.5 m away. The violet ghost shows where you'll land. In full sun with no shadow in reach, you're an ordinary man and can only run and jump.

**How shade works:** the game computes shade from the same sun the renderer uses, so any violet-blue shade you see on the walkway is shade you can step into. Reachable patches glow faintly.

**The slice covers:** waking on the temple steps, learning Shadow Step, the frozen elephant procession, a swinging banner timing jump, the canopy courtyard puzzle, the coronation hall chase, and the end beat with Prince Aditya.

## Next steps

- Generate concept art once there are Higgsfield credits (`art/prompts.md`).
- Decide on the frame-story and memory fixes in `docs/story-notes.md`.
- Build the vertical slice in Unreal Engine 5, using `docs/art-direction.md` as the visual spec.
