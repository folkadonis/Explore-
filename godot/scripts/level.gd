## Chapter 1: the palace terraces at the stopped noon. Builds the world and answers "where is shade?".
class_name Level
extends Node3D

const SUN_D := Vector3(0.32, -1.0, 0.35)
var TO_SUN := (-SUN_D).normalized()

# Walkways. x runs along the lane, y is up; the lane is z = 0. bottom defaults to 40 m below the top.
var PL := [
	{"x0": -16.0, "x1": -6.0, "top": 13.0, "wall": true},
	{"x0": -6.0, "x1": 30.0, "top": 0.0},
	{"x0": 10.0, "x1": 13.0, "top": 1.2, "bottom": 0.0, "zf": 1.6},
	{"x0": 14.0, "x1": 17.0, "top": 2.4, "bottom": 0.0, "zf": 1.6},
	{"x0": 33.2, "x1": 44.0, "top": 0.0},
	{"x0": 50.5, "x1": 62.0, "top": 0.0},
	{"x0": 66.6, "x1": 73.0, "top": 0.0},
	{"x0": 77.6, "x1": 84.0, "top": 0.0},
	{"x0": 88.6, "x1": 96.0, "top": 1.0},
	{"x0": 103.0, "x1": 113.0, "top": 0.0},
	{"x0": 119.5, "x1": 127.0, "top": 0.0},
	{"x0": 133.5, "x1": 170.0, "top": 0.0},
	{"x0": 167.6, "x1": 170.0, "top": 0.43, "bottom": 0.0, "zf": 2.0},
	{"x0": 168.8, "x1": 170.0, "top": 0.86, "bottom": 0.0, "zf": 2.0},
	{"x0": 170.0, "x1": 190.0, "top": 1.3},
	{"x0": 190.0, "x1": 200.0, "top": 15.0, "wall": true},
]
const ELEPHANTS := [Vector3(69.8, 0, -1.4), Vector3(80.8, 0, -1.4)]
const LANE_STATUES := [[90.0, -0.55, "cheer"], [90.42, -0.62, "namaskaram"], [91.9, -0.55, "drum"], [92.32, -0.6, "namaskaram"]]
const BANNER := {"x0": 51.0, "x1": 54.0, "y0": 3.2, "y1": 5.6, "z": -1.54}
const SWING := {"px": 105.2, "py": 9.5, "L": 3.5, "A": 0.65, "T": 3.4, "w": 2.6, "h": 2.0, "z": -1.75, "post0": 103.3, "post1": 109.0}
var CANOPIES := [
	{"post": 112.3, "x0": 118.5, "x1": 124.5, "y": 3.4, "z0": -3.0, "z1": 1.0, "cut": false, "t": 0.0},
	{"post": 126.4, "x0": 132.5, "x1": 138.5, "y": 3.4, "z0": -3.0, "z1": 1.0, "cut": false, "t": 0.0},
]
const HALL := {"x0": 139.0, "x1": 165.0, "y0": 6.2, "y1": 7.0, "z0": -7.5, "z1": 2.0}
const MEMS := [
	[15.5, 4.4, "Sengan, stone-carver", "He cut a crescent and a dot into every block he set."],
	[31.6, 2.3, "Malar, 9, flower-seller", "She was saving for a bronze bell."],
	[61.4, 0.95, "Veeran, guard captain", "He kept boys in the back row. He knew every one of their names."],
	[75.2, 2.4, "Ponni, bell-caster", "She cast the coronation bell. She never heard it ring."],
	[94.6, 3.3, "Arivu, star-reader", "She named a comet after her mother."],
	[99.2, 2.8, "Vel, water-carrier", "Three hundred steps a day, for forty years."],
	[129.9, 2.2, "Kannan, thavil drummer", "He played at nine coronations."],
	[163.5, 0.95, "Selvi, cook", "She made the payasam for the feast. It is still warm."],
]

const CASTER := 2   # collision layer for things that throw shade
const WALK := 1     # collision layer for things you stand on

var shadows: Array = []       # [{x1, x2, y}]
var swing_body: StaticBody3D
var swing_mesh: MeshInstance3D
var canopy_nodes: Array = []
var memory_nodes: Array = []
var sun: DirectionalLight3D
var env: Environment
var time := 0.0

func _ready() -> void:
	for p in PL:
		if not p.has("bottom"): p.bottom = p.top - 40.0
		if not p.has("zf"): p.zf = 2.5
		p.zb = -7.5
	_environment()
	_terraces()
	_skyline()
	_lower_city()
	_crowds()
	_props()
	_hall()
	_memories()

# ------------------------------------------------------------ light and air
func _environment() -> void:
	var env := Environment.new()
	var sky := Sky.new()
	var sm := ProceduralSkyMaterial.new()
	sm.sky_top_color = Color(0.25, 0.17, 0.38)
	sm.sky_horizon_color = Color(1.0, 0.72, 0.5)
	sm.sky_curve = 0.12
	sm.ground_horizon_color = Color(0.85, 0.6, 0.42)
	sm.ground_bottom_color = Color(0.35, 0.22, 0.17)
	sm.sun_angle_max = 8.0
	sky.sky_material = sm
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.75
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_exposure = 1.05
	env.fog_enabled = true
	env.fog_light_color = Color(0.78, 0.56, 0.42)
	env.fog_density = 0.0075
	env.fog_sky_affect = 0.25
	env.glow_enabled = true
	env.glow_intensity = 0.5
	env.glow_bloom = 0.08
	var we := WorldEnvironment.new(); we.environment = env; add_child(we); self.env = env
	sun = DirectionalLight3D.new()
	sun.light_color = Color(1.0, 0.84, 0.65)
	sun.light_energy = 2.4
	sun.shadow_enabled = true
	sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	sun.directional_shadow_max_distance = 70.0
	sun.shadow_bias = 0.04
	sun.look_at_from_position(Vector3.ZERO, SUN_D, Vector3.FORWARD)
	add_child(sun)

func add_caster(center: Vector3, size: Vector3, walkable := false) -> StaticBody3D:
	var b := StaticBody3D.new()
	b.collision_layer = CASTER | (WALK if walkable else 0)
	b.collision_mask = 0
	var cs := CollisionShape3D.new(); var sh := BoxShape3D.new(); sh.size = size; cs.shape = sh
	b.add_child(cs); b.position = center; add_child(b)
	return b

# ------------------------------------------------------------ terraces
func _terraces() -> void:
	var mb := Build.MB.new()
	for p in PL:
		var w: float = p.x1 - p.x0
		var h: float = p.top - p.bottom
		var d: float = p.zf - p.zb
		var c := Vector3(p.x0 + w/2, p.bottom + h/2, p.zb + d/2)
		add_caster(c, Vector3(w, h, d), true)
		if p.get("wall", false):
			mb.add(Build.box(w, h, d), Build.M("dark"), Build.xf(c))
			continue
		mb.add(Build.box(w, h - 0.15, d), Build.M("mason"), Build.xf(c - Vector3(0, 0.075, 0)))
		mb.add(Build.box(w, 0.15, d), Build.M("flag"), Build.xf(Vector3(c.x, p.top - 0.075, c.z)))
		mb.add(Build.box(w + 0.06, 0.12, 0.3), Build.M("flag"), Build.xf(Vector3(c.x, p.top - 0.06, p.zf + 0.1)))
		if h > 2.0:  # the carved plinth along the terrace front
			var q := QuadMesh.new(); q.size = Vector2(w, 1.76)
			var mi := Build.node(self, q, Build.plinth_mat(w/4.3), Vector3(c.x, p.top - 0.9, p.zf + 0.01))
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mb.commit(self)

# ------------------------------------------------------------ distance
func _skyline() -> void:
	var mb := Build.MB.new()
	var h := Build.vimana(mb, Vector3(-4, 0, -30), 22, 13, Build.M("dark"), 0.7, 0.21)
	var halo := OmniLight3D.new(); halo.light_color = Color(0.7, 0.45, 1.0); halo.light_energy = 4.0; halo.omni_range = 18; halo.position = Vector3(-4, h - 2, -26); add_child(halo)
	var ob := StandardMaterial3D.new(); ob.albedo_color = Color(0.03, 0.02, 0.05); ob.metallic = 0.3; ob.roughness = 0.08; ob.emission_enabled = true; ob.emission = Color(0.35, 0.15, 0.7); ob.emission_energy_multiplier = 0.6
	var rng := RandomNumberGenerator.new(); rng.seed = 99
	for i in 40:
		var a := rng.randf()*TAU; var r := 6.0 + rng.randf()*16.0
		mb.add(Build.sph(0.5 + rng.randf()*0.8, 4, 2), ob, Build.xf(Vector3(-4 + cos(a)*r, h - 8 + rng.randf()*14, -30 + sin(a)*r*0.6), Vector3(rng.randf()*3, rng.randf()*3, 0), Vector3(1, 2.2, 1)))
	var stone := Build.M("mason")
	for s in [[26, -58, 0], [58, -70, 1], [92, -50, 0], [124, -82, 0], [148, -60, 1], [176, -74, 0], [212, -96, 1], [-34, -64, 0], [240, -66, 1], [72, -140, 0], [160, -150, 1], [108, -118, 1], [200, -180, 0]]:
		if s[2] == 0: Build.vimana(mb, Vector3(s[0], -30, s[1]), 14.0 + (int(s[0]) % 5), 6, stone)
		else: Build.gopuram(mb, Vector3(s[0], -30, s[1]), 16, 8, 7, stone)
	mb.commit(self, false)

func _lower_city() -> void:
	var g := Build.node(self, Build.box(700, 0.2, 400), Build.M("streets"), Vector3(90, -30.1, -130))
	g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mb := Build.MB.new()
	var rng := RandomNumberGenerator.new(); rng.seed = 31
	for i in 220:
		var x := -40 + rng.randf()*280; var z := -22 - rng.randf()*80
		var w := 4 + rng.randf()*5; var d := 4 + rng.randf()*4; var hh := 3 + rng.randf()*3
		var yaw := 0.0 if rng.randf() < 0.5 else PI/2
		mb.add(Build.box(w, hh, d), Build.M("plaster"), Build.xf(Vector3(x, -30 + hh/2, z), Vector3(0, yaw, 0)))
		mb.add(Build.cyl(0.0, 0.72, 1.0, 4), Build.M("tile"), Build.xf(Vector3(x, -30 + hh + 0.55, z), Vector3(0, yaw + PI/4, 0), Vector3(w*0.75, 1.1, d*0.75)))
	var trunk := Build.flat("trunk", Color(0.43, 0.35, 0.27), 0.95)
	var leaf := Build.flat("frond", Color(0.3, 0.42, 0.18), 0.8)
	for i in 46:
		var x2 := -30 + rng.randf()*260; var z2 := -20 - rng.randf()*70; var s := 0.9 + rng.randf()*0.5
		mb.add(Build.cyl(0.18*s, 0.24*s, 11*s, 6), trunk, Build.xf(Vector3(x2, -30 + 5.5*s, z2), Vector3(0, 0, 0.08)))
		for k in 9:
			var a := k/9.0*TAU
			mb.add(Build.box(0.5*s, 0.06, 3.2*s), leaf, Build.xf(Vector3(x2 + 0.45*s + cos(a)*1.4*s, -30 + 10.6*s, z2 + sin(a)*1.4*s), Vector3(0.5, -a + PI/2, 0)))
	mb.commit(self, false)

# ------------------------------------------------------------ frozen people
func _crowds() -> void:
	var poses := ["cheer", "namaskaram", "drum", "idle", "cheer"]
	var meshes := []
	for p in poses: meshes.append(Build.statue_meshes(p))
	var spots := [[], [], [], [], []]
	var rng := RandomNumberGenerator.new(); rng.seed = 77
	for p in PL:
		if p.get("wall", false) or p.top - p.bottom < 2: continue
		var x: float = p.x0 + 1.2
		while x < p.x1 - 1:
			if not (x > HALL.x0 - 1 and x < HALL.x1 + 1 and rng.randf() < 0.5):
				spots[rng.randi() % 5].append(Transform3D(Basis(Vector3.UP, (rng.randf() - 0.5)*2.4).scaled(Vector3.ONE*(0.92 + rng.randf()*0.16)), Vector3(x + rng.randf()*0.4, p.top, -3.2 - rng.randf()*3.6)))
			x += 1.6 + rng.randf()*2.4
	for i in 160:
		spots[rng.randi() % 5].append(Transform3D(Basis(Vector3.UP, rng.randf()*TAU), Vector3(-30 + rng.randf()*260, -30, -20 - rng.randf()*50)))
	for i in poses.size():
		for mat in meshes[i]:
			var mm := MultiMesh.new(); mm.transform_format = MultiMesh.TRANSFORM_3D; mm.mesh = meshes[i][mat]; mm.instance_count = spots[i].size()
			for j in spots[i].size(): mm.set_instance_transform(j, spots[i][j])
			var mmi := MultiMeshInstance3D.new(); mmi.multimesh = mm; mmi.material_override = mat; add_child(mmi)
	for s in LANE_STATUES:
		var ms := Build.statue_meshes(s[2])
		for mat in ms: Build.node(self, ms[mat], mat, Vector3(s[0], 1.0, s[1]), Vector3(0, PI/2 + 0.2, 0))
		add_caster(Vector3(s[0], 1.0 + 0.89, s[1]), Vector3(0.44, 1.78, 0.34))
	# Aditya on his dais, the crown half-raised; priests around him
	Build.node(self, Build.box(4, 0.4, 3), Build.M("flagOld"), Vector3(178.5, 1.5, -1.6))
	var ad := Build.statue_meshes("crown")
	for mat in ad: Build.node(self, ad[mat], mat, Vector3(178.5, 1.7, -1.2), Vector3(0, -PI/2 + 0.35, 0), Vector3.ONE*1.03)
	for pr in [[176.8, -2.6, "namaskaram", 0.9], [180.3, -2.5, "namaskaram", -0.9], [182.0, -1.4, "drum", -0.9], [175.2, -3.4, "cheer", 0.9]]:
		var m2 := Build.statue_meshes(pr[2])
		for mat in m2: Build.node(self, m2[mat], mat, Vector3(pr[0], 1.3, pr[1]), Vector3(0, pr[3], 0))

# ------------------------------------------------------------ props that matter for play
func _props() -> void:
	var mb := Build.MB.new()
	for e in ELEPHANTS + [Vector3(24, 0, -5), Vector3(57, 0, -5.2), Vector3(158, 0, -5.4)]:
		var boxes := Build.elephant(mb, e, 0.3 if e.z < -3 else 0.0)
		if e.z > -3:
			for bx in boxes: add_caster(bx[0], bx[1])
	# the banner on its poles
	var bw: float = BANNER.x1 - BANNER.x0
	var q := QuadMesh.new(); q.size = Vector2(bw, BANNER.y1 - BANNER.y0)
	Build.node(self, q, Build.banner_mat(), Vector3((BANNER.x0 + BANNER.x1)/2, (BANNER.y0 + BANNER.y1)/2, BANNER.z))
	add_caster(Vector3((BANNER.x0 + BANNER.x1)/2, (BANNER.y0 + BANNER.y1)/2, BANNER.z), Vector3(bw, BANNER.y1 - BANNER.y0, 0.08))
	for x in [BANNER.x0 - 0.2, BANNER.x1 + 0.2]:
		mb.add(Build.cyl(0.07, 0.09, 6.2, 8), Build.M("wood"), Build.xf(Vector3(x, 3.1, BANNER.z)))
		mb.add(Build.sph(0.12, 8, 6), Build.M("brass"), Build.xf(Vector3(x, 6.25, BANNER.z)))
		add_caster(Vector3(x, 3.1, BANNER.z), Vector3(0.16, 6.2, 0.16))
	mb.add(Build.cyl(0.05, 0.05, bw + 0.6, 8), Build.M("wood"), Build.xf(Vector3((BANNER.x0 + BANNER.x1)/2, BANNER.y1 + 0.06, BANNER.z), Vector3(0, 0, PI/2)))
	# the swinging banner on a timber gantry
	for x in [SWING.post0, SWING.post1]:
		mb.add(Build.box(0.28, SWING.py + 0.3, 0.28), Build.M("wood"), Build.xf(Vector3(x, (SWING.py + 0.3)/2, SWING.z)))
		add_caster(Vector3(x, (SWING.py + 0.3)/2, SWING.z), Vector3(0.28, SWING.py + 0.3, 0.28))
	mb.add(Build.box(SWING.post1 - SWING.post0 + 0.6, 0.3, 0.3), Build.M("wood"), Build.xf(Vector3((SWING.post0 + SWING.post1)/2, SWING.py, SWING.z)))
	add_caster(Vector3((SWING.post0 + SWING.post1)/2, SWING.py, SWING.z), Vector3(SWING.post1 - SWING.post0, 0.3, 0.3))
	var sq := QuadMesh.new(); sq.size = Vector2(SWING.w, SWING.h); sq.center_offset = Vector3(0, -SWING.h/2, 0)
	swing_mesh = Build.node(self, sq, Build.banner_mat())
	swing_body = add_caster(Vector3.ZERO, Vector3(SWING.w, SWING.h, 0.08))
	# canopies: rope post, poles, rolled silk that unrolls when cut
	for c in CANOPIES:
		mb.add(Build.cyl(0.09, 0.11, 2.3, 10), Build.M("wood"), Build.xf(Vector3(c.post, 1.15, -0.6)))
		mb.add(Build.sph(0.13, 10, 8), Build.M("brass"), Build.xf(Vector3(c.post, 2.35, -0.6), Vector3.ZERO, Vector3(1, 1.4, 1)))
		mb.add(Build.cyl(0.1, 0.1, 0.25, 10), Build.flat("rope", Color(0.6, 0.47, 0.29), 0.95), Build.xf(Vector3(c.post, 1.5, -0.6)))
		for x in [c.x0, c.x1]:
			for z in [c.z0, c.z1]: mb.add(Build.cyl(0.06, 0.08, c.y + 20, 8), Build.M("wood"), Build.xf(Vector3(x, c.y - (c.y + 20)/2 + 0.05, z)))
		var cloth := Build.node(self, Build.box(1, 0.04, c.z1 - c.z0), Build.M("saffron"), Vector3(c.x0, c.y, (c.z0 + c.z1)/2))
		var roll := Build.node(self, Build.cyl(0.22, 0.22, c.z1 - c.z0, 16), Build.M("saffron"), Vector3(c.x0, c.y + 0.04, (c.z0 + c.z1)/2), Vector3(PI/2, 0, 0))
		var body := add_caster(Vector3(c.x0, c.y, (c.z0 + c.z1)/2), Vector3(0.48, 0.48, c.z1 - c.z0))
		cloth.visible = false
		canopy_nodes.append({"cloth": cloth, "roll": roll, "body": body, "c": c})
		add_caster(Vector3(c.post, 1.15, -0.6), Vector3(0.2, 2.3, 0.2))
	# frozen oil lamps (kuthuvilakku), flames stopped mid-flicker but still glowing
	for x in [5.0, 21.0, 37.0, 58.0, 141.5, 148.7, 155.9, 163.1, 174.0, 183.0]:
		var y := 1.3 if x >= 170 else 0.0
		var z := -2.6 if (x > HALL.x0 and x < HALL.x1) else -2.2
		mb.add(Build.cyl(0.22, 0.24, 0.05, 14), Build.M("brass"), Build.xf(Vector3(x, y + 0.03, z)))
		mb.add(Build.cyl(0.03, 0.05, 1.0, 8), Build.M("brass"), Build.xf(Vector3(x, y + 0.55, z)))
		mb.add(Build.cyl(0.22, 0.06, 0.08, 14), Build.M("brass"), Build.xf(Vector3(x, y + 1.08, z)))
		mb.add(Build.sph(0.07, 8, 6), Build.M("brass"), Build.xf(Vector3(x, y + 1.3, z)))
		for k in 5:
			var a := k/5.0*TAU
			mb.add(Build.sph(0.03, 6, 4), Build.M("flame"), Build.xf(Vector3(x + cos(a)*0.19, y + 1.16, z + sin(a)*0.19), Vector3.ZERO, Vector3(1, 2.2, 1)))
		if x > HALL.x0 and x < HALL.x1:
			var l := OmniLight3D.new(); l.light_color = Color(1, 0.66, 0.38); l.light_energy = 2.5; l.omni_range = 9; l.position = Vector3(x, y + 1.25, z + 0.3); add_child(l)
	mb.commit(self)

func _hall() -> void:
	var mb := Build.MB.new()
	var cx: float = (HALL.x0 + HALL.x1)/2
	var cz: float = (HALL.z0 + HALL.z1)/2
	mb.add(Build.box(HALL.x1 - HALL.x0, HALL.y1 - HALL.y0, HALL.z1 - HALL.z0), Build.M("mason"), Build.xf(Vector3(cx, (HALL.y0 + HALL.y1)/2, cz)))
	add_caster(Vector3(cx, (HALL.y0 + HALL.y1)/2, cz), Vector3(HALL.x1 - HALL.x0, HALL.y1 - HALL.y0, HALL.z1 - HALL.z0))
	mb.add(Build.box(HALL.x1 - HALL.x0, HALL.y0, 0.6), Build.M("mason"), Build.xf(Vector3(cx, HALL.y0/2, HALL.z0 + 0.3)))
	var x: float = HALL.x0 + 1.2
	while x < HALL.x1:
		for z in [-1.3, -3.9, -6.4]: Build.pillar(mb, Vector3(x, 0, z), HALL.y0, Build.M("stoneBig"))
		mb.add(Build.box(0.5, 0.4, HALL.z1 - HALL.z0 - 0.4), Build.M("mason"), Build.xf(Vector3(x, HALL.y0 - 0.2, cz)))
		x += 3.6
	var xx: float = HALL.x0 + 0.6
	var k := 0
	while xx < HALL.x1 - 0.3:
		if k % 3 == 0:
			mb.add(Build.box(0.8, 0.55, 0.7), Build.M("mason"), Build.xf(Vector3(xx, HALL.y1 + 0.28, HALL.z1 - 0.4)))
			mb.add(Build.sph(0.42, 8, 5), Build.M("mason"), Build.xf(Vector3(xx, HALL.y1 + 0.6, HALL.z1 - 0.4), Vector3.ZERO, Vector3(1, 0.7, 1)))
		else:
			mb.add(Build.box(1.0, 0.55, 0.7), Build.M("mason"), Build.xf(Vector3(xx, HALL.y1 + 0.28, HALL.z1 - 0.4)))
		xx += 1.3; k += 1
	# the coronation feast on plantain leaves, steam frozen over the rice
	var leaf := Build.flat("plantain", Color(0.3, 0.5, 0.18), 0.6)
	var rice := Build.flat("rice", Color(0.95, 0.93, 0.88), 0.9)
	var steam := StandardMaterial3D.new(); steam.albedo_color = Color(1, 1, 1, 0.35); steam.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA; steam.roughness = 0.1
	var fx: float = HALL.x0 + 2.2
	while fx < HALL.x1 - 1:
		for z in [-1.7, -3.1]:
			var px: float = fx + (1.1 if z < -2 else 0.0)
			mb.add(Build.box(1.2, 0.01, 0.5), leaf, Build.xf(Vector3(px, 0.01, z)))
			mb.add(Build.sph(0.16, 10, 6), rice, Build.xf(Vector3(px, 0.03, z), Vector3.ZERO, Vector3(1.2, 0.45, 1)))
			mb.add(Build.cyl(0.07, 0.06, 0.06, 10), Build.M("brass"), Build.xf(Vector3(px + 0.38, 0.04, z - 0.1)))
			mb.add(Build.cyl(0.02, 0.08, 0.5, 8), steam, Build.xf(Vector3(px, 0.3, z), Vector3(0.2, 0, 0.15)))
		fx += 2.6
	mb.commit(self)

func _memories() -> void:
	var m := Build.glow("memory", Color(0.75, 0.55, 1.6), 2.5)
	for d in MEMS:
		var n := Build.node(self, Build.sph(0.13, 8, 4), m, Vector3(d[0], d[1], 0), Vector3.ZERO, Vector3(1, 1.6, 1), false)
		var l := OmniLight3D.new(); l.light_color = Color(0.7, 0.5, 1.0); l.light_energy = 1.2; l.omni_range = 2.5; n.add_child(l)
		memory_nodes.append({"node": n, "x": d[0], "y": d[1], "name": d[2], "line": d[3], "got": false})

# ------------------------------------------------------------ moving things
func swing_state() -> Vector3:
	var th: float = SWING.A*sin(time*TAU/SWING.T)
	return Vector3(SWING.px + SWING.L*sin(th), SWING.py - SWING.L*cos(th), th)

func step(dt: float) -> void:
	time += dt
	var s := swing_state()
	swing_mesh.position = Vector3(s.x, s.y, SWING.z)
	swing_mesh.rotation.z = -s.z*0.15
	swing_body.position = Vector3(s.x, s.y - SWING.h/2, SWING.z)
	for cn in canopy_nodes:
		var c: Dictionary = cn.c
		if not c.cut: continue
		c.t = minf(1.0, c.t + dt/1.1)
		var e := 1.0 - pow(1.0 - c.t, 3)
		var w: float = (c.x1 - c.x0)*e
		cn.cloth.visible = true
		cn.cloth.scale.x = maxf(0.01, w)
		cn.cloth.position.x = c.x0 + w/2
		cn.roll.position.x = c.x0 + w
		cn.roll.scale = Vector3(1 - e*0.85, 1, 1 - e*0.85)
		var shape: BoxShape3D = (cn.body.get_child(0) as CollisionShape3D).shape
		shape.size = Vector3(maxf(0.48, w), 0.3, c.z1 - c.z0)
		cn.body.position = Vector3(c.x0 + maxf(0.48, w)/2, c.y - 0.13, (c.z0 + c.z1)/2)
	for m in memory_nodes:
		if not m.got:
			m.node.rotation.y += dt*2
			m.node.position.y = m.y + sin(time*2 + m.x)*0.08

func cut_canopy(i: int) -> void:
	CANOPIES[i].cut = true
	CANOPIES[i].t = 0.0

func reset() -> void:
	for cn in canopy_nodes:
		cn.c.cut = false; cn.c.t = 0.0; cn.cloth.visible = false
		cn.roll.position.x = cn.c.x0; cn.roll.scale = Vector3.ONE
		(cn.body.get_child(0) as CollisionShape3D).shape.size = Vector3(0.48, 0.48, cn.c.z1 - cn.c.z0)
		cn.body.position = Vector3(cn.c.x0, cn.c.y, (cn.c.z0 + cn.c.z1)/2)
	for m in memory_nodes:
		m.got = false; m.node.visible = true

# ------------------------------------------------------------ where is shade?
## Casts a ray toward the sun from points along every walkway near x, and records the shaded runs.
func compute_shadows(x0: float, x1: float) -> void:
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.new()
	q.collision_mask = CASTER
	q.hit_from_inside = false
	var out := []
	for p in PL:
		if p.get("wall", false) or p.x1 < x0 or p.x0 > x1: continue
		var a: float = maxf(p.x0, x0)
		var b: float = minf(p.x1, x1)
		var start := -1.0
		var x := a
		while x <= b + 0.001:
			var from := Vector3(x, p.top + 0.03, 0)
			q.from = from
			q.to = from + TO_SUN*90.0
			var hit := not space.intersect_ray(q).is_empty()
			if hit and start < 0: start = x
			if (not hit or x + 0.1 > b) and start >= 0:
				var e: float = b if hit else x
				if e - start > 0.15: out.append({"x1": start, "x2": e, "y": p.top})
				start = -1.0
			x += 0.1
	shadows = out

func shade_at(x: float, y: float) -> bool:
	for s in shadows:
		if absf(s.y - y) < 0.05 and x >= s.x1 and x <= s.x2: return true
	return false

func solid_at(x: float, y: float, hw := 0.25, h := 1.75) -> bool:
	for p in PL:
		if x + hw > p.x0 and x - hw < p.x1 and y + h > p.bottom + 0.001 and y + 0.001 < p.top: return true
	return false

func floor_under(x: float, y: float) -> Dictionary:
	for p in PL:
		if not p.get("wall", false) and x >= p.x0 and x <= p.x1 and absf(y - p.top) < 0.05: return p
	return {}
