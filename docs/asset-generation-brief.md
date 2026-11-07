# Shadows of Kanchi: asset generation brief

This document lists **every image, texture and 3D model** needed to replace the game's code-generated placeholders with realistic assets. Each entry has an ID, a priority, the exact format, a ready-to-paste prompt, and the technical rules I need to load it into the game.

**How to use it**

1. Generate the **Priority 1 (P1)** assets first. They cover everything currently playable: Chapter 1 and the Jallikattu interlude.
2. Keep the **ID at the start of every file name**, for example `ANI-01_vellaiyan.glb` or `TEX-02_flagstone.jpg`.
3. Upload them back into this chat in batches. I'll wire each one into the game as it arrives; anything missing keeps its current placeholder, so nothing breaks.

The game is **vertical (9:16)**. All key art and scene references are portrait. Textures are square, skies are 2:1 panoramas.

---

## Contents

1. [Pipeline: which tool makes what](#1-pipeline-which-tool-makes-what)
2. [Global style blocks (paste into every prompt)](#2-global-style-blocks)
3. [Realism guide: background, bull, people, crowd](#3-realism-guide)
4. [Technical rules for 3D models (GLB)](#4-technical-rules-for-3d-models-glb)
5. [Master asset list](#5-master-asset-list)
6. [Prompts: reference images](#6-reference-images-ref)
7. [Prompts: skies and background layers](#7-skies-and-background-layers-sky-bg)
8. [Prompts: textures and decals](#8-textures-tex-and-decals-dec)
9. [Prompts: animals](#9-animals-ani)
10. [Prompts: hero and named characters](#10-hero-and-named-characters-chr)
11. [Prompts: crowd and statues](#11-crowd-and-statues-crw)
12. [Prompts: architecture](#12-architecture-arc)
13. [Prompts: props](#13-props-prp)
14. [Prompts: UI art](#14-ui-art-ui)
15. [Priority 2: later chapters](#15-priority-2-later-chapters)
16. [Optional: audio](#16-optional-audio)
17. [Delivery checklist](#17-delivery-checklist)

---

## 1. Pipeline: which tool makes what

| Output | Make it with | Notes |
|---|---|---|
| Reference images, skies, background layers, textures, decals, UI art | **Gemini image generation**, directly | Ask for the largest size available |
| 3D models (`.glb`) | **Step 1:** Gemini makes a *3D reference sheet* image (prompt given). **Step 2:** turn the image into a 3D model with an image-to-3D tool: Meshy, Tripo3D, Hunyuan3D-2, Rodin, or Higgsfield's 3D generator (already connected here; needs credits). **Step 3:** export as `.glb` | Gemini can't output 3D files itself |
| Animated people (Ilan, Kayal and other named characters) | After step 2, upload to **Mixamo** (free): auto-rig, then download the listed animations. Convert FBX to GLB in Blender (*File → Export → glTF 2.0*) | Mixamo needs the character in A-pose or T-pose: the reference prompts ask for this |
| Animated bulls | Image-to-3D, then **animal auto-rigging**: Meshy's or Tripo's animation tools, or Anything World | If you can't rig them, see the bull fallback in section 9 |
| Crowd, statues, buildings, props | Image-to-3D only. **They don't move**, so no rigging | Each crowd pose is its own static model |

---

## 2. Global style blocks

Paste the right block at the end of every image prompt. They keep every asset in one consistent world.

### Style A: "The stopped noon" (Chapter 1, the cursed city)
```
Photorealistic, AAA video game quality, Unreal Engine 5 cinematic look, physically based materials, 11th-century Chola-dynasty South India, Kanchipuram, dressed pink-grey granite architecture, the sun frozen high at noon casting short hard shadows tinted blue-violet, warm golden dust haze in the air, bleached pale sky fading to bruised violet at the zenith, dust motes hanging motionless, people and animals turned to fine-grained granite while all gold, bronze and brass stays bright metal, film grain, natural colour grading, no text, no watermark
```

### Style B: "Pongal memory" (Jallikattu interlude and epilogue)
```
Photorealistic, AAA video game quality, Unreal Engine 5 cinematic look, physically based materials, an 11th-century Tamil village on the morning of Mattu Pongal in the month of Thai (mid-January), low warm golden sunrise light from the east with long soft shadows, woodsmoke and dust hanging in the light, clear pale-blue sky, red-earth ground, coconut palms, everyone alive and moving, documentary realism, film grain, natural colour grading, no text, no watermark
```

### Style C: "3D reference sheet" (for anything that becomes a GLB)
```
3D modelling reference sheet, four views in one row: front, left side, back, three-quarter, orthographic, full body or full object in frame with nothing cropped, plain flat light-grey background, even soft studio lighting with no cast shadows, true-to-life proportions and real-world scale, photorealistic PBR textures, neutral expression, no text, no labels, no grid lines
```
For people add: `standing in A-pose with arms straight at 45 degrees from the body, feet shoulder-width apart, palms facing down`.

### Negative prompt (use for everything)
```
cartoon, anime, cel-shaded, low-poly, stylised, plastic skin, waxy skin, oversaturated, fantasy armour, Mughal architecture, onion dome, pointed arch, jharokha balcony, Rajput turban, Taj Mahal, Hindi or Devanagari text, Bollywood costume, sequins, neon colours, marigold flowers, chillies, tomatoes, potatoes, cashews, modern clothing, plastic, tarmac, electric lights, Spanish bullfight, matador, cape, blood, injured animal, Holstein cow, extra fingers, deformed hands, duplicate figures, blurry face, watermark, signature
```

---

## 3. Realism guide

This section describes how things must look. Every prompt below is written from it.

### 3.1 Background and environment

**Two worlds, two lights.**

| | The stopped noon (Chapter 1) | Pongal memory (Jallikattu) |
|---|---|---|
| Sun | Fixed at about 64° elevation, slightly west. Hard, small, white-gold | Low in the east, about 25° elevation. Warm, golden |
| Shadows | Short, hard-edged, tinted **blue-violet** (gameplay depends on reading them) | Long, soft-edged, cool blue-grey |
| Sky | Pale peach at the horizon, rose at mid-height, bruised violet at the zenith; thin still cirrus | Clear pale blue, warm at the horizon, a few morning clouds |
| Air | Thick golden dust haze; distant towers fade to silhouettes; nothing moves | Woodsmoke from Pongal fires, dust kicked up by cattle; birds |
| Mood | Silent, beautiful, wrong | Loud, crowded, joyful |

**Depth layers for a vertical screen.** A vertical frame shows far more sky and ground than a wide one, so every scene needs strong **foreground / midground / background** separation:

- **Foreground (0–5 m):** the walkway the player runs on: granite terraces, flagstones, the arena earth. Crisp detail: chisel marks, worn edges, petals, hoof prints.
- **Midground (5–40 m):** frozen crowds, elephants, pillared halls, the arena barricades and cart platforms. Clear silhouettes.
- **Background (40 m to the horizon):** temple towers (vimanas and gopurams) rising out of haze, the lower city's terracotta roofs and coconut palms, and in Chapter 1 the black Mirror Temple dominating the sky. Low contrast and soft.
- **Below the terraces (Chapter 1 only):** looking down through the gaps, the lower city at roughly 30 m below, half lost in dust haze. This gives the vertical frame its sense of height.

**Materials must read as real.** Granite has visible crystals, fine joints and dark rain streaks under cornices. Wood is grey, cracked and sun-bleached. Lime plaster is patchy over brick. Red earth is swept, with broom marks and hoof prints. Gold is worn bright on edges.

**Architecture references:** Brihadeeswarar Temple (Thanjavur), Gangaikonda Cholapuram, Airavatesvara Temple (Darasuram), Kailasanathar Temple (Kanchipuram). Full rules in `docs/art-direction.md`.

### 3.2 The bull

The bull is the star of the Jallikattu interlude. It must look like a real Tamil native bull, never a Western one.

**Anatomy (zebu, *Bos indicus*):**
- **Hump (*thimil*):** a large, muscular hump over the shoulders, the thing the player holds. It must be big, rounded and clearly graspable: about a third of the shoulder height on a mature bull.
- **Dewlap:** a deep fold of loose skin hanging from the throat to the chest, swinging when it moves.
- **Build:** long legs, a deep chest, narrow hips, a long tail with a black switch. Lean and athletic, not heavy like a beef breed.
- **Head:** long and narrow, with a convex forehead, large dark eyes, short ears held sideways, and a moist dark muzzle.
- **Size:** about 1.4 m at the hump, about 2.3 m nose to tail-root, roughly 400–500 kg.

**The three bulls:**

| ID | Name | Breed | Coat | Horns | Temperament (animation) |
|---|---|---|---|---|---|
| ANI-01 | Vellaiyan | **Kangayam** (Kongu region) | Grey-white; males darker grey over the hump, neck and forequarters, fading to white | Long, sweeping up and outward | Calm; charges straight; easy bucks |
| ANI-02 | Karuppan | **Pulikulam** (Madurai and Sivaganga) | Dark grey to near-black, short and glossy | Short, curving forward | Small, fast, spins; switches direction mid-buck |
| ANI-03 | Sivappan | Royal herd, mixed native line | Deep red-brown, darker on the hump and neck | Long, lyre-shaped, painted gold | Huge, slow walk-out, then explosive; bucks in pairs |

**Festival decoration (all three):**
- **Horns painted** in bands: red and blue for Vellaiyan, blue and white for Karuppan, gold for Sivappan. **Brass caps** (*kombu kuppi*) on the horn tips.
- A **garland** of orange kanakambaram and white jasmine around the neck.
- A string of small **brass bells** on a leather or cotton cord at the throat.
- The **coin cloth** (*salli*): a small red cloth bundle of coins tied between the horns. This is the prize.
- Optional: a dab of turmeric and red kumkum on the forehead.
- **Never:** wounds, blood, ropes cutting skin, sticks or spears, a matador or cape, or Western rodeo gear (saddles, flank straps, bull-riding vests).

**How it must move** (animation list in section 9): heavy, real weight. The hump and dewlap jiggle; the head swings low before a toss. In a buck the front leaves the ground and the hind legs kick out. In a spin the bull pivots on its front legs. Dust rises on every hoof-fall.

### 3.3 People

- **Ethnicity:** Tamil (Dravidian South Indian). Skin from medium brown to deep brown, sun-darkened on shoulders and faces. Black hair, often oiled; greying in elders.
- **Bodies:** working people, lean and wiry, with farmers', herders' and potters' hands. Some soft middle-aged bellies, some thin elders. Not gym physiques, not models.
- **Men:** cotton **veshti** (white or off-white with a narrow coloured border), worn long or tucked up between the legs (*kacham*) for work and the arena; bare chest or a cotton cloth over the shoulder (*thundu*); long hair tied in a knot (*kondai*), or a cloth tied around the head for the bull tamers; moustaches common; ear studs; sacred ash or sandal paste on the forehead on festival days.
- **Women:** draped cotton sari in natural dyes (madder red, indigo, turmeric yellow, leaf green, off-white with borders), worn **without a stitched blouse** in this period: the drape covers the upper body. Long oiled braid with **jasmine**; gold or brass earrings and nose stud; glass or brass bangles; anklets with bells; a married woman's **thali** on a yellow thread.
- **Children:** bare-chested boys in small veshtis; girls in small skirts and drapes, jasmine in their hair; everyone barefoot.
- **Expressions:** loud, real, mid-shout, laughing, wincing as a tamer falls. Never posed or smiling at the camera.

### 3.4 The crowd

The jallikattu crowd has to feel like a whole district came to watch.

- **Where they are:** standing and sitting on **stacked bullock carts and timber platforms** behind the woven palm-leaf barricade, three or four rows deep, rising toward the back. Boys climbing the barricade posts. Elders under a canopy on the **elders' platform**. Women and children together on one section of the carts.
- **What they're doing:** cheering with arms up, whistling with fingers in mouths, clapping, pointing, leaning over the rail, children on fathers' shoulders, one or two people looking away (talking, eating sugarcane). **Variety matters more than detail.**
- **Colours:** mostly off-white cotton, with about 30% coloured cloth in natural dyes (red, indigo, yellow, green), with gold glints from jewellery. Never neon.
- **Density:** about 150–250 people visible along a 45 m arena.
- **How the game builds it:** 10 different **static posed** crowd models (CRW-01 to CRW-10), each repeated with random rotation, scale and cloth colour. That's why each crowd model must be a single person in a clear pose, with all their cloth as one material.
- **The same models become statues** in Chapter 1: the game re-renders them in granite. No separate statue models needed, except a few specific frozen moments (section 11).

---

## 4. Technical rules for 3D models (GLB)

Please check every `.glb` against this list before uploading. If a tool doesn't let you control something, do what you can and tell me; I can fix scale, orientation and pivots in code.

| Rule | Value |
|---|---|
| Format | glTF 2.0 binary, `.glb`, with **textures embedded** |
| **Compression** | **None.** No Draco, no KTX2/Basis, no meshopt. The game page can't load decoders |
| Units and scale | **Metres, real-world size** (a man about 1.70–1.78 m, a bull about 1.4 m at the hump) |
| Up axis | **+Y up** |
| Facing | Characters and animals **face +Z** (glTF default "forward") |
| Pivot / origin | On the **ground**, centred between the feet (people) or the four hooves (animals). Buildings: centre of the base |
| Materials | PBR metallic-roughness. **One material per model** if possible (two maximum: body plus metal ornaments) |
| Texture size | Hero characters and bulls: 2048 × 2048. Crowd, props, buildings: 1024 × 1024. JPG for colour, PNG only if it needs transparency |
| Triangle budget | Hero character ≤ 25,000 · bull ≤ 20,000 · named extra ≤ 12,000 · crowd person ≤ 6,000 · prop ≤ 4,000 · building ≤ 30,000 |
| File size | ≤ 8 MB per file (crowd ≤ 2 MB) |
| Rig (animated models only) | Mixamo standard skeleton for people; any clean skeleton for bulls. **Bake animations into the GLB**, named exactly as listed |
| Animations | Loopable cycles must start and end on the same pose. In-place (no root motion): the game moves the character |

---

## 5. Master asset list

**P1** = needed for what's playable now. **P2** = later chapters (section 15).

| ID | Asset | Type | Size / format | Priority |
|---|---|---|---|---|
| REF-01 | Palace terraces at the stopped noon | Image | 1080 × 1920 PNG | P1 |
| REF-02 | Coronation hall, frozen feast | Image | 1080 × 1920 | P1 |
| REF-03 | Jallikattu arena, wide | Image | 1080 × 1920 | P1 |
| REF-04 | Bull bursting from the gate | Image | 1080 × 1920 | P1 |
| REF-05 | Crowd on the carts | Image | 1920 × 1080 | P1 |
| REF-06 | Material and colour board | Image | 2048 × 2048 | P1 |
| SKY-01 | Stopped-noon sky panorama | Image | 4096 × 2048 equirect | P1 |
| SKY-02 | Pongal-morning sky panorama | Image | 4096 × 2048 equirect | P1 |
| BG-01 | Kanchi skyline layer | Image | 4096 × 1024, green screen | P1 |
| BG-02 | Lower city rooftops and palms layer | Image | 4096 × 1024, green screen | P1 |
| BG-03 | Sevvappur village layer | Image | 4096 × 1024, green screen | P1 |
| TEX-01 … TEX-17 | Tileable textures | Image | 2048 × 2048 seamless | P1 |
| DEC-01 … DEC-03 | Decals (kolams, mason's marks) | Image | 2048 × 2048, black background | P1 |
| ANI-01 … ANI-03 | Three bulls | GLB, rigged and animated | see section 9 | P1 |
| ANI-04 | Temple elephant (frozen) | GLB, static | | P1 |
| CHR-01 | Ilan, 20 | GLB, rigged and animated | | P1 |
| CHR-02 | Ilan, 16 (jallikattu) | GLB, rigged and animated | | P1 |
| CHR-03 | Prince Aditya, 20, crowning pose | GLB, static | | P1 |
| CHR-04 | Prince Aditya, 16 | GLB, static, 2 poses | | P1 |
| CHR-05 | Captain Veeran | GLB, rigged | | P1 |
| CHR-06 | Village headman | GLB, static | | P1 |
| CHR-07 | Parai drummer | GLB, rigged (one loop) | | P1 |
| CRW-01 … CRW-10 | Crowd people, posed | GLB, static | | P1 |
| CRW-11 … CRW-14 | Specific Chapter 1 statues | GLB, static | | P1 |
| ARC-01 … ARC-09 | Architecture | GLB, static | | P1 |
| PRP-01 … PRP-15 | Props | GLB, static | | P1 |
| UI-01 … UI-04 | Key art, icon, loading, chapter cards | Image | | P1 |

---

## 6. Reference images (REF)

These lock the look. I use them to tune lighting, haze and colour, and you can feed them back into the image-to-3D tools as style references.

### REF-01: Palace terraces at the stopped noon (vertical)
```
Vertical 9:16 game scene, side-on view across a run of broken granite palace terraces separated by deep gaps, a young South Indian temple guard in a red waist sash and white veshti crouched at the edge of the nearest terrace about to leap, beside him his living shadow: a black smoke figure with glowing violet eyes; on the next terraces temple elephants turned to granite with bright gold bells and forehead plates, frozen celebrants in granite with raised arms; deep blue-violet shade pooled under the elephants' bellies; far below through the gaps a lower city of lime-washed houses with terracotta roofs and coconut palms sinking into golden dust haze; in the background a 13-tier black granite temple tower dominating the sky with black glass shards hanging motionless around its summit; terrace fronts carved with Chola moulded plinth bands
```
*+ Style A + negative prompt*

### REF-02: Coronation hall, frozen feast (vertical)
```
Vertical 9:16 interior of a long Chola pillared hall in dim warm light, monolithic granite pillars with octagonal shafts and curled corbel brackets, a coronation feast on plantain leaves along the floor, steam frozen in solid glassy curls above heaps of white rice, granite servers frozen mid-pour with a thread of golden ghee hanging unbroken in the air, five-wicked bronze standing oil lamps with frozen still flames still glowing, strings of jasmine and orange kanakambaram between pillars, tall stooped shadow creatures of black smoke with ember-red eyes peeling off the walls toward a young man in a red sash
```
*+ Style A + negative prompt*

### REF-03: Jallikattu arena, wide (vertical)
```
Vertical 9:16 high wide view of a village jallikattu arena on Mattu Pongal morning: a long lane of swept red earth between timber barricades with woven coconut-palm-leaf panels, packed crowds three rows deep standing on stacked bullock carts behind the barricade, an elders' platform with a cloth canopy, the narrow timber bull gate (vaadivaasal) with a thatched roof, mango-leaf strings and whole banana plants tied on both sides, sugarcane stalks leaning on the posts, two parai drummers on a cart, rice-flour kolam patterns on the ground, Pongal clay pots steaming on three-stone hearths outside thatched houses, coconut palms behind
```
*+ Style B + negative prompt*

### REF-04: Bull bursting from the gate (vertical)
```
Vertical 9:16 low-angle action shot: a grey-white Kangayam bull with a huge hump bursting out of a narrow timber bull gate at full charge, horns painted in red and blue bands with brass tips, a red cloth coin bundle tied between the horns, kanakambaram and jasmine garland and brass bells at the neck, dust exploding from its hooves, a lean 16-year-old Tamil youth in a tucked-up white veshti mid-leap reaching for the hump, the crowd behind the palm-leaf barricade roaring, motion blur on the dust only, the bull sharp
```
*+ Style B + negative prompt*

### REF-05: The crowd on the carts (horizontal detail)
```
Wide 16:9 documentary photograph of a Tamil village crowd at a jallikattu on Mattu Pongal, standing three rows deep on stacked wooden bullock carts behind a woven palm-leaf barricade, men in white cotton veshtis bare-chested or with a cloth over the shoulder, some with cloth tied around their heads, women in cotton saris in madder red, indigo and turmeric yellow worn without blouses as drapes, jasmine in their braids, children on fathers' shoulders, people cheering, whistling with fingers, pointing, one man eating sugarcane, elders seated under a canopy, every face different, natural morning light
```
*+ Style B + negative prompt*

### REF-06: Material and colour board
```
Square material reference board, 12 flat swatches in a 4 by 3 grid on a neutral grey card: sunlit pink-grey granite ashlar, the same granite in blue-violet shade, dark charnockite with rain streaks, worn granite flagstone, granite human figure surface showing carved cloth folds, bright gold bell next to grey granite, swept red earth with hoof prints, lime-washed plaster over brick, terracotta roof tile, coconut-palm thatch, woven palm-leaf panel, sun-bleached cracked teak; even flat lighting, no shadows, no text
```

---

## 7. Skies and background layers (SKY, BG)

### SKY-01: Stopped-noon sky (equirectangular)
```
Seamless 360-degree equirectangular sky panorama, 2:1, horizon exactly across the middle, no ground and no buildings, a small intensely bright white-gold sun high in the sky at about 64 degrees elevation, sky pale peach at the horizon shading to rose and then to a bruised violet-grey at the zenith, thin still wisps of high cirrus, warm golden dust haze along the horizon, HDR-like range, photorealistic
```

### SKY-02: Pongal-morning sky (equirectangular)
```
Seamless 360-degree equirectangular sky panorama, 2:1, horizon exactly across the middle, no ground and no buildings, a low warm golden sun at about 25 degrees elevation, clear pale blue sky warming to gold and peach near the sun and along the horizon, a few scattered soft morning clouds lit gold from below, a faint layer of woodsmoke haze at the horizon, photorealistic
```

### BG-01: Kanchi skyline layer (green screen)
```
Very wide panoramic strip 4:1, a distant skyline of 11th-century Chola temple towers seen from far away across a city: tall pyramidal vimanas and oblong gopurams with rows of gold kalasam finials, of different heights spread across the width, silhouetted and softened by thick golden dust haze, low contrast; everything above the skyline is pure flat chroma green #00FF00 for keying, no sky, no clouds, no birds
```
*+ Style A (lighting part only)*

### BG-02: Lower city rooftops and palms (green screen)
```
Very wide panoramic strip 4:1, seen from high above at a slight downward angle: an 11th-century South Indian town of lime-washed houses with terracotta half-round tile roofs, narrow streets, coconut palms between the houses, tiny granite figures frozen in the streets, everything sinking into golden dust haze toward the bottom; everything above the rooftops is pure flat chroma green #00FF00
```

### BG-03: Sevvappur village layer (green screen)
```
Very wide panoramic strip 4:1, a Tamil village seen at eye level from across a field: low houses with coconut-thatch roofs and red-earth walls, haystacks, a small village shrine with large terracotta Ayyanar horse figures, coconut and palmyra palms, woodsmoke rising straight from Pongal fires, warm early morning light; everything above the trees is pure flat chroma green #00FF00
```

---

## 8. Textures (TEX) and decals (DEC)

**Every texture prompt starts with:**
```
Seamless tileable texture, square, viewed straight-on with flat even lighting and no shadows or highlights, photographic detail, edges wrap perfectly in both directions, no perspective, no objects, no text:
```

| ID | Texture | Prompt (after the starter above) | Real-world tile size |
|---|---|---|---|
| TEX-01 | Granite ashlar wall | `dressed pink-grey granite ashlar wall, large rectangular blocks in courses about 75 cm high and 1 to 2 m long, very fine tight joints, visible feldspar and mica crystals, a few small carved mason's marks, subtle dark vertical rain streaks, slightly chipped block edges` | 6 m |
| TEX-02 | Granite flagstones | `worn granite flagstone floor seen from directly above, large irregular rectangular slabs 1 to 1.5 m, fine joints with a little dust, foot-polished smoother patches, faint oil stains` | 6 m |
| TEX-03 | Dark charnockite | `dark blue-grey charnockite granite masonry blocks, fine joints, dark streaks under ledges, a faint lichen in some joints` | 6 m |
| TEX-04 | Plinth moulding trim | `horizontal trim sheet of a Chola temple moulded plinth (adhishthana) seen straight-on: from bottom to top a plain base band, a flat band, a large rounded torus moulding, a recessed neck, a flat band; carved in pink-grey granite` (make it wide: 4:1) | 4 m wide |
| TEX-05 | Arena earth | `swept red-brown earth with a light dusting of sand, broom marks, scattered hoof prints and footprints, a few loose petals and straw` | 4 m |
| TEX-06 | Lime plaster | `patchy lime-washed plaster over brick, off-white with a darker ochre band at the bottom, worn through to brick in places` | 3 m |
| TEX-07 | Terracotta roof tiles | `terracotta half-round clay roof tiles in overlapping rows seen from above, weathered, some darker and some lighter` | 2 m |
| TEX-08 | Coconut thatch | `coconut-palm frond thatch roof seen from above, overlapping dried fronds, sun-bleached grey-brown` | 2 m |
| TEX-09 | Palm-leaf panel | `woven coconut-palm-leaf fence panel (keet), diagonal weave, dried green-brown` | 1.5 m |
| TEX-10 | Weathered wood | `sun-bleached grey-brown teak wood, long grain, deep cracks along the grain, worn smooth where hands touch` | 2 m |
| TEX-11 | Bull hide, grey-white | `short-haired grey-white zebu cattle hide close-up, hair direction visible, faint darker mottling` | 0.5 m |
| TEX-12 | Bull hide, black | `short glossy dark grey-black zebu cattle hide close-up, hair direction visible` | 0.5 m |
| TEX-13 | Bull hide, red-brown | `short-haired deep red-brown zebu cattle hide close-up, hair direction visible` | 0.5 m |
| TEX-14 | Cotton veshti weave | `off-white handloom cotton fabric close-up, visible plain weave, slight creases` | 0.3 m |
| TEX-15 | Tiger banner | **Not tileable.** `flat front view of a red silk festival banner, 3:4, a golden tiger in couched gold thread in the centre (the Chola tiger emblem), woven gold and green borders, silk sheen` | — |
| TEX-16 | Canopy silk | `saffron silk cloth with a repeating small red lozenge pattern` | 1 m |
| TEX-17 | Statue granite | `fine-grained pink-grey granite surface, small crystals, very slightly polished` | 0.5 m |

### Decals (on pure black, so I can use them as masks)

| ID | Decal | Prompt |
|---|---|---|
| DEC-01 | Sikku kolam | `top-down view of a traditional Tamil sikku kolam drawn in white rice flour on a pure black background: a 7 by 7 dot grid with one continuous unbroken line looping around every dot, symmetrical, slightly uneven hand-drawn lines with powder texture` |
| DEC-02 | Coloured Pongal kolam | `top-down view of a large Tamil Pongal kolam on a pure black background: white rice-flour outline of a clay Pongal pot overflowing, sugarcane stalks either side and a sun above, filled with red, yellow and green coloured powder, hand-drawn` |
| DEC-03 | Mason's marks | `sheet of 12 small chiselled mason's marks on a pure black background as if carved in stone, lit from the top left: a fish, a lamp, a conch, a crescent with a dot, a trident, a lotus, a bow, a drum, a flag, a pot, a wheel, a leaf` |

*Note:* Gemini often garbles Tamil script, so I'll set any Tamil inscriptions in code with a real Tamil font rather than generate them as images.

---

## 9. Animals (ANI)

### Reference-sheet prompts (Style C)

**ANI-01, Vellaiyan (Kangayam):**
```
Full-body side-on reference sheet of a mature Kangayam bull, a native Tamil zebu breed: grey-white coat darker grey over the large muscular hump, neck and shoulders, a deep dewlap, long legs, narrow hips, long tail with a black switch, long horns sweeping up and outward painted in red and blue bands with brass caps on the tips, a red cloth bundle of coins tied between the horns, a garland of orange kanakambaram and white jasmine and a string of small brass bells at the neck, standing square on all four legs, real-world size 1.4 m at the hump
```
**ANI-02, Karuppan (Pulikulam):**
```
Full-body side-on reference sheet of a Pulikulam bull, a small fast native Tamil zebu breed from Madurai: compact athletic body, short glossy dark grey-black coat, a tight high hump, short horns curving forward painted in blue and white bands with brass tips, a red coin cloth between the horns, a jasmine garland and brass bells at the neck, standing square, 1.25 m at the hump
```
**ANI-03, Sivappan (the palace bull):**
```
Full-body side-on reference sheet of a huge royal-herd zebu bull: deep red-brown coat darker on the massive hump and neck, a very deep dewlap, long lyre-shaped horns painted gold with brass caps, a red silk coin cloth between the horns, a thick garland of kanakambaram and jasmine, a broad brass forehead plate, a heavy string of brass bells, standing square, 1.55 m at the hump
```
*+ Style C + negative prompt*

**Bull animations** (bake into each GLB, in place, these exact names):

| Name | Length | Description |
|---|---|---|
| `idle` | 3 s loop | Breathing, tail flick, ear twitch |
| `stamp` | 1.5 s | Paws the ground with a front hoof, head low (behind the gate) |
| `gallop` | about 0.6 s loop | Full charge |
| `buck` | about 0.7 s loop | Front half rises, then hind legs kick out; hump and dewlap jiggle |
| `spin` | 1.2 s | Pivots on the front legs, swinging the hind quarters round |
| `headtoss` | 0.8 s | Drops the head low, then tosses it up and sideways |
| `trot` | 0.8 s loop | Trotting back to the owner afterwards |

**Bull fallback, if you can't rig:** generate one static model in a **standing pose** and upload it with its reference sheet. I'll move the whole body in code (bounce, pitch, roll and the head toss) as now. The legs won't animate, so please try to rig.

**ANI-04, temple elephant (frozen, static):**
```
Full-body side-on reference sheet of an Indian temple elephant turned entirely to fine-grained pink-grey granite mid-stride, a carved stone caparison cloth over its back, a small stone howdah pavilion on top, its gold forehead plate and a row of gold neck bells still bright metal, trunk raised, 3 m at the shoulder
```
*+ Style C + negative prompt. Static GLB, two materials: granite and gold.*

---

## 10. Hero and named characters (CHR)

All are **Style C + "standing in A-pose …" + negative prompt**, then image-to-3D, then (if animated) Mixamo.

### CHR-01: Ilan, 20 (hero, animated)
```
Character reference sheet of Ilanthiraiyan, a 20-year-old Tamil temple guard, 1.75 m, lean wiry climber's build with defined shoulders and forearms, medium-dark brown skin sun-darkened on the shoulders, light stubble, long black hair tied in a side topknot, bare chest, white cotton veshti tied as a kacham at mid-thigh, a red silk waist sash with a short hanging tail, leather wrist wraps, small gold ear studs, a hammered bronze armband on the right upper arm set with a sliver of black volcanic glass, a short slightly curved iron blade in a worn leather scabbard at the left hip, barefoot
```
**Mixamo animations:** `Idle`, `Running`, `Jump` (or `Jumping Up` + `Falling Idle` + `Landing`), `Standing Melee Attack Horizontal` (Cut), `Climbing` or `Braced Hang To Crouch` (ledge climb), `Crouch Idle` (ready pose), `Cheering`, `Falling Back Death` (thrown), `Sitting Idle`. Rename them in Blender to: `idle, run, jump, fall, land, cut, climb, ready, cheer, thrown, sit`.

### CHR-02: Ilan, 16 (jallikattu memory, animated)
```
Character reference sheet of the same Tamil youth at 16: thinner, shorter hair tied back with a strip of cloth, 1.68 m, white veshti hitched to the knee, no armband, no sash, no blade, barefoot
```
Same Mixamo list, plus a custom **`ride`** pose if your tool allows it (sitting astride, leaning forward, arms wrapped forward). If not, I'll pose it in code.

### CHR-03: Prince Aditya, 20, crowning (static)
```
Character reference sheet of a 20-year-old Tamil prince turned to fine-grained pink-grey granite, standing, both arms raised holding a tall plain gold crown with one carved tiger a hand's width above his own head; the crown is bright gold, everything else is granite including his silk veshti, jewellery and sandal-paste marks carved in stone
```
(Static GLB, two materials: granite and gold. No A-pose: the pose is the point.)

### CHR-04: Prince Aditya, 16 (static, two poses)
```
Character reference sheet of a 16-year-old Tamil prince in a gold-bordered silk veshti and a light silk upper cloth, slim, gold armlets and earrings, a thin sandal-paste mark on the forehead, eager open face; pose 1: leaning forward gripping a rail with both hands; pose 2: standing relaxed, holding out one hand with three gold coins in the palm
```

### CHR-05: Captain Veeran (animated: idle, point, haul)
```
Character reference sheet of a 41-year-old Tamil temple guard captain, 1.78 m, broad and strong with a slight belly, thick moustache, greying hair in a knot, white veshti with a red border, a red guard's sash across the chest, a bamboo staff, scarred forearms, calm amused expression
```

### CHR-06: Village headman (static, arm raised)
```
Character reference sheet of a 60-year-old Tamil village headman, thin, white moustache, sacred ash stripes on the forehead, white veshti and a white upper cloth over one shoulder, one arm raised high to announce
```

### CHR-07: Parai drummer (one loop: `drum`)
```
Character reference sheet of a lean Tamil parai drummer, 30s, bare chest, indigo veshti tucked up, a red cloth tied around the head, a large round frame drum (parai) held against the chest by a strap, two sticks: one thin, one thick
```

**No generation needed:** **Nizhal** (Ilan's mesh with a smoke shader) and the **Nizhalar** shadow-walkers (crowd meshes with the same shader).

---

## 11. Crowd and statues (CRW)

**All static posed models**, about 6,000 triangles each, **one material**, so I can tint the cloth per copy. Use Style C (without the A-pose line) + negative prompt, and add: `single person, full body, the pose described, plain light-grey background`.

| ID | Person and pose |
|---|---|
| CRW-01 | Tamil man, 30s, bare chest, white veshti, both arms raised cheering, mouth open |
| CRW-02 | Tamil man, 20s, cloth tied round his head, leaning forward with both forearms on a rail, intent |
| CRW-03 | Tamil woman, 30s, madder-red cotton sari draped without a blouse, jasmine in her braid, clapping overhead |
| CRW-04 | Tamil grandmother, thin, white sari, hands pressed together in front of her chest |
| CRW-05 | Tamil father in a white veshti with a 6-year-old boy sitting on his shoulders, both cheering (one model) |
| CRW-06 | Tamil girl, 9, small green skirt and drape, jasmine in her hair, pointing excitedly |
| CRW-07 | Tamil elder, 70, white beard, white upper cloth, leaning on a walking stick |
| CRW-08 | Tamil youth, 18, whistling with two fingers in his mouth, other arm raised |
| CRW-09 | Tamil woman, 20s, indigo sari, a baby on her hip, laughing |
| CRW-10 | Tamil bull-tamer, 20s, veshti tucked up, crouched ready with arms out, cloth tied round his head |

**Chapter 1 frozen moments** (the same style, but **in granite** with metal ornaments kept bright):

| ID | Statue |
|---|---|
| CRW-11 | A woman frozen mid-throw, rice grains fanned in the air from her hand |
| CRW-12 | A flower girl, 9, holding a basket of jasmine (the shadow-memory Malar) |
| CRW-13 | An odhuvar (temple hymn singer) mid-song, palms together, bronze cymbals in one hand |
| CRW-14 | A temple server mid-pour, a brass ladle tilted over a plantain leaf |

---

## 12. Architecture (ARC)

Static GLBs, Style C (object version: "full object, front, side, back, three-quarter") + Style A or B materials as noted.

| ID | Asset | Prompt core | Size |
|---|---|---|---|
| ARC-01 | **Mirror Temple** | `13-tier pyramidal Dravidian vimana temple tower in dark charnockite granite modelled on Brihadeeswarar Thanjavur, every tier ringed with miniature domed kuta shrines and barrel-vaulted sala pavilions, moulded plinth at the base, octagonal dome and a broken gold finial at the top` | 66 m tall |
| ARC-02 | Gopuram | `Chola temple gateway tower (gopuram), oblong, 7 tiers of pilastered storeys with sculpted niches, a barrel-vault roof with a row of 7 gold kalasam finials, pink-grey granite and brick` | 30 m |
| ARC-03 | Small vimana shrine | `small 4-tier Chola vimana shrine, square sanctum with pilasters, miniature shrine parapets, octagonal dome and one gold kalasam` | 12 m |
| ARC-04 | Chola pillar | `single monolithic granite temple pillar: square base, alternating square and octagonal shaft sections with carved bands, pot-shaped capital, square abacus, curled corbel brackets on four sides` | 6.2 m |
| ARC-05 | Terrace plinth segment | `4-metre straight segment of a raised granite palace terrace: moulded Chola plinth on the front face (base band, flat band, round torus, recessed neck, flat band), flagstone top, plain masonry back` | 4 × 2 × 9 m |
| ARC-06 | Vaadivaasal gate | `narrow timber bull-gate for a village jallikattu: two thick weathered posts and a lintel, a small coconut-thatch roof, a 6-metre timber chute behind it, a string of mango leaves across the lintel` | 3.5 m tall |
| ARC-07 | Village house | `small Tamil village house with red-earth plastered walls, a low coconut-thatch roof, a raised front veranda (thinnai), a wooden door, a fresh kolam at the threshold` | 5 × 4 m |
| ARC-08 | Town house | `11th-century South Indian town house, lime-washed walls with an ochre base band, terracotta half-round tile roof, a wooden door with a small stone step` | 6 × 5 m |
| ARC-09 | Barricade section | `4-metre section of a jallikattu barricade: timber posts, three horizontal rails, a woven palm-leaf panel, and behind it a stacked wooden bullock-cart platform for spectators` | 4 m |

---

## 13. Props (PRP)

Static GLBs, Style C (object) + negative prompt.

| ID | Prop | Prompt core |
|---|---|---|
| PRP-01 | Kuthuvilakku | `tall Tamil bronze standing oil lamp, round base, slender shaft, five-spouted dish with five small flames, a peacock finial on top` (1.3 m) |
| PRP-02 | Pongal pot | `new clay pot on a three-stone hearth with firewood beneath, a fresh turmeric plant with leaves tied around its neck, milk and rice foaming over the rim, a small sugarcane stalk leaning beside it` |
| PRP-03 | Sugarcane bundle | `bundle of eight tall purple-green sugarcane stalks with leaves, tied with coir rope, leaning` (2.4 m) |
| PRP-04 | Banana plant | `whole banana plant with a hanging bunch of green bananas and a purple flower bud, large torn leaves` (2.8 m) |
| PRP-05 | Coconut palm (2 variants) | `tall curved coconut palm with a cluster of green coconuts, drooping fronds` (11 m and 14 m) |
| PRP-06 | Silk canopy | `saffron silk canopy with red and green border bands on four wooden poles; version A rolled tight on top of the poles, version B fully open and gently sagging` (6 × 4 m) |
| PRP-07 | Tiger banner | `red silk banner with a gold Chola tiger emblem hanging from a crossbar between two wooden poles with brass finials` (3 m) |
| PRP-08 | Drums | `a Tamil thavil barrel drum and a parai frame drum with its sticks` |
| PRP-09 | Rope post | `wooden post with a brass bud-shaped finial and a coil of coir rope` (2.3 m) |
| PRP-10 | Gold crown | `tall conical plain gold Chola crown (mukuta) with a single carved tiger on the front, worn bright edges` |
| PRP-11 | Coin cloth | `small red cloth bundle tied with string, a few old gold coins visible at the opening` |
| PRP-12 | Feast leaf | `plantain leaf on the floor with a heap of white rice, a ladle of ghee, three small brass bowls of payasam and dal` |
| PRP-13 | Bullock cart | `traditional Tamil wooden bullock cart with two large spoked wheels, no bulls` |
| PRP-14 | Mango-leaf string | `thoranam: a string of 30 fresh mango leaves hanging from a cord, 3 m long` |
| PRP-15 | Brass and clay lamps | `set of six small clay agal lamps and one bronze five-wick lamp, each with a small flame` |

---

## 14. UI art (UI)

| ID | Asset | Size | Prompt core |
|---|---|---|---|
| UI-01 | **Title key art (vertical)** | 1080 × 1920 | `vertical key art: the 13-tier black granite Mirror Temple tower filling the frame from low angle, black glass shards hanging around its summit glowing violet, at its foot a small young guard in a red sash looking up, his living shadow beside him; leave the middle third of the image calm and uncluttered for the title text` + Style A |
| UI-02 | App icon | 1024 × 1024 | `app icon: a black glass shard set in a hammered bronze armband, a faint violet glow inside the shard, against a warm gold-to-violet gradient, simple bold silhouette, no text` |
| UI-03 | Loading screen | 1080 × 1920 | `vertical: close-up of a chisel cutting into black granite, a single granite chip flying, warm dusk light, dark background` |
| UI-04 | Chapter cards (2 for now) | 1080 × 1920 each | Ch. 1: `stone prince holding a gold crown above his head, silent courtyard at noon`. Interlude I: `a bull's painted horn with a brass tip and a red coin cloth, dust in morning light, extreme close-up` |

---

## 15. Priority 2: later chapters

Generate these when we build each chapter. They use the same style blocks and rules.

| Chapter | Assets |
|---|---|
| **Ch. 2, Stepwell** | Temple tank with nine levels of stepped sides and a central pavilion (ARC); stone sluice gate; banana-stem lamp boats (PRP); jaali pierced-stone screen (TEX); **Kayal** (CHR, animated: idle, run, draw-bow, shoot, climb); **Stepwell Serpent** (a coiled naga of black water-shadow, crowned with old lamp boats, GLB rigged) |
| **Interlude II, Aadi Perukku** | River bank with steps and crowds (REF); Keeper **Sendan** (CHR); young Kayal (12) and young Ilan (13) (CHR); bamboo silambam staff (PRP); kabaddi court marked in dirt (DEC); offerings on plantain leaves (PRP) |
| **Ch. 3, Foundry** | Kammalar street workshops (ARC); lost-wax models, clay moulds, crucibles, bellows (PRP); bronze dwarapala guardians (GLB rigged); the 30 m **Bronze Colossus** (GLB rigged); pallanguzhi board with cowries (PRP); **Mayan** shadow-memory (CHR) |
| **Interlude III, Karthigai Deepam** | Night rooftops lined with clay lamps (REF); the hill beacon (PRP); sokkapanai bonfire (PRP); **Ponni** the bell-caster (CHR); young **Kaalavan** and **Valli** with her anklet (CHR) |
| **Ch. 4, Thousand-Pillar Hall** | Palm-leaf manuscript racks (PRP); swivelling bronze mirrors (PRP); nazhigai sundial (PRP); 27-nakshatra star floor (TEX); **Kaalavan** at 55 with orbiting shards (CHR); Lamp-bearer enemy (GLB rigged) |
| **Interlude IV, Ther festival** | The five-storey temple **chariot** (ARC, large); vadam ropes (PRP); uriyadi pot (PRP); oyilattam dancers (CRW variants); young Aditya (8) and young Ilan (8) (CHR) |
| **Ch. 5, Mirror Temple** | Floating tower floors (ARC set); the **Mirror** in its bronze lotus cradle (PRP); wedding pandal; therukoothu performers with headdresses; sea trader; famine kitchen; Sengan carving (CHR); Nizhal's full form (shader on Ilan) |
| **Epilogue, Pongal** | Bhogi fires (PRP); a street of Pongal pots (REF); older Ilan (32) on a bamboo scaffold (CHR); the finished frieze (TEX); **Murugan** (8) (CHR) |

---

## 16. Optional: audio

Gemini doesn't make audio. If you want to replace my generated sounds, a music or sound tool can make these; same naming rule (`SFX-xx_name.mp3`).

| ID | Sound |
|---|---|
| SFX-01 | Parai drum loop, fast festival rhythm, 30 s, loopable |
| SFX-02 | Nadaswaram and thavil festival piece, 60 s |
| SFX-03 | Village crowd roar and cheering, 20 s, loopable |
| SFX-04 | Bull snort, bellow and hooves on earth (5 short clips) |
| SFX-05 | Brass neck bells jingling (loop) |
| SFX-06 | Low drone for the stopped city, tanpura-like, 60 s loop |
| SFX-07 | Shadow Step: a reversed breath plus an ink-in-water whoosh |
| SFX-08 | Conch (sangu) blast |

---

## 17. Delivery checklist

**Before uploading each file:**
- [ ] File name starts with its ID (`ANI-01_vellaiyan.glb`)
- [ ] GLB: metres, +Y up, facing +Z, origin on the ground, textures embedded, **no Draco**
- [ ] GLB: under the triangle and file-size budgets in section 4
- [ ] Animated GLB: animation names match the lists exactly
- [ ] Textures: seamless (check by tiling 2 × 2), flat lighting
- [ ] Green-screen layers: pure #00FF00 behind, no green spill on buildings

**Suggested upload order:**
1. SKY-01, SKY-02, TEX-01, TEX-02, TEX-05 (biggest visual jump for the least work)
2. ANI-01, ANI-02, ANI-03 (the bulls)
3. CHR-01, CHR-02 (Ilan)
4. CRW-01 to CRW-10 (crowd, and Chapter 1's statues for free)
5. ARC-01 to ARC-09, PRP-01 to PRP-15
6. Everything else

**What I'll do with them:** load each asset into the game, match its lighting and scale, keep the code-built version as a fallback, and update the published game after each batch.
