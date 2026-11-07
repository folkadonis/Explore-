## Interlude I: eru thazhuvuthal (jallikattu) on Mattu Pongal. One action: tap anywhere.
class_name Arena
extends Node3D

const AX := 1000.0
const ILAN_X := AX + 24.0
const BULLS := [
	{"name": "Vellaiyan", "house": "the house of Muthan the potter", "coat": Color(0.84, 0.81, 0.76), "horn": Color(0.7, 0.15, 0.17), "speed": 7.0, "ride_v": 1.7, "dist": 15.0, "period": 0.95, "win": 0.26, "pause": false},
	{"name": "Karuppan", "house": "the Pulikulam herders", "coat": Color(0.16, 0.14, 0.13), "horn": Color(0.16, 0.37, 0.69), "speed": 8.0, "ride_v": 1.9, "dist": 15.0, "period": 0.8, "win": 0.22, "pause": false},
	{"name": "Sivappan", "house": "the palace herd", "coat": Color(0.49, 0.23, 0.13), "horn": Color(0.85, 0.64, 0.25), "speed": 8.6, "ride_v": 2.0, "dist": 20.0, "period": 0.72, "win": 0.2, "pause": true},
]

var game   # main.gd
var bulls: Array = []
var people := {}
var crowd: Array = []
var young: Dictionary
var jk = null
var next_bull := 0
var score := 0
var best := 0

func build(g) -> void:
	game = g
	var mb := Build.MB.new()
	Build.node(self, Build.box(200, 0.2, 90), Build.M("earth"), Vector3(AX + 20, -0.1, -20))
	# barricade: timber posts, rails and woven palm-leaf panels
	var x := 0.0
	while x <= 46:
		mb.add(Build.cyl(0.08, 0.1, 1.9, 8), Build.M("wood"), Build.xf(Vector3(AX + x, 0.95, -2.6)))
		x += 1.6
	for y in [0.55, 1.15, 1.7]: mb.add(Build.cyl(0.05, 0.05, 46, 6), Build.M("wood"), Build.xf(Vector3(AX + 23, y, -2.6), Vector3(0, 0, PI/2)))
	mb.add(Build.box(46, 1.5, 0.05), Build.M("weave"), Build.xf(Vector3(AX + 23, 0.85, -2.72)))
	# stacked carts for the crowd, the elders' platform and its canopy
	mb.add(Build.box(46, 0.5, 1.8), Build.M("weave"), Build.xf(Vector3(AX + 23, 0.25, -4.0)))
	mb.add(Build.box(46, 1.1, 1.8), Build.M("weave"), Build.xf(Vector3(AX + 23, 0.55, -5.9)))
	mb.add(Build.box(5, 2.0, 3), Build.M("wood"), Build.xf(Vector3(AX + 20, 1.0, -6.6)))
	mb.add(Build.box(5.4, 0.06, 3.2), Build.M("saffron"), Build.xf(Vector3(AX + 20, 4.6, -6.6)))
	for p in [Vector2(17.4, -5.2), Vector2(22.6, -5.2), Vector2(17.4, -8), Vector2(22.6, -8)]: mb.add(Build.cyl(0.06, 0.06, 2.6, 8), Build.M("wood"), Build.xf(Vector3(AX + p.x, 3.3, p.y)))
	for cx in [4.0, 12.5, 26.5, 35.0, 43.0]:  # bullock carts behind the crowd
		mb.add(Build.box(2.4, 0.15, 1.3), Build.M("wood"), Build.xf(Vector3(AX + cx, 0.9, -7.4)))
		for s in [-1, 1]: mb.add(Build.cyl(0.62, 0.62, 0.1, 16), Build.M("wood"), Build.xf(Vector3(AX + cx, 0.62, -7.4 + s*0.72), Vector3(PI/2, 0, 0)))
	# the vaadivaasal: a narrow timber gate with a thatched roof, mango leaves, banana plants
	for z in [-1.3, 1.3]: mb.add(Build.box(0.5, 3.4, 0.5), Build.M("wood"), Build.xf(Vector3(AX + 42.5, 1.7, z)))
	mb.add(Build.box(0.7, 0.5, 3.4), Build.M("wood"), Build.xf(Vector3(AX + 42.5, 3.55, 0)))
	for i in 6:
		for z in [-1.3, 1.3]: mb.add(Build.box(0.22, 2.6, 0.22), Build.M("wood"), Build.xf(Vector3(AX + 44 + i*1.1, 1.3, z)))
	mb.add(Build.cyl(0.0, 2.0, 1.4, 4), Build.M("thatch"), Build.xf(Vector3(AX + 42.5, 4.4, 0), Vector3(0, PI/4, 0), Vector3(0.6, 1, 1.4)))
	var leaf := Build.flat("mango", Color(0.25, 0.48, 0.17), 0.7)
	for i in 30: mb.add(Build.box(0.02, 0.2, 0.06), leaf, Build.xf(Vector3(AX + 42.1, 3.15 - sin(i/29.0*PI)*0.15, -1.4 + i*0.097)))
	var green := Build.flat("banana", Color(0.33, 0.52, 0.2), 0.7)
	for p in [Vector2(41.8, -1.9), Vector2(41.4, 2.4), Vector2(-1.5, -2.4)]:
		mb.add(Build.cyl(0.11, 0.15, 2.4, 10), Build.flat("bstem", Color(0.56, 0.64, 0.35), 0.8), Build.xf(Vector3(AX + p.x, 1.2, p.y)))
		for k in 6: mb.add(Build.box(0.45, 0.03, 1.7), green, Build.xf(Vector3(AX + p.x + cos(k)*0.6, 2.5, p.y + sin(k)*0.6), Vector3(0.6, k, 0)))
	var cane := Build.flat("cane", Color(0.42, 0.29, 0.35), 0.6)
	for i in 9: mb.add(Build.cyl(0.03, 0.03, 2.4, 6), cane, Build.xf(Vector3(AX + 41.6 - (i % 3)*0.07, 1.15, 2.2 + i*0.06), Vector3(0.1, 0, 0.18)))
	# Pongal pots on three-stone hearths under a thatched shelter
	var pot := Build.flat("pot", Color(0.61, 0.29, 0.16), 0.75)
	for p in [Vector2(-4, -0.8), Vector2(-2.6, 0.6), Vector2(-5.6, 1.2)]:
		mb.add(Build.sph(0.27, 14, 10), pot, Build.xf(Vector3(AX + p.x, 0.5, p.y), Vector3.ZERO, Vector3(1, 0.9, 1)))
		mb.add(Build.cyl(0.16, 0.18, 0.1, 12), pot, Build.xf(Vector3(AX + p.x, 0.76, p.y)))
		for k in 3: mb.add(Build.sph(0.13, 6, 4), Build.M("stoneBig"), Build.xf(Vector3(AX + p.x + cos(k*2.1)*0.24, 0.1, p.y + sin(k*2.1)*0.24)))
		for k in 5: mb.add(Build.box(0.08, 0.32, 0.01), leaf, Build.xf(Vector3(AX + p.x + cos(k)*0.17, 0.92, p.y + sin(k)*0.17), Vector3(0.3, k, 0.2)))
	mb.add(Build.box(4.4, 0.08, 2.6), Build.M("thatch"), Build.xf(Vector3(AX - 4.3, 2.4, -0.2), Vector3(-0.25, 0, 0)))
	for p in [Vector2(-6.3, -1.3), Vector2(-2.3, -1.3), Vector2(-6.3, 0.9), Vector2(-2.3, 0.9)]: mb.add(Build.cyl(0.05, 0.06, 2.6, 8), Build.M("wood"), Build.xf(Vector3(AX + p.x, 1.2, p.y)))
	# village houses and coconut palms behind
	var rng := RandomNumberGenerator.new(); rng.seed = 909
	for i in 22:
		var hx := AX - 12 + i*3.4 + rng.randf(); var hz := -11 - rng.randf()*6; var w := 3 + rng.randf()*1.5; var h := 2.4 + rng.randf()*0.8
		mb.add(Build.box(w, h, 3), Build.flat("mud", Color(0.55, 0.3, 0.2), 0.95), Build.xf(Vector3(hx, h/2, hz)))
		mb.add(Build.cyl(0.0, 1.0, 1.2, 4), Build.M("thatch"), Build.xf(Vector3(hx, h + 0.55, hz), Vector3(0, PI/4, 0), Vector3(w*0.8, 1, 2.4)))
	var trunk := Build.flat("trunk", Color(0.43, 0.35, 0.27), 0.95)
	var frond := Build.flat("frond", Color(0.3, 0.42, 0.18), 0.8)
	for i in 14:
		var px := AX - 14 + i*5 + rng.randf()*2; var pz := -14 - rng.randf()*12; var s := 0.8 + rng.randf()*0.4
		mb.add(Build.cyl(0.16*s, 0.22*s, 10*s, 6), trunk, Build.xf(Vector3(px, 5*s, pz), Vector3(0, 0, 0.07)))
		for k in 9:
			var a := k/9.0*TAU
			mb.add(Build.box(0.5*s, 0.06, 3.0*s), frond, Build.xf(Vector3(px + 0.35*s + cos(a)*1.3*s, 9.7*s, pz + sin(a)*1.3*s), Vector3(0.5, -a + PI/2, 0)))
	mb.commit(self)
	_crowd()
	_people()
	for d in BULLS:
		var b := Build.bull(d.coat, d.horn)
		add_child(b.root); b.root.visible = false; bulls.append(b)
	young = Build.rig({"skin": Build.M("skin"), "cloth": Build.M("cotton"), "hair": Build.M("hair")})
	add_child(young.root)
	(young.root as Node3D).scale = Vector3.ONE*0.95

func _crowd() -> void:
	var dyes := [Color(0.95, 0.91, 0.84), Color(0.95, 0.91, 0.84), Color(0.64, 0.13, 0.11), Color(0.17, 0.25, 0.48), Color(0.85, 0.63, 0.11), Color(0.18, 0.42, 0.23), Color(0.48, 0.16, 0.32)]
	var poses := ["cheer", "idle", "namaskaram", "cheer"]
	var spots := []
	var rng := RandomNumberGenerator.new(); rng.seed = 404
	var x := 1.0
	while x < 46:
		for zy in [Vector2(-3.6, 0.5), Vector2(-4.5, 0.5), Vector2(-5.5, 1.1), Vector2(-6.3, 1.1)]:
			if not (zy.x < -5 and x > 16.5 and x < 23.5): spots.append(Vector3(x + rng.randf()*0.3, zy.y, zy.x + rng.randf()*0.2))
		x += 0.85
	for vi in poses.size():
		var skin := StandardMaterial3D.new(); skin.albedo_color = Color.WHITE; skin.vertex_color_use_as_albedo = true; skin.roughness = 0.55
		var cloth := StandardMaterial3D.new(); cloth.albedo_color = Color.WHITE; cloth.vertex_color_use_as_albedo = true; cloth.roughness = 0.9
		var r := Build.rig({"skin": skin, "cloth": cloth, "hair": skin})
		Build.pose(r, poses[vi])
		var mb := Build.MB.new(); Build.bake(r.root, mb); (r.root as Node3D).free()
		var ms := mb.meshes()
		var mine := []
		for i in spots.size():
			if i % poses.size() == vi: mine.append(spots[i])
		var grp := Node3D.new(); add_child(grp)
		for mat in ms:
			var mm := MultiMesh.new(); mm.transform_format = MultiMesh.TRANSFORM_3D; mm.use_colors = true; mm.mesh = ms[mat]; mm.instance_count = mine.size()
			for j in mine.size():
				var k := 0.9 + rng.randf()*0.15
				mm.set_instance_transform(j, Transform3D(Basis(Vector3.UP, (rng.randf() - 0.5)*0.8).scaled(Vector3.ONE*k), AX*Vector3.RIGHT + mine[j]))
				mm.set_instance_color(j, dyes[rng.randi() % dyes.size()] if mat == cloth else Color(0.54, 0.33, 0.21)*(0.8 + rng.randf()*0.4))
			var mmi := MultiMeshInstance3D.new(); mmi.multimesh = mm; mmi.material_override = mat; grp.add_child(mmi)
		crowd.append({"grp": grp, "ph": vi*1.3, "jump": 0.0})

func _people() -> void:
	var person := func(cloth: Material, pos: Vector3, yaw: float, pose_name: String, sash: bool) -> Dictionary:
		var r := Build.rig({"skin": Build.M("skin"), "cloth": cloth, "hair": Build.M("hair")}, {"sash": sash})
		add_child(r.root); (r.root as Node3D).position = pos; (r.root as Node3D).rotation.y = yaw; Build.pose(r, pose_name)
		return r
	people.veeran = person.call(Build.M("cotton"), Vector3(AX + 22.8, 0, -2.0), 0.5, "idle", true)
	people.headman = person.call(Build.M("cotton"), Vector3(AX + 40.6, 0, -2.0), -0.6, "cheer", false)
	people.aditya = person.call(Build.M("silk"), Vector3(AX + 20, 2.0, -5.6), 0.0, "idle", false)
	people.drum = [person.call(Build.M("indigo"), Vector3(AX + 30, 0.5, -4.2), 0.0, "drum", false), person.call(Build.M("indigo"), Vector3(AX + 30.95, 0.5, -4.2), 0.0, "drum", false)]
	for d in people.drum: Build.node(d.root, Build.cyl(0.24, 0.24, 0.08, 18), Build.M("wood"), Vector3(0, 1.15, 0.28), Vector3(PI/2, 0, 0))

# ------------------------------------------------------------ the ride
func win() -> float: return BULLS[jk.i].win*(1.0 + 0.3*minf(2, jk.attempts - 1))

func start_bull(i: int) -> void:
	var keep = jk if (jk != null and jk.i == i) else null
	jk = {"i": i, "phase": "wait", "t": 0.0, "wait": (2.2 if i == 2 else 1.4) + randf()*1.2, "bx": AX + 45.5, "b": 0.0, "dist": 0.0, "buck_t": 0.0, "per": BULLS[i].period,
		"dir": 1.0, "beat_n": -1, "hit": {}, "checked": -1, "since": 9.0, "tta": 9.0, "paused": 0.0, "firm": 0, "hearts": 3, "combo": 0, "best_combo": 0, "lock": 0.0,
		"grab_q": "", "attempts": (keep.attempts + 1) if keep else 1, "best": keep.best if keep else 0, "ix": ILAN_X, "iy": 0.0, "ivx": 0.0, "ivy": 0.0, "iz": 0.0, "ivz": 0.0,
		"cloth": false, "dip": 0.0, "snatch_try": false, "in_win": false, "landed": false, "dip_at": 0.9, "success": false, "msg": ""}
	for k in bulls.size():
		bulls[k].root.visible = k == i; bulls[k].cloth.visible = true
	game.ui.jk_box.visible = true
	game.ui.jk_name.text = "%s · %s" % [BULLS[i].name, BULLS[i].house]
	_hearts()
	if i == 0 or jk.attempts > 1: game.ui.show_obj("TAP", "Here he comes. Tap when the gold ring closes on his hump.")
	if jk.attempts == 2: game.ui.say("VEERAN", "Watch his front hooves, not his horns.")
	if jk.attempts == 3: game.ui.say("VEERAN", "Breathe. Feel the rhythm. Now.")

func _hearts() -> void:
	var s := ""
	for i in 3: s += ("◆ " if i < jk.hearts else "◇ ")
	game.ui.jk_hearts.text = s.strip_edges()

func throw(msg: String) -> void:
	jk.phase = "thrown"; jk.t = 0.0; jk.msg = msg
	jk.ix = jk.bx - 0.15; jk.iy = 0.85; jk.iz = 0.0; jk.ivx = -1.5; jk.ivy = 5.0; jk.ivz = 3.4
	game.audio.play("death"); game.shake = 0.3; game.ui.hide_obj()

func finish(success: bool) -> void:
	var B: Dictionary = BULLS[jk.i]
	var pts: int = roundi(minf(jk.dist, B.dist)*20) + jk.firm*50 + jk.best_combo*40
	if success:
		pts += 500 if jk.grab_q == "Perfect" else 250
		if jk.cloth: pts += 600
		if jk.hearts == 3: pts += 300
	jk.best = maxi(jk.best, pts)
	var ui = game.ui
	if success:
		ui.jk_res_h.text = "%s held!" % B.name
		ui.jk_res_p.text = "%s grab · best streak ×%d%s%s" % [jk.grab_q, jk.best_combo, " · coin cloth taken" if jk.cloth else "", " · never slipped" if jk.hearts == 3 else ""]
		ui.jk_res_s.text = "%d points" % pts
	else:
		ui.jk_res_h.text = jk.msg if jk.msg != "" else "Thrown!"
		ui.jk_res_p.text = "Held %.1f of %d m." % [jk.dist, B.dist]
		ui.jk_res_s.text = "The memory moves on. You held him, in the end." if jk.attempts >= 3 else "Veeran hauls you back over the barricade. Again, and the timing gets easier."
	ui.jk_res.visible = true
	jk.phase = "result"; jk.t = 0.0; jk.success = success or jk.attempts >= 3
	if jk.success:
		score += jk.best
		for c in crowd: c.jump = 1.0
		game.audio.play("collect" if success else "chime")
	ui.hide_obj()

func update(dt: float, tap: bool) -> void:
	if jk == null: return
	var B: Dictionary = BULLS[jk.i]
	var R: Dictionary = bulls[jk.i]
	var ui = game.ui
	jk.lock = maxf(0, jk.lock - dt)
	if jk.phase == "charge" and jk.tta < 0.7 and jk.tta > -0.4: dt *= 0.45   # slow motion as he reaches you
	jk.t += dt
	match jk.phase:
		"wait":
			if jk.t > jk.wait:
				jk.phase = "charge"; jk.t = 0.0; game.audio.play("roar"); game.shake = 0.25
				for c in crowd: c.jump = 0.6
		"charge", "miss":
			if B.pause and jk.phase == "charge" and jk.paused == 0.0 and jk.bx < AX + 36: jk.paused = 0.6 + randf()*0.6; game.audio.play("hoof")
			if jk.paused > 0:
				jk.paused -= dt
				if jk.paused <= 0: jk.paused = -1.0
			else:
				jk.bx -= B.speed*dt; R.ph += dt*B.speed*1.9
			jk.tta = 9.0 if jk.paused > 0 else (jk.bx - 0.42 - ILAN_X)/B.speed
			var W := win()*1.6
			if jk.phase == "charge":
				if tap and jk.lock <= 0:
					if jk.tta > W: ui.flash("Wait for it…", false); jk.lock = 0.25
					elif jk.tta >= -W:
						jk.grab_q = "Perfect" if absf(jk.tta) < W*0.4 else "Good"; ui.flash(jk.grab_q + " grab!", true)
						jk.phase = "ride"; jk.t = 0.0; jk.buck_t = 0.0; jk.per = B.period; jk.beat_n = -1
						game.audio.play("step"); game.hit_stop = 0.08
						for c in crowd: c.jump = 1.0
						if jk.i == 0 or jk.attempts > 1: ui.show_obj("TAP", "Hold on! Tap each time the ring closes, as his hooves hit the ground.")
				if jk.tta < -W - 0.05: jk.phase = "miss"; jk.t = 0.0; ui.flash("Too late. He's past you.", false)
			elif jk.t > 1.4:
				jk.msg = "Missed him at the gate."; finish(false)
		"ride":
			jk.bx -= B.ride_v*dt; jk.dist += B.ride_v*dt; R.ph += dt*5
			jk.buck_t += dt; jk.since += dt
			if jk.buck_t >= jk.per:
				jk.buck_t -= jk.per; jk.beat_n += 1; jk.since = 0.0; jk.per = B.period*(0.9 + randf()*0.2); jk.dir = -1.0 if randf() < 0.5 else 1.0
				game.audio.play("hoof"); game.shake = maxf(game.shake, 0.06)
			var to_next: float = jk.per - jk.buck_t
			var W2 := win()
			var w: int = jk.beat_n + 1 if to_next < W2 else (jk.beat_n if (jk.since < W2 and jk.beat_n >= 0) else -1)
			jk.in_win = w >= 0
			if tap and jk.lock <= 0:
				if w >= 0 and not jk.hit.has(w):
					var off: float = jk.since if w == jk.beat_n else to_next
					jk.hit[w] = true; jk.firm += 1; jk.combo += 1; jk.best_combo = maxi(jk.best_combo, jk.combo)
					ui.flash(("Perfect! ×%d" if off < W2*0.4 else "Firm! ×%d") % jk.combo, true); game.audio.play("firm")
					if jk.combo % 5 == 0:
						for c in crowd: c.jump = 1.0
						if jk.hearts < 3: jk.hearts += 1; _hearts(); ui.say("HINT", "Grip restored!")
				else:
					jk.lock = 0.2   # a tap between beats does nothing, and spamming can't win
			if jk.beat_n >= 0 and jk.since >= W2 and jk.checked != jk.beat_n:
				jk.checked = jk.beat_n
				if not jk.hit.has(jk.beat_n):
					jk.hearts -= 1; jk.combo = 0; _hearts(); ui.flash("Slipping!", false); game.shake = 0.15
			jk.b = jk.dir*sin(minf(1.0, (jk.buck_t/jk.per)/0.6)*PI)*0.35*(1.6 if jk.hearts < 2 else 1.0)
			if jk.hearts <= 0: throw("Thrown! He bucked you off.")
			elif jk.dist >= B.dist:
				jk.phase = "snatch"; jk.t = 0.0; ui.show_obj("TAP", "He drops his head. Tap now to take the coin cloth!")
		"snatch":
			jk.bx -= B.ride_v*0.4*dt; R.ph += dt*2
			jk.dip = exp(-pow((jk.t - jk.dip_at)/0.45, 2))
			if tap and not jk.snatch_try and jk.t > 0.25:
				jk.snatch_try = true
				if absf(jk.t - jk.dip_at) < 0.55:
					jk.cloth = true; R.cloth.visible = false; ui.flash("Coin cloth taken!", true); game.audio.play("collect"); game.hit_stop = 0.08
				else: ui.flash("Missed the cloth", false)
			if jk.t > jk.dip_at + 0.9: finish(true)
		"thrown":
			jk.ivy -= 26.0*dt; jk.ix += jk.ivx*dt; jk.iy += jk.ivy*dt; jk.iz += jk.ivz*dt; jk.bx -= B.ride_v*dt; R.ph += dt*5
			if jk.iy <= 0:
				if not jk.landed: jk.landed = true; game.audio.play("land")
				jk.iy = 0.0; jk.ivx *= 0.8; jk.ivz *= 0.8; jk.ivy = 0.0
			if jk.t > 1.5: finish(false)
		"result":
			if jk.t > 3.0:
				ui.jk_res.visible = false
				if not jk.success: start_bull(jk.i); return
				bulls[jk.i].root.visible = false; ui.jk_box.visible = false
				if jk.i < 2: next_bull = jk.i + 1; game.start_cut(game.JK_BETWEEN[jk.i], "jk")
				else: game.start_cut(game.JK_OUTRO, "credits")

func visuals(dt: float, t: float) -> float:
	for i in crowd.size():
		var c: Dictionary = crowd[i]
		c.jump = maxf(0, c.jump - dt*1.2)
		c.grp.position.y = absf(sin(t*(6 + c.jump*6) + c.ph))*(0.03 + c.jump*0.18)
	for d in people.drum:
		d.sh[1].rotation.x = -1.6 + sin(t*31)*0.5; d.sh[0].rotation.x = -0.9 + cos(t*31)*0.4
	var focus := AX + 24.0
	var ui = game.ui
	ui.ring_state.show = false
	if jk == null or game.state != "jk":
		young.root.position = Vector3(ILAN_X, 0, 0); young.root.rotation.y = PI/2; Build.pose(young, "idle", 0, t)
		return focus
	var R: Dictionary = bulls[jk.i]
	var by := 0.0; var pitch := 0.0; var roll := 0.0; var buck := 0.0
	if jk.phase in ["ride", "snatch"]:
		var u: float = jk.buck_t/jk.per
		by = sin(u*PI)*0.32*(1.0 if jk.phase == "ride" else 0.3); pitch = sin(u*TAU)*0.22; roll = jk.dir*sin(minf(1.0, u/0.6)*PI)*0.18; buck = sin(u*PI)
		Build.animate_bull(R, 0.3, buck)
	else:
		Build.animate_bull(R, 0.0 if (jk.phase == "wait" or jk.paused > 0) else 1.0, 0.0)
	R.root.position = Vector3(jk.bx + (sin(t*7)*0.05 if jk.phase == "wait" else 0.0), by, 0)
	R.body.rotation = Vector3(roll, 0, pitch)
	R.head.rotation.z = -jk.dip*0.7 + (sin(t*3)*0.1 if jk.phase == "wait" else 0.0)
	var yr: Node3D = young.root
	yr.rotation_order = EULER_ORDER_XYZ
	if jk.phase in ["ride", "snatch"]:
		yr.position = Vector3(jk.bx - 0.1, by + 1.0, 0.2); yr.rotation = Vector3(0, -PI/2, 0); Build.pose(young, "ride")
		young.tilt.rotation.z = jk.b*0.5 + roll
		focus = jk.bx - 1.2
		if jk.phase == "ride":
			ui.ring_state = {"show": true, "pos": Vector2(get_viewport().get_visible_rect().size.x*0.8, get_viewport().get_visible_rect().size.y*0.46), "scale": 1.0 + (jk.per - jk.buck_t)/jk.per*1.7, "now": jk.in_win, "label": "TAP"}
	elif jk.phase == "thrown" or (jk.phase == "result" and not jk.success):
		yr.position = Vector3(jk.ix, jk.iy, jk.iz); yr.rotation = Vector3(0, -PI/2, 0); Build.pose(young, "air")
		young.tilt.rotation = Vector3(jk.t*6 if jk.iy > 0 else PI/2*0.95, 0, 0); focus = jk.ix
	elif jk.phase == "result":
		yr.position = Vector3(jk.bx - 1.6, 0, 0.9); yr.rotation = Vector3(0, PI/2, 0); young.tilt.rotation = Vector3.ZERO; Build.pose(young, "cheer"); focus = jk.bx
	else:
		yr.position = Vector3(ILAN_X, 0, 0); yr.rotation = Vector3(0, PI/2, 0); young.tilt.rotation = Vector3.ZERO; Build.pose(young, "ready", 0, t)
		focus = AX + 31.0 if jk.phase == "wait" else (jk.bx + ILAN_X)/2
		if jk.phase == "charge" and jk.tta < 1.3 and jk.tta > -0.3:
			var cam: Camera3D = game.camera
			var sp := cam.unproject_position(Vector3(jk.bx - 0.42, 2.0, 0))
			ui.ring_state = {"show": true, "pos": sp, "scale": 1.0 + maxf(0, jk.tta)*2.4, "now": absf(jk.tta) < win()*0.6, "label": ""}
	ui.jk_line.text = "%.1f / %d m      %d pts" % [minf(jk.dist, BULLS[jk.i].dist), BULLS[jk.i].dist, score]
	return focus
