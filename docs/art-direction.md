# Art direction: Shadows of Kanchi

**Target:** modern AAA realism. Physically based materials, real-world scale, film-style lighting. This replaces the bible's "PS2-era low-poly" style.
**Engine assumption:** Unreal Engine 5 (Lumen, Nanite, Virtual Shadow Maps) or an equivalent. The browser prototype only approximates this; see "What the prototype shows" at the end.

---

## 1. The one rule that defines the look

**The sun is stuck at noon, and shade is the only safe place.**

Every image is built on that contrast:

- **Sunlit stone:** hot, slightly bleached and warm. Shadows are hard-edged because the sun is a small, high disc.
- **Shade:** deep blue-violet, never black. It gets its colour from a sky that the curse has bruised violet at the zenith.
- **The player reads shade as space they can move into.** Gameplay shadows must never be faked or painted. If it looks like shade, it must be shade.

Sun: elevation 64°, azimuth fixed per level, colour about 4,300 K (warm from the dust haze), intensity about 100,000 lux at the start of the curse.
Sky: horizon peach-gold, falling to rose at 20°, to violet-grey at the zenith. Thin, still cirrus that never moves.

---

## 2. Palette

| Role | Hex | Use |
|---|---|---|
| Sunlit granite | `#B59C86` | Most architecture in direct light |
| Granite in shade | `#4A3F55` | Same stone, shaded; the violet comes from the sky fill |
| Mirror Temple granite | `#2A2430` | Darker charnockite; only the Mirror Temple |
| Haze | `#C4906C` | Distance fog and the dust layer over the lower city |
| Zenith violet | `#3F2E5E` | Upper sky; the curse's colour |
| Gold (metal stays metal) | `#D9A441` | Crowns, bells, kalashas, finials |
| Shard violet | `#A78BFA` | Nizhal's eyes, shard glow, Shadow Step, HUD. Nothing else may use it |
| Nizhalar ember | `#FF4F7A` | Hostile shadow eyes only |
| Coronation red | `#8E1A1F` | Tiger banners, Ilan's sash |
| Saffron silk | `#D98A1C` | Canopies |

**Violet is a gameplay colour.** If something is violet, it is part of the shadow system. Don't use violet flowers, clothing or decoration anywhere.

---

## 3. Architecture

**Real references (shoot these, or buy photogrammetry):**

| Building | Use it for |
|---|---|
| Brihadeeswarar Temple, Thanjavur (1010 CE) | The Mirror Temple's profile: a 13-tier pyramidal vimana, granite, about 66 m |
| Gangaikonda Cholapuram | Softer, curved vimana silhouettes for the skyline |
| Airavatesvara Temple, Darasuram | Pillar carving, chariot-wheel plinths, steps with musical stones |
| Kailasanathar Temple, Kanchipuram | Sandstone weathering, rows of miniature shrines along parapets |
| Mahamaham tank, Kumbakonam | The stepwell (Ch. 2) should be a **temple tank** (kulam) with stepped sides. "Kalyani" is the Karnataka term; keep it as the name, but base the look on Tamil tanks |

**Construction details to get right:**

- **Adhishthana (plinth):** every terrace and temple base sits on a moulded plinth. From bottom to top: upana (plain foot), jagati (flat band), kumuda (round torus), kantha (recessed neck), pattika (flat band). The prototype extrudes this profile along every terrace front.
- **Vimana tiers:** each tier is ringed with miniature shrines: square kutas with domed roofs at the corners, oblong salas with barrel vaults between them.
- **Pillars:** square base, then alternating square and octagonal shaft sections, a pot-shaped capital (kalasa), a square plate (phalaka), and curled corbel brackets (potika). Monolithic: one stone per pillar, never stacked bricks.
- **Masonry:** large dressed ashlar, 0.6 to 1 m courses, very fine joints (Chola masons used almost no mortar). Mason's marks are cut into some blocks: fish, lamp, conch, crescent-with-dot.
- **Inscriptions:** Tamil script in long horizontal bands around plinths, with Grantha letters for Sanskrit words. Never Devanagari.

**Wear:**
- Granite is hard: weathering shows as dark vertical rain streaks below cornices, lichen in north-facing joints, and polished patches where hands and feet have touched for centuries. No crumbling.
- Lime-washed houses in the lower city: patchy whitewash over brick, ochre bands at the base, terracotta half-round roof tiles.

---

## 4. The stone rule (how the curse looks)

**The curse turns flesh and cloth to stone. Metal stays metal.**

- People and animals become **fine-grained pink-grey granite**, matched to the local stone, with the folds of their clothes carved into it. Not grey plaster.
- Gold, bronze, brass and iron stay bright: crowns, earrings, anklets, elephant bells, lamp stands, swords. This makes every frozen scene sparkle in the right places and draws the eye to Aditya's crown.
- Flames, steam, thrown rice and falling water **stop where they were**, as solid, translucent shapes. Lamp flames keep their light (frozen emissive), which is why the hall is lit.
- Birds in flight fell and shattered. Leave stone pigeon fragments on rooftops and steps.

---

## 5. Characters

General: realistic proportions (heads are 1/7.5 of height), skin with subsurface scattering, period-correct cloth simulation. Reference for costume: Chola bronzes and the Brihadeeswarar fresco cycle.

### Ilan (20)
- 1.75 m, wiry climber's build: forearms and shoulders, not a bodybuilder.
- Dark brown skin, sun-darkened on the shoulders. Short beard stubble. Hair long and tied in a side topknot (kondai).
- **Costume:** cotton veshti tied as a kacham (tucked between the legs for movement), mid-thigh; red silk waist sash with a short tail; bare chest; leather wrist wraps; small gold ear studs.
- **Armband:** hammered bronze on the right upper arm. After Ch. 1 the shard sits in it, black glass with a faint violet core that brightens when shade is in reach.
- **Weapon:** a short, slightly curved blade (about 50 cm) in a leather scabbard at the left hip. It's a guard's tool, not a hero's sword.
- **Animation:** quick, light, a little showy in Ch. 1 to 2; economical and protective by Ch. 5.

### Nizhal
- Ilan's exact silhouette and proportions. Not a monster.
- **Material:** a volume of black smoke that holds a body's shape. The edges dissolve and re-form, and fine particles drift up off the shoulders. There is no surface detail at all.
- **Eyes:** two violet lights with no pupils. Turn to ember red as he turns (Ch. 3 onward).
- **Rim light:** a thin violet fresnel rim so he reads against dark backgrounds.
- **Movement:** mirrors Ilan's animation set, but a quarter-beat early and a little looser. When idle he does things Ilan wouldn't: leans, picks at stone, watches people.

### Nizhalars (enemy shadows)
- The torn shadows of ordinary people: the same smoke material, but stretched about 15% taller and stooped, as if still lying on the ground at an angle.
- Ember-red eyes. They trail smoke against their direction of travel.
- **Lamp-bearers** (Ch. 4) carry a bronze lamp with a violet-white shard flame that cancels shade in a 4 m radius.

### Kayal (19), for Ch. 2 onward
- 1.62 m. Practical draped cotton in indigo with a narrow gold border, tied for climbing; jasmine in a long braid; a palm-leaf satchel; a short composite bow.
- She looks like an archivist who climbs, not a fantasy archer: ink stains on two fingers, a stylus behind her ear.

### Kaalavan (55)
- 1.8 m, heavy-shouldered, grey beard trimmed close. Fine silk angavastram, gold rings on three fingers, a rod of office in bronze.
- **The anklet:** a child's silver anklet with tiny bells, tied to his left wrist with thread. Show it in every appearance.
- In Ch. 4 to 5, shards orbit him slowly, each showing a moving shadow inside.

---

## 6. Key props

| Prop | Real reference | Notes |
|---|---|---|
| Kuthuvilakku (oil lamp) | Tamil bronze standing lamp, 5 wicks | Flames frozen mid-flicker; real light source in interiors |
| Thavil, nadaswaram | Temple music instruments | Played in the prologue; stone afterwards |
| Sangu (conch) | Valampuri conch | Sounds once in the prologue; never again until the epilogue |
| Kalasam | Gold finial pots on temple roofs | Always gold |
| Palm-leaf letter | Olai chuvadi: leaves cut with a stylus, ink rubbed in | The keeper's letter is tied with red thread |
| Coronation crown | Tall conical gold mukuta | Plain, one carved tiger. Not jewelled like a Mughal crown |
| Tiger banner | The Chola tiger (puli) emblem | Red silk, gold couched-thread tiger, green and gold borders |
| Silk canopy | Saffron silk, red and green border bands | Rolled on poles until noon |

---

## 7. Avoid list

These break period, place or tone. Reject any concept art that includes them.

- **Anachronisms:** marigolds (arrived in the 1500s; use kanakambaram for orange and jasmine for white); chillies, tomatoes, potatoes; tea; paper books (palm leaf only); turbans in the Rajput style; Mughal domes, onion domes, pointed arches, jharokha balconies; muskets.
- **Generic "fantasy India":** snake charmers, belly-dancer costumes, sequins, Bollywood glitter, Taj Mahal silhouettes, Hindi signage.
- **Tone:** gore, skulls, grimdark rot. The curse is still and sad, not horrific.
- **Look:** cel-shading, low-poly, plastic-looking stone, oversaturated colour, lens flares everywhere, bloom on everything.

---

## 8. Camera and lenses

- **Gameplay:** third-person, about 4.5 m behind and 1.2 m above Ilan, 38° vertical FOV. In 2.5D sections (like the prototype), a side camera at 14 m.
- **Cutscenes:** use real focal lengths. 24mm for scale shots of towers; 50mm for dialogue; 85mm with shallow depth of field for emotional close-ups (Aditya scene). Mostly static or slow cranes; handheld only during the shattering.
- **Letterbox:** 2.39:1 bars for cutscenes, animated in over 0.8 s.

---

## 9. What the prototype shows

The browser prototype (`prototype/index.html`) is a **look and gameplay test**, not final art. It runs in real time on a phone with no downloaded assets, so everything is generated by code.

**It does get right:**
- the lighting model: a single fixed sun, real-time shadows, violet sky fill and dust haze;
- that gameplay shade is computed from the same sun the renderer uses;
- Chola architectural vocabulary, built procedurally: moulded plinths, vimana tiers ringed with miniature shrines, monolithic pillars with corbels, gopurams with kalasha rows;
- procedural granite, ashlar and flagstone textures with normal and roughness maps;
- the stone rule (granite figures, gold left as gold), frozen lamp flames and hanging dust.

**It can't do (needs the real engine):**
- scanned or sculpted characters, faces and cloth simulation;
- global illumination and ambient occlusion;
- carved relief detail, inscriptions and mason's marks;
- film-quality depth of field and motion blur.
