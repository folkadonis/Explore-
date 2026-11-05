# Level designs

One file per chapter, made from the level-design prompt in the story bible.

**Collectible used in every chapter: shadow-memories.** Each is a faint violet echo hidden off the main path. Touching one plays a 5-second memory of a frozen citizen and teaches Ilan their name. Named statues later get a line from Ilan when he passes them, which ties the collectible to his arc ("ordinary people matter"). There's one per chapter in these drafts; the final game can add more.

**Power teaching rule** (bible pillar 4): each chapter teaches its new power safely, then makes you practise it, then tests it combined with every earlier power.

| Chapter | Region | New power | Rooms | Boss |
|---|---|---|---|---|
| [1](chapter-1.md) | Royal Palace | Shadow Step | 10 | Hall escape (set piece) |
| [2](chapter-2.md) | Kalyani Stepwell | Shadow Anchor | 11 | Stepwell Serpent |
| [3](chapter-3.md) | Bronze Foundry | Shadow Strike | 11 | Bronze Colossus |
| [4](chapter-4.md) | Thousand-Pillar Hall | Light Bend | 10 | Kaalavan's projection (survival) |
| [5](chapter-5.md) | Mirror Temple | Eclipse | 12 | Nizhal |

**Player metrics** (measured in the prototype; design every gap against these)

| Metric | Value | Design rule |
|---|---|---|
| Height | 1.75 m | Doorways ≥ 2.2 m; crawlspaces don't exist |
| Run speed | 6.2 m/s | A 30 m sunlit run takes about 5 s, long enough to feel exposed |
| Jump height | 1.5 m | Ledges ≤ 1.3 m are jumpable; 1.4 to 1.6 m need a grab |
| Jump distance (flat) | 3.9 m | Jumpable gaps ≤ 3.4 m; "too far" gaps ≥ 4.5 m. Nothing between, so the player never has to guess |
| Shadow Step range | 9.5 m | Step gaps 6 to 8 m, landing shade ≥ 0.6 m wide |
| Step cooldown | 0.45 s | Two Steps in a row need about half a second |
| Sun | elevation 64°, fixed | A caster of height *h* throws shade about 0.32·*h* forward along the walkway |

**Light rules that hold everywhere**
- The sun is fixed at noon, slightly west, so shadows always lean the same way. Players learn to read direction once.
- Violet floor tint marks a usable shadow. Warm stone marks sun. Never use violet for anything else.
- Shard-light (Lamp-bearers, Ch. 4 mirrors) is violet-white and cancels shadows. Furnace glow (Ch. 3) is orange and cancels shadows.
