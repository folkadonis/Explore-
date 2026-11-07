## World-building toolkit: materials, mesh merging, Chola architecture, people, animals.
class_name Build
extends RefCounted

# ---------------------------------------------------------------- materials
static var _mats := {}

static func tex(path: String) -> Texture2D:
	return load("res://assets/tex/" + path) as Texture2D

## A stone or earth surface mapped in world space, so texture scale is the same on every face.
static func surface(key: String, path: String, metres: float, rough := 0.88, tint := Color.WHITE) -> StandardMaterial3D:
	if _mats.has(key): return _mats[key]
	var m := StandardMaterial3D.new()
	m.albedo_texture = tex(path)
	m.albedo_color = tint
	m.uv1_triplanar = true
	m.uv1_world_triplanar = true
	m.uv1_scale = Vector3.ONE / metres
	m.roughness = rough
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	_mats[key] = m
	return m

static func flat(key: String, col: Color, rough := 0.85, metal := 0.0) -> StandardMaterial3D:
	if _mats.has(key): return _mats[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = col
	m.roughness = rough
	m.metallic = metal
	_mats[key] = m
	return m

static func glow(key: String, col: Color, energy := 2.0) -> StandardMaterial3D:
	if _mats.has(key): return _mats[key]
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = col
	m.emission_enabled = true
	m.emission = col
	m.emission_energy_multiplier = energy
	_mats[key] = m
	return m

static func M(name: String) -> Material:
	match name:
		"mason": return surface("mason", "TEX-01_granite-ashlar.jpg", 6.5)
		"flag": return surface("flag", "TEX-02_flagstone.jpg", 6.0, 0.8)
		"flagOld": return surface("flagOld", "MAT-flagstone-old.jpg", 3.0, 0.8)
		"dark": return surface("dark", "MAT-charnockite.jpg", 5.0, 0.7, Color(0.75, 0.72, 0.8))
		"stone": return surface("stone", "MAT-statue-cloth.jpg", 1.2, 0.85, Color(1.05, 1.0, 0.97))
		"stoneBig": return surface("stoneBig", "MAT-granite-sun.jpg", 2.5, 0.85)
		"earth": return surface("earth", "TEX-05_arena-earth.jpg", 5.0, 0.95)
		"streets": return surface("streets", "MAT-earth-hoof.jpg", 6.0, 0.95)
		"wood": return surface("wood", "MAT-teak.jpg", 1.6, 0.8)
		"thatch": return surface("thatch", "MAT-thatch.jpg", 2.0, 1.0)
		"weave": return surface("weave", "MAT-palm-weave.jpg", 1.4, 0.95)
		"tile": return surface("tile", "MAT-roof-tile.jpg", 2.0, 0.85)
		"plaster": return surface("plaster", "MAT-plaster-brick.jpg", 3.0, 0.95)
		"gold": return flat("gold", Color(0.85, 0.64, 0.25), 0.28, 1.0)
		"brass": return flat("brass", Color(0.79, 0.6, 0.28), 0.32, 1.0)
		"bronze": return flat("bronze", Color(0.66, 0.42, 0.23), 0.38, 1.0)
		"skin": return flat("skin", Color(0.54, 0.33, 0.21), 0.55)
		"cotton": return flat("cotton", Color(0.92, 0.87, 0.77), 0.92)
		"sash": return flat("sash", Color(0.64, 0.12, 0.11), 0.6)
		"hair": return flat("hair", Color(0.08, 0.05, 0.04), 0.45)
		"silk": return flat("silk", Color(0.89, 0.72, 0.3), 0.4)
		"indigo": return flat("indigo", Color(0.17, 0.25, 0.48), 0.85)
		"saffron": return flat("saffron", Color(0.85, 0.54, 0.11), 0.6)
		"flame": return glow("flame", Color(1.0, 0.62, 0.25), 3.0)
	return flat(name, Color.MAGENTA)

static func banner_mat() -> StandardMaterial3D:
	if _mats.has("banner"): return _mats["banner"]
	var m := StandardMaterial3D.new()
	m.albedo_texture = tex("PRP-07_banner-cloth.jpg")
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.roughness = 0.6
	_mats["banner"] = m
	return m

static func plinth_mat(repeat: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_texture = tex("ARC-05_plinth-strip.jpg")
	m.uv1_scale = Vector3(repeat, 1, 1)
	m.roughness = 0.88
	return m

# ---------------------------------------------------------------- mesh merging
## Collects primitives per material and commits them as one mesh each (few draw calls).
class MB:
	var parts := {}
	func add(mesh: Mesh, mat: Material, xf: Transform3D) -> void:
		if not parts.has(mat):
			var st := SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLES)
			parts[mat] = st
		(parts[mat] as SurfaceTool).append_from(mesh, 0, xf)
	func commit(parent: Node3D, shadows := true) -> Array:
		var out := []
		for mat in parts:
			var mi := MeshInstance3D.new()
			mi.mesh = (parts[mat] as SurfaceTool).commit()
			mi.material_override = mat
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if shadows else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			parent.add_child(mi)
			out.append(mi)
		return out
	func meshes() -> Dictionary:
		var out := {}
		for mat in parts: out[mat] = (parts[mat] as SurfaceTool).commit()
		return out

static func xf(pos: Vector3, rot := Vector3.ZERO, scl := Vector3.ONE) -> Transform3D:
	var b := Basis.from_euler(rot, EULER_ORDER_XYZ).scaled(scl)
	return Transform3D(b, pos)

static func box(w: float, h: float, d: float) -> BoxMesh:
	var m := BoxMesh.new(); m.size = Vector3(w, h, d); return m
static func sph(r: float, seg := 16, rings := 10) -> SphereMesh:
	var m := SphereMesh.new(); m.radius = r; m.height = r*2; m.radial_segments = seg; m.rings = rings; return m
static func cyl(rt: float, rb: float, h: float, seg := 12) -> CylinderMesh:
	var m := CylinderMesh.new(); m.top_radius = rt; m.bottom_radius = rb; m.height = h; m.radial_segments = seg; m.rings = 1; return m
static func cap(r: float, len: float, seg := 10) -> CapsuleMesh:
	var m := CapsuleMesh.new(); m.radius = r; m.height = len + r*2; m.radial_segments = seg; m.rings = 4; return m

static func node(parent: Node, mesh: Mesh, mat: Material, pos := Vector3.ZERO, rot := Vector3.ZERO, scl := Vector3.ONE, shadows := true) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	mi.rotation_order = EULER_ORDER_XYZ
	mi.rotation = rot
	mi.scale = scl
	if not shadows: mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	return mi

# ---------------------------------------------------------------- architecture
## A Dravidian vimana: stepped tiers ringed by miniature shrines, octagonal dome, gold finial.
static func vimana(mb: MB, base: Vector3, W: float, tiers: int, stone: Material, taper := 0.62, tier_h := 0.2) -> float:
	var gold := M("gold")
	var bh := W*0.42
	mb.add(box(W, bh, W), stone, xf(base + Vector3(0, bh/2, 0)))
	for i in 6:
		var t := -W/2 + (i + 0.5)*W/6
		for s in [-1, 1]:
			mb.add(box(W*0.05, bh*0.9, 0.12), stone, xf(base + Vector3(t, bh*0.45, s*W/2)))
			mb.add(box(0.12, bh*0.9, W*0.05), stone, xf(base + Vector3(s*W/2, bh*0.45, t)))
	mb.add(box(W*1.08, W*0.04, W*1.08), stone, xf(base + Vector3(0, bh, 0)))
	var y := bh
	var s := W
	for i in tiers:
		var s2 := W*(1.0 - float(i + 1)/(tiers + 1)*taper)
		var th := W*tier_h*(1.0 - i*0.02)
		mb.add(box(s2, th*0.62, s2), stone, xf(base + Vector3(0, y + th*0.31, 0)))
		mb.add(box(s2*1.06, th*0.06, s2*1.06), stone, xf(base + Vector3(0, y + th*0.62, 0)))
		var c := (s - s2)/2*0.9 + 0.05
		var ky := y + c*0.35
		for sx in [-1, 1]:
			for sz in [-1, 1]:
				var p := base + Vector3(sx*(s/2 - c/2), ky, sz*(s/2 - c/2))
				mb.add(box(c, c*0.7, c), stone, xf(p))
				mb.add(sph(c*0.5, 8, 5), stone, xf(p + Vector3(0, c*0.35, 0), Vector3.ZERO, Vector3(1, 0.7, 1)))
		var n := maxi(1, roundi((s - 2*c)/(c*2.2)))
		for j in n:
			var t := -s/2 + c + (j + 0.5)*(s - 2*c)/n
			for sd in [-1, 1]:
				mb.add(box(c*1.4, c*0.62, c*0.9), stone, xf(base + Vector3(t, ky, sd*(s/2 - c*0.45))))
				mb.add(cyl(c*0.45, c*0.45, c*1.4, 8), stone, xf(base + Vector3(t, ky + c*0.31, sd*(s/2 - c*0.45)), Vector3(0, 0, PI/2), Vector3(1, 1, 0.6)))
				mb.add(box(c*0.9, c*0.62, c*1.4), stone, xf(base + Vector3(sd*(s/2 - c*0.45), ky, t)))
		y += th
		s = s2
	mb.add(cyl(s*0.34, s*0.38, s*0.3, 8), stone, xf(base + Vector3(0, y + s*0.15, 0)))
	mb.add(sph(s*0.55, 8, 6), stone, xf(base + Vector3(0, y + s*0.35, 0), Vector3.ZERO, Vector3(1, 0.85, 1)))
	mb.add(cyl(0.0, s*0.1, s*0.32, 10), gold, xf(base + Vector3(0, y + s*0.95, 0)))
	mb.add(sph(s*0.09, 10, 6), gold, xf(base + Vector3(0, y + s*0.84, 0)))
	return y + s*1.1

## A gopuram: oblong gateway tower with a barrel-vault roof and a row of gold kalashas.
static func gopuram(mb: MB, base: Vector3, W: float, D: float, tiers: int, stone: Material) -> void:
	var gold := M("gold")
	var y := W*0.35
	mb.add(box(W, y, D), stone, xf(base + Vector3(0, y/2, 0)))
	var w := W
	var d := D
	for i in tiers:
		var w2 := w*0.9
		var d2 := d*0.82
		var th := W*0.13
		mb.add(box(w2, th*0.7, d2), stone, xf(base + Vector3(0, y + th*0.35, 0)))
		mb.add(box(w2*1.05, th*0.07, d2*1.08), stone, xf(base + Vector3(0, y + th*0.7, 0)))
		for j in 7:
			var t := -w2/2 + (j + 0.5)*w2/7
			mb.add(box(w2/12, th*0.5, 0.2), stone, xf(base + Vector3(t, y + th*0.3, d2/2)))
		y += th
		w = w2
		d = d2
	mb.add(cyl(d*0.55, d*0.55, w, 12), stone, xf(base + Vector3(0, y, 0), Vector3(0, 0, PI/2), Vector3(1, 1, 0.9)))
	for j in 7:
		var t := -w/2*0.85 + j*(w*0.85)/6
		mb.add(sph(d*0.09, 8, 6), gold, xf(base + Vector3(t, y + d*0.55, 0)))
		mb.add(cyl(0.0, d*0.05, d*0.2, 8), gold, xf(base + Vector3(t, y + d*0.7, 0)))

## A Chola pillar: square base, alternating square and octagonal shaft, pot capital, corbel brackets.
static func pillar(mb: MB, base: Vector3, H: float, stone: Material) -> void:
	mb.add(box(0.7, 0.5, 0.7), stone, xf(base + Vector3(0, 0.25, 0)))
	var y := 0.5
	var seg := (H - 1.6)/5.0
	for i in 5:
		if i % 2 == 0: mb.add(box(0.5, seg, 0.5), stone, xf(base + Vector3(0, y + seg/2, 0)))
		else: mb.add(cyl(0.24, 0.24, seg, 8), stone, xf(base + Vector3(0, y + seg/2, 0), Vector3(0, PI/8, 0)))
		mb.add(box(0.54, 0.06, 0.54), stone, xf(base + Vector3(0, y + seg, 0)))
		y += seg
	mb.add(sph(0.32, 12, 8), stone, xf(base + Vector3(0, y + 0.22, 0), Vector3.ZERO, Vector3(1, 0.8, 1)))
	y += 0.48
	mb.add(box(0.8, 0.12, 0.8), stone, xf(base + Vector3(0, y + 0.06, 0)))
	y += 0.12
	mb.add(box(1.5, 0.3, 0.32), stone, xf(base + Vector3(0, y + 0.15, 0)))
	mb.add(box(0.32, 0.3, 1.5), stone, xf(base + Vector3(0, y + 0.15, 0)))
	y += 0.3
	mb.add(box(0.4, H - y, 0.4), stone, xf(base + Vector3(0, y + (H - y)/2, 0)))

# ---------------------------------------------------------------- people
## A jointed figure built from rounded primitives. Returns a dictionary of joints.
static func rig(mats: Dictionary, opt := {}) -> Dictionary:
	var skin: Material = mats.get("skin", M("skin"))
	var cloth: Material = mats.get("cloth", skin)
	var hair: Material = mats.get("hair", skin)
	var root := Node3D.new()
	var tilt := Node3D.new(); root.add_child(tilt)
	var pelvis := Node3D.new(); pelvis.position = Vector3(0, 0.95, 0); tilt.add_child(pelvis)
	var spine := Node3D.new(); spine.position = Vector3(0, 0.02, 0); pelvis.add_child(spine)
	var js := [tilt, pelvis, spine]
	node(spine, cap(0.125, 0.14), skin, Vector3(0, 0.13, 0), Vector3.ZERO, Vector3(1.15, 1, 0.82))
	node(spine, cap(0.155, 0.16), skin, Vector3(0, 0.36, 0), Vector3.ZERO, Vector3(1.32, 1, 0.84))
	var neck := Node3D.new(); neck.position = Vector3(0, 0.53, 0); spine.add_child(neck)
	node(neck, cyl(0.052, 0.06, 0.12, 8), skin, Vector3(0, 0.04, 0))
	var head := Node3D.new(); head.position = Vector3(0, 0.1, 0.005); neck.add_child(head)
	node(head, sph(0.1, 14, 10), skin, Vector3(0, 0.1, 0), Vector3.ZERO, Vector3(0.88, 1.12, 1))
	node(head, sph(0.06, 10, 6), skin, Vector3(0, 0.035, 0.035), Vector3.ZERO, Vector3(1.05, 0.8, 1))
	node(head, box(0.025, 0.05, 0.04), skin, Vector3(0, 0.09, 0.1))
	node(head, sph(0.104, 14, 8), hair, Vector3(0, 0.125, -0.02), Vector3.ZERO, Vector3(0.9, 1.0, 1.02))
	node(head, sph(0.058, 10, 8), hair, Vector3(0, 0.215, -0.045))
	if mats.has("eye"):
		node(head, sph(0.016, 8, 6), mats["eye"], Vector3(0.035, 0.115, 0.088), Vector3.ZERO, Vector3.ONE, false)
		node(head, sph(0.016, 8, 6), mats["eye"], Vector3(-0.035, 0.115, 0.088), Vector3.ZERO, Vector3.ONE, false)
	var sh := []
	var el := []
	var hip := []
	var kn := []
	for s in [-1, 1]:
		var S := Node3D.new(); S.position = Vector3(s*0.205, 0.45, -0.005); spine.add_child(S); sh.append(S)
		node(S, sph(0.07, 10, 8), skin)
		node(S, cap(0.052, 0.2), skin, Vector3(0, -0.15, 0))
		var E := Node3D.new(); E.position = Vector3(0, -0.3, 0); S.add_child(E); el.append(E)
		node(E, cap(0.043, 0.18), skin, Vector3(0, -0.13, 0))
		node(E, sph(0.048, 8, 6), skin, Vector3(0, -0.29, 0.01), Vector3.ZERO, Vector3(0.7, 1.15, 0.9))
		if opt.get("armband", false) and s == 1:
			node(S, cyl(0.06, 0.06, 0.03, 12), M("bronze"), Vector3(0, -0.11, 0))
			node(S, sph(0.025, 6, 4), opt.get("shard", M("hair")), Vector3(0.02, -0.11, 0.058), Vector3.ZERO, Vector3(1, 1.6, 1), false)
		var Hh := Node3D.new(); Hh.position = Vector3(s*0.095, -0.02, 0); pelvis.add_child(Hh); hip.append(Hh)
		node(Hh, cap(0.078, 0.3), cloth, Vector3(0, -0.22, 0))
		var K := Node3D.new(); K.position = Vector3(0, -0.45, 0); Hh.add_child(K); kn.append(K)
		node(K, cap(0.056, 0.3), skin, Vector3(0, -0.2, 0))
		node(K, box(0.085, 0.06, 0.22), skin, Vector3(0, -0.43, 0.05))
	node(pelvis, cyl(0.155, 0.175, 0.24, 14), cloth, Vector3(0, -0.04, 0))
	if opt.get("sash", false):
		node(pelvis, cyl(0.172, 0.172, 0.07, 16), M("sash"), Vector3(0, 0.06, 0), Vector3.ZERO, Vector3(1, 1, 0.84))
		node(pelvis, box(0.07, 0.34, 0.02), M("sash"), Vector3(-0.08, -0.12, 0.15), Vector3(0, 0, 0.12))
	var sword: Node3D = null
	if opt.get("sword", false):
		sword = Node3D.new(); el[1].add_child(sword); sword.position = Vector3(0, -0.3, 0)
		node(sword, box(0.03, 0.62, 0.012), M("bronze"), Vector3(0, -0.3, 0.05), Vector3(-0.35, 0, 0))
		sword.visible = false
	for n in [root, tilt, pelvis, spine, neck, head] + sh + el + hip + kn:
		(n as Node3D).rotation_order = EULER_ORDER_XYZ
	return {"root": root, "tilt": tilt, "pelvis": pelvis, "spine": spine, "neck": neck, "head": head, "sh": sh, "el": el, "hip": hip, "kn": kn, "sword": sword}

## Pose library. Angles in radians; +x on a hip swings the leg back.
static func pose(r: Dictionary, name: String, phase := 0.0, t := 0.0, atk := 0.0) -> void:
	var sh: Array = r.sh; var el: Array = r.el; var hip: Array = r.hip; var kn: Array = r.kn
	(r.pelvis as Node3D).position.y = 0.95
	(r.spine as Node3D).rotation = Vector3(0.04, 0, 0)
	(r.neck as Node3D).rotation = Vector3.ZERO
	(r.head as Node3D).rotation = Vector3.ZERO
	match name:
		"run":
			var sw := sin(phase)
			hip[0].rotation = Vector3(sw*0.75, 0, 0); hip[1].rotation = Vector3(-sw*0.75, 0, 0)
			kn[0].rotation = Vector3(0.25 + maxf(0, cos(phase))*1.15, 0, 0); kn[1].rotation = Vector3(0.25 + maxf(0, -cos(phase))*1.15, 0, 0)
			sh[0].rotation = Vector3(-sw*0.7, 0, -0.1); sh[1].rotation = Vector3(sw*0.7, 0, 0.1)
			el[0].rotation = Vector3(-0.9, 0, 0); el[1].rotation = Vector3(-0.9, 0, 0)
			r.spine.rotation = Vector3(0.16, 0, 0); r.pelvis.position.y = 0.92 + absf(cos(phase))*0.05
		"air":
			hip[0].rotation = Vector3(-0.9, 0, 0); hip[1].rotation = Vector3(0.3, 0, 0); kn[0].rotation = Vector3(1.2, 0, 0); kn[1].rotation = Vector3(0.8, 0, 0)
			sh[0].rotation = Vector3(-1.4, 0, -0.4); sh[1].rotation = Vector3(0.5, 0, 0.5); el[0].rotation = Vector3(-0.6, 0, 0); el[1].rotation = Vector3(-0.5, 0, 0)
			r.spine.rotation = Vector3(0.1, 0, 0)
		"cheer":
			hip[0].rotation = Vector3(-0.05, 0, -0.06); hip[1].rotation = Vector3(0.2, 0, 0.04); kn[0].rotation = Vector3(0.05, 0, 0); kn[1].rotation = Vector3(0.3, 0, 0)
			sh[0].rotation = Vector3(-0.2, 0, -2.5); sh[1].rotation = Vector3(-0.3, 0, 2.7); el[0].rotation = Vector3(-0.4, 0, 0); el[1].rotation = Vector3(-0.3, 0, 0)
			r.spine.rotation = Vector3(-0.08, 0, 0); r.head.rotation = Vector3(-0.25, 0, 0)
		"drum":
			hip[0].rotation = Vector3(-0.1, 0, -0.1); hip[1].rotation = Vector3(0.1, 0, 0.1); kn[0].rotation = Vector3(0.2, 0, 0); kn[1].rotation = Vector3(0.2, 0, 0)
			sh[0].rotation = Vector3(-0.9, 0, -0.5); sh[1].rotation = Vector3(-1.6, 0, 0.3); el[0].rotation = Vector3(-1.3, 0, 0); el[1].rotation = Vector3(-0.7, 0, 0)
		"namaskaram":
			for i in 2:
				hip[i].rotation = Vector3.ZERO
				kn[i].rotation = Vector3.ZERO
			sh[0].rotation = Vector3(-0.9, 0, 0.25); sh[1].rotation = Vector3(-0.9, 0, -0.25); el[0].rotation = Vector3(-1.6, 0.6, 0); el[1].rotation = Vector3(-1.6, -0.6, 0)
			r.head.rotation = Vector3(0.2, 0, 0); r.spine.rotation = Vector3(0.12, 0, 0)
		"crown":
			hip[0].rotation = Vector3(0, 0, -0.05); hip[1].rotation = Vector3(0, 0, 0.05); kn[0].rotation = Vector3.ZERO; kn[1].rotation = Vector3.ZERO
			sh[0].rotation = Vector3(-2.75, 0, -0.18); sh[1].rotation = Vector3(-2.75, 0, 0.18); el[0].rotation = Vector3(-0.45, 0, 0); el[1].rotation = Vector3(-0.45, 0, 0)
			r.head.rotation = Vector3(-0.12, 0, 0)
		"hunch":
			var sw2 := sin(phase)*0.45
			hip[0].rotation = Vector3(sw2 - 0.2, 0, 0); hip[1].rotation = Vector3(-sw2 - 0.2, 0, 0); kn[0].rotation = Vector3(0.7, 0, 0); kn[1].rotation = Vector3(0.7, 0, 0)
			r.spine.rotation = Vector3(0.55, 0, 0); r.head.rotation = Vector3(-0.45, 0, 0)
			sh[0].rotation = Vector3(-0.9 + sw2, 0, -0.35); sh[1].rotation = Vector3(-0.9 - sw2, 0, 0.35); el[0].rotation = Vector3(-0.5, 0, 0); el[1].rotation = Vector3(-0.5, 0, 0)
			r.pelvis.position.y = 0.82
		"ready":
			var b := sin(t*5)*0.03
			hip[0].rotation = Vector3(-0.45, 0, -0.25); hip[1].rotation = Vector3(-0.2, 0, 0.25); kn[0].rotation = Vector3(0.8, 0, 0); kn[1].rotation = Vector3(0.6, 0, 0)
			r.spine.rotation = Vector3(0.4 + b, 0, 0); r.head.rotation = Vector3(-0.35, 0, 0)
			sh[0].rotation = Vector3(-0.9, 0, -0.5); sh[1].rotation = Vector3(-0.9, 0, 0.5); el[0].rotation = Vector3(-0.4, 0, 0); el[1].rotation = Vector3(-0.4, 0, 0)
			r.pelvis.position.y = 0.78 + b
		"ride":
			hip[0].rotation = Vector3(-1.25, 0, -0.55); hip[1].rotation = Vector3(-1.25, 0, 0.55); kn[0].rotation = Vector3(1.5, 0, 0); kn[1].rotation = Vector3(1.5, 0, 0)
			r.spine.rotation = Vector3(1.05, 0, 0); r.head.rotation = Vector3(-0.75, 0, 0)
			sh[0].rotation = Vector3(-1.55, 0, 0.35); sh[1].rotation = Vector3(-1.55, 0, -0.35); el[0].rotation = Vector3(-0.55, 0, 0); el[1].rotation = Vector3(-0.55, 0, 0)
		_:  # idle
			var bb := sin(t*1.6)*0.015
			hip[0].rotation = Vector3(0.02, 0, -0.03); hip[1].rotation = Vector3(-0.04, 0, 0.03); kn[0].rotation = Vector3(0.06, 0, 0); kn[1].rotation = Vector3(0.1, 0, 0)
			sh[0].rotation = Vector3(0.04, 0, -0.12 - bb); sh[1].rotation = Vector3(-0.02, 0, 0.12 + bb); el[0].rotation = Vector3(-0.15, 0, 0); el[1].rotation = Vector3(-0.2, 0, 0)
			r.spine.rotation = Vector3(0.02 + bb, 0, 0)
	if atk > 0.0:
		sh[1].rotation = Vector3(-1.9 + (1.0 - atk/0.22)*2.4, 0, 0.3); el[1].rotation = Vector3(-0.2, 0, 0)

## Transform of `n` relative to `root`, without needing the nodes in the scene tree.
static func rel(n: Node3D, root: Node3D) -> Transform3D:
	var t := n.transform
	var p := n.get_parent()
	while p != null and p != root:
		t = (p as Node3D).transform * t
		p = p.get_parent()
	return t

## Bake a posed figure (or any node tree) into merged meshes: one per material.
static func bake(root: Node3D, mb: MB, at := Transform3D.IDENTITY) -> void:
	var stack := [root]
	while stack.size() > 0:
		var n: Node = stack.pop_back()
		for c in n.get_children(): stack.append(c)
		if n is MeshInstance3D and (n as MeshInstance3D).visible:
			mb.add((n as MeshInstance3D).mesh, (n as MeshInstance3D).material_override, at * rel(n, root))

## A whole statue of one pose, merged, in granite (metal left bright).
static func statue_meshes(pose_name: String, opt := {}) -> Dictionary:
	var r := rig({"skin": M("stone"), "cloth": M("stone"), "hair": M("stone")})
	pose(r, pose_name)
	if pose_name == "drum": node(r.root, cyl(0.17, 0.17, 0.42, 14), M("stone"), Vector3(0, 1.12, 0.22), Vector3(0, 0, PI/2))
	if pose_name == "crown": node(r.root, cyl(0.06, 0.12, 0.3, 14), M("gold"), Vector3(0, 2.02, 0.05))
	var mb := MB.new()
	bake(r.root, mb)
	(r.root as Node3D).free()
	return mb.meshes()

# ---------------------------------------------------------------- animals
static func _ep(mb: MB, T: Transform3D, mesh: Mesh, mat: Material, p: Vector3, rot := Vector3.ZERO, s := Vector3.ONE) -> void:
	mb.add(mesh, mat, T * xf(p, rot, s))

## The temple elephant in granite, built facing +x. Returns proxy boxes for its shade.
static func elephant(mb: MB, at: Vector3, yaw := 0.0) -> Array:
	var st := M("stoneBig")
	var gold := M("gold")
	var T := Transform3D(Basis(Vector3.UP, yaw), at)
	_ep(mb, T, sph(1.0, 20, 14), st, Vector3(0, 2.1, 0), Vector3.ZERO, Vector3(2.0, 1.12, 0.98))
	_ep(mb, T, sph(1.0, 16, 10), st, Vector3(0.9, 2.45, 0), Vector3.ZERO, Vector3(0.8, 0.7, 0.85))
	for p in [Vector2(1.25, 0.52), Vector2(1.25, -0.52), Vector2(-1.25, 0.52), Vector2(-1.25, -0.52)]:
		_ep(mb, T, cyl(0.3, 0.34, 1.6, 12), st, Vector3(p.x, 0.8, p.y))
		_ep(mb, T, cyl(0.38, 0.38, 0.12, 12), st, Vector3(p.x, 0.06, p.y))
	_ep(mb, T, sph(0.78, 16, 12), st, Vector3(2.15, 2.65, 0), Vector3.ZERO, Vector3(0.95, 1.05, 0.9))
	for s in [-1, 1]: _ep(mb, T, sph(0.75, 12, 8), st, Vector3(1.95, 2.55, s*0.68), Vector3(0, s*0.35, 0), Vector3(0.12, 1.05, 0.95))
	var trunk := [Vector3(2.75, 2.5, 0), Vector3(3.15, 1.9, 0), Vector3(3.25, 1.1, 0), Vector3(3.2, 0.45, 0)]
	for i in 3:
		var a: Vector3 = trunk[i]; var b: Vector3 = trunk[i + 1]
		var mid := (a + b)/2; var dir := b - a
		_ep(mb, T, cyl(0.2 - i*0.04, 0.24 - i*0.04, dir.length() + 0.1, 10), st, mid, Vector3(0, 0, atan2(-dir.x, dir.y)))
	for s in [-1, 1]: _ep(mb, T, cyl(0.0, 0.07, 0.75, 8), st, Vector3(2.85, 1.95, s*0.28), Vector3(0, 0, -2.2))
	_ep(mb, T, box(2.3, 0.06, 2.1), st, Vector3(0, 3.14, 0))
	for s in [-1, 1]: _ep(mb, T, box(2.3, 1.1, 0.05), st, Vector3(0, 2.62, s*1.04))
	_ep(mb, T, box(1.5, 0.12, 1.3), st, Vector3(0, 3.24, 0))
	for p in [Vector2(0.65, 0.55), Vector2(0.65, -0.55), Vector2(-0.65, 0.55), Vector2(-0.65, -0.55)]: _ep(mb, T, cyl(0.05, 0.05, 1.0, 6), st, Vector3(p.x, 3.8, p.y))
	_ep(mb, T, cyl(0.0, 1.05, 0.7, 4), st, Vector3(0, 4.62, 0), Vector3(0, PI/4, 0))
	_ep(mb, T, box(0.08, 0.7, 0.55), gold, Vector3(2.82, 2.8, 0), Vector3(0, 0, 0.25))
	for i in 9:
		var a2 := (i/8.0 - 0.5)*2.2
		_ep(mb, T, sph(0.065, 8, 6), gold, Vector3(1.4 + cos(a2)*0.1, 1.75 - absf(a2)*0.08, sin(a2)*0.78))
	for s in [-1, 1]: _ep(mb, T, box(2.3, 0.08, 0.06), gold, Vector3(0, 2.08, s*1.07))
	# shade-casting boxes (centre, size), in world space
	return [[at + Vector3(0, 2.12, 0), Vector3(3.9, 2.15, 1.9)], [at + Vector3(2.15, 2.68, 0), Vector3(1.5, 1.55, 1.44)],
		[at + Vector3(0, 4.07, 0), Vector3(1.5, 1.75, 1.3)], [at + Vector3(1.25, 0.8, 0.52), Vector3(0.64, 1.6, 0.64)],
		[at + Vector3(1.25, 0.8, -0.52), Vector3(0.64, 1.6, 0.64)], [at + Vector3(-1.25, 0.8, 0.52), Vector3(0.64, 1.6, 0.64)],
		[at + Vector3(-1.25, 0.8, -0.52), Vector3(0.64, 1.6, 0.64)]]

## A zebu bull with a big hump, painted horns, brass caps, garland and the coin cloth. Faces -x.
static func bull(coat: Color, horn: Color) -> Dictionary:
	var skin := StandardMaterial3D.new(); skin.albedo_color = coat; skin.roughness = 0.7
	var hm := StandardMaterial3D.new(); hm.albedo_color = horn; hm.roughness = 0.45
	var root := Node3D.new()
	var body := Node3D.new(); root.add_child(body)
	node(body, sph(1.0, 20, 14), skin, Vector3(0, 1.18, 0), Vector3.ZERO, Vector3(1.05, 0.55, 0.42))
	node(body, sph(1.0, 16, 10), skin, Vector3(0.5, 1.28, 0), Vector3.ZERO, Vector3(0.55, 0.56, 0.45))
	node(body, sph(0.34, 14, 10), skin, Vector3(0.42, 1.78, 0), Vector3.ZERO, Vector3(1, 1.15, 0.78))
	node(body, sph(1.0, 14, 10), skin, Vector3(-0.65, 1.22, 0), Vector3.ZERO, Vector3(0.46, 0.5, 0.41))
	node(body, cyl(0.2, 0.3, 0.7, 12), skin, Vector3(1.0, 1.42, 0), Vector3(0, 0, -1.0), Vector3(1, 1, 0.9))
	node(body, sph(1.0, 12, 8), skin, Vector3(0.95, 0.9, 0), Vector3.ZERO, Vector3(0.42, 0.38, 0.07))
	var head := Node3D.new(); head.position = Vector3(1.32, 1.52, 0); body.add_child(head)
	node(head, sph(1.0, 14, 10), skin, Vector3(0.12, -0.06, 0), Vector3(0, 0, -0.6), Vector3(0.3, 0.18, 0.16))
	node(head, sph(1.0, 10, 8), skin, Vector3(0.3, -0.25, 0), Vector3.ZERO, Vector3(0.13, 0.11, 0.12))
	for s in [-1, 1]:
		node(head, sph(1.0, 8, 6), skin, Vector3(0.02, 0.0, s*0.18), Vector3.ZERO, Vector3(0.1, 0.05, 0.13))
		node(head, cyl(0.026, 0.038, 0.36, 8), hm, Vector3(0.0, 0.25, s*0.16), Vector3(s*0.45, 0, 0.1))
		node(head, cyl(0.016, 0.026, 0.3, 8), hm, Vector3(0.06, 0.55, s*0.22), Vector3(-s*0.2, 0, -0.35))
		node(head, sph(0.04, 8, 6), M("brass"), Vector3(0.12, 0.7, s*0.19))
	var cloth := Node3D.new(); cloth.position = Vector3(0.04, 0.4, 0); head.add_child(cloth)
	node(cloth, sph(0.085, 10, 8), M("sash"), Vector3.ZERO, Vector3.ZERO, Vector3(1, 0.8, 1.7))
	for i in 3: node(cloth, cyl(0.026, 0.026, 0.006, 10), M("gold"), Vector3(-0.02 + i*0.02, -0.06, -0.05 + i*0.05), Vector3(PI/2, 0, 0))
	var garland := flat("kanakambaram", Color(0.91, 0.44, 0.1), 0.8)
	for i in 14:
		var a := i/13.0*PI*2
		node(body, sph(0.06, 6, 4), garland if i % 3 else flat("jasmine", Color(0.95, 0.93, 0.86)), Vector3(1.02 + cos(a)*0.08, 1.3 + sin(a)*0.26, sin(a + PI/2)*0.24))
	for i in 5:
		var a3 := (i/4.0 - 0.5)*1.8
		node(body, sph(0.045, 8, 6), M("brass"), Vector3(1.0, 1.05 - absf(a3)*0.05, sin(a3)*0.25))
	var legs := []
	for p in [Vector3(0.7, 1.02, 0.2), Vector3(0.7, 1.02, -0.2), Vector3(-0.68, 1.02, 0.2), Vector3(-0.68, 1.02, -0.2)]:
		var L := Node3D.new(); L.position = p; L.rotation_order = EULER_ORDER_XYZ; body.add_child(L)
		node(L, cyl(0.075, 0.1, 0.55, 10), skin, Vector3(0, -0.27, 0))
		var K := Node3D.new(); K.position = Vector3(0, -0.53, 0); K.rotation_order = EULER_ORDER_XYZ; L.add_child(K)
		node(K, cyl(0.05, 0.06, 0.42, 8), skin, Vector3(0, -0.2, 0))
		node(K, cyl(0.065, 0.055, 0.07, 8), M("hair"), Vector3(0, -0.44, 0))
		legs.append({"L": L, "K": K, "front": p.x > 0})
	var tail := Node3D.new(); tail.position = Vector3(-1.0, 1.35, 0); tail.rotation_order = EULER_ORDER_XYZ; body.add_child(tail)
	node(tail, cyl(0.02, 0.025, 0.8, 6), skin, Vector3(-0.05, -0.4, 0), Vector3(0, 0, 0.15))
	node(tail, sph(0.07, 8, 6), M("hair"), Vector3(-0.1, -0.82, 0), Vector3.ZERO, Vector3(1, 1.8, 1))
	body.rotation_order = EULER_ORDER_XYZ; head.rotation_order = EULER_ORDER_XYZ
	root.rotation.y = PI
	return {"root": root, "body": body, "head": head, "legs": legs, "tail": tail, "cloth": cloth, "ph": 0.0}

static func animate_bull(b: Dictionary, run: float, buck: float) -> void:
	var ph: float = b.ph
	var k := 0
	for lg in b.legs:
		var off := (0.0 if lg.front else PI) + (k % 2)*0.6
		(lg.L as Node3D).rotation.z = run*sin(ph + off)*0.65 + buck*(-0.5 if lg.front else 0.25)
		(lg.K as Node3D).rotation.z = -maxf(0, sin(ph + off + 1.2))*0.9*run - buck*(0.8 if lg.front else 0.0)
		k += 1
	(b.tail as Node3D).rotation.z = 0.3 + sin(ph*1.3)*0.4
