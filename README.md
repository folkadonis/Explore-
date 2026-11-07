# Shadows of Kanchi

A third-person action-platformer with realistic, AAA-level visuals, set in Vel Nadu, a fictional kingdom inspired by the Chola empire around 1000 CE. A young temple guard shatters the Shadow Mirror, the city turns to stone, and his own living shadow becomes his only guide. The hero's powers only work where shadows fall.

## What's here

| Path | What it is |
|---|---|
| `prototype/index.html` | Playable 3D Chapter 1 slice in the browser (three.js, real-time sun shadows). Open the file, no build step; needs an internet connection to load three.js. |
| `docs/story-bible.pdf` | The original story bible |
| `docs/story-notes.md` | Suggested fixes to the bible (originality, plot holes, setup) |
| `docs/scripts/` | The complete story as screenplays: prologue, five chapters, four Tamil festival interludes and the Pongal epilogue. Start with `docs/scripts/README.md` |
| `docs/tamil-culture.md` | Festivals, games, food, dress and language guide, with period-accuracy rules |
| `docs/art-direction.md` | Visual spec: lighting, palette, architecture, characters, props, avoid list |
| `docs/levels/` | Room-by-room level designs for all five chapters |
| `docs/asset-generation-brief.md` | **What to generate next:** every image, texture and 3D model needed for realistic visuals, with Gemini prompts and GLB specs |
| `art/prompts.md` | Earlier concept art prompts (superseded by the asset brief) |

## Playing the prototype

Open `prototype/index.html` in a browser. The game plays in **landscape**: on a phone, turn it sideways.

| Action | Keyboard | Touch | Gamepad |
|---|---|---|---|
| Run | A / D or ← → | Drag anywhere on the left half of the screen | Left stick or d-pad |
| Jump (hold for higher) | Space or W | JUMP | A |
| Shadow Step | K, E or Shift | STEP (glows when shade is in reach; if nothing is ahead it looks behind you) | X, RB or RT |
| Cut (ropes, enemies) | J or F | CUT (glows when something is in range) | B or Y |

**Guided tutorial:** one objective at a time, shown at the top of the screen with the button to press. The matching touch button pulses. Each objective stays until you've done it, so nothing is missed: run, jump, hold-jump, gap jump, first Shadow Step, Step chains, mid-air Steps, timing a moving shadow, cutting canopies for shade, and escaping the hall.

**Built to feel good:**
- Physics run at a fixed 120 steps per second, so movement is the same on every device.
- Jumps forgive you: a short window after leaving a ledge, a short buffer before landing, and a ledge assist that climbs you onto a ledge you nearly made.
- Step is buffered: press it a moment early and it fires as soon as shade comes into reach.
- Cut turns you toward the nearest shadow so it never misses.
- A fall puts you back at the edge you jumped from, in under a second.
- Freeze-frames, camera kicks, sound and vibration on Steps, hits and pickups.
- On slower phones, resolution adjusts automatically to keep the frame rate smooth.

**Replay value:** 8 shadow-memories are hidden on the route; several hang over gaps, so you grab them mid-jump and Step to safety. Your best time is saved on your device.

**The rule:** Shadow Step teleports you into a shadow ahead, up to about 9.5 m away. The violet ghost shows where you'll land. In full sun with no shadow in reach, you're an ordinary man and can only run and jump.

**How shade works:** the game computes shade from the same sun the renderer uses, so any violet-blue shade you see on the walkway is shade you can step into. Reachable patches glow faintly.

**After Chapter 1: Interlude I, jallikattu.** A playable memory of Mattu Pongal. It uses **one action: tap anywhere** (or Space).
1. **Grab:** tap as the gold ring closes on the bull's hump. Time slows as he reaches you, and tapping early is forgiven.
2. **Ride:** tap each time the ring on the right closes, as his hooves land. You have three grips; a missed beat costs one, and every streak of 5 wins one back.
3. **Cloth:** when he drops his head, tap to take the coin cloth.

Each retry widens the timing window, and Captain Veeran gives a tip. After three tries the memory moves on, so nobody gets stuck.

**The slice covers:** waking on the temple steps, learning Shadow Step, the frozen elephant procession, a swinging banner timing jump, the canopy courtyard puzzle, the coronation hall chase, and the end beat with Prince Aditya.

## Music

The game has its own original score, generated live in the browser (no audio files). Each scene has a raga and its own instruments:

| Scene | Raga | Instruments |
|---|---|---|
| Title and opening | Kalyani (grand, royal) | Tanpura, veena, nadaswaram, kombu horn fanfare |
| The stopped city | Shubhapantuvarali (grief, stillness) | Tanpura, sparse veena with gamakas |
| Hall chase | Shanmukhapriya (urgent) | Tanpura, nadaswaram, fast thavil |
| Jallikattu | Mohanam (bright, festive) | Tanpura, nadaswaram, thavil, parai |
| Ending | Shubhapantuvarali, slower | Tanpura, veena |

Copyrighted film soundtracks (such as *Ponniyin Selvan*) can't be included. Licensed recordings you own the rights to can be dropped in later as audio files.

## Next steps

- Generate concept art once there are Higgsfield credits (`art/prompts.md`).
- Decide on the frame-story and memory fixes in `docs/story-notes.md`.
- Build the vertical slice in Unreal Engine 5, using `docs/art-direction.md` as the visual spec.
