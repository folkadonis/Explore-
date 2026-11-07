## Shadows of Kanchi — the game: story flow, tutorial, input, camera, and the Chapter 1 rules.
extends Node3D

const A := Arena.AX
var CHECKPOINTS := [Vector3(2, 0, -999), Vector3(34.5, 0, 33.5), Vector3(51.5, 0, 50.6), Vector3(67.2, 0, 66.8), Vector3(78.2, 0, 77.8), Vector3(89.2, 1, 88.8), Vector3(103.8, 0, 103.2), Vector3(120.3, 0, 119.7), Vector3(134.5, 0, 133.7), Vector3(171, 1.3, 170.2)]
var TRIGGERS := [
	{"x": 40.0, "lines": [["NIZHAL", "Too far to jump. Not too far for me."]]},
	{"x": 63.0, "lines": [["VO", "The temple elephants led the procession. Their bells stopped mid-swing."], ["NIZHAL", "Big animals. Big shade."]]},
	{"x": 85.0, "lines": [["NIZHAL", "Every shadow in Kanchi went somewhere. Mine just stayed."]]},
	{"x": 109.0, "lines": [["NIZHAL", "No shade out there."], ["ILAN", "Then I'll make some."]]},
	{"x": 135.0, "lines": [["VO", "The feast was still laid out. Steam hung over the rice like glass."]]},
	{"x": 146.0, "lines": [["NIZHAL", "Ilan. The dark is moving."]], "spawn": true},
	{"x": 168.5, "lines": [["VO", "They followed me to the doorway. The light took them there."]]},
]
const DEATH_LINES := ["Wait. I'm telling it wrong.", "I'd never fall for that.", "Ask anyone. I didn't fall.", "Let me tell that part again."]
var INTRO := [
	{"sp": "VO", "t": "Most people remember Prince Aditya's coronation as an ordinary day.", "cam": Vector3(9, 1.2, 17), "look": Vector3(-4, 34, -26)},
	{"sp": "VO", "t": "I'm going to tell you what really happened.", "cam": Vector3(6, 1.6, 12), "look": Vector3(-4, 30, -26)},
	{"sp": "VO", "t": "I opened Mayan's door. I lifted the Mirror. Then the minister struck it.", "cam": Vector3(44, 24, 32), "look": Vector3(30, -6, -18)},
	{"sp": "VO", "t": "Every shadow in Kanchi tore loose. The people turned to stone. The sun stopped at noon.", "cam": Vector3(60, 6, 14), "look": Vector3(70, 1, -2)},
	{"sp": "VO", "t": "I woke on the temple steps with a shard in my armband.", "cam": Vector3(6.2, 1.6, 6.0), "look": Vector3(2, 0.4, 0), "wake": 0},
	{"sp": "NIZHAL", "t": "Well. You've really done it this time.", "cam": Vector3(5.6, 1.6, 5.4), "look": Vector3(1.2, 0.8, -0.4), "wake": 1},
	{"sp": "ILAN", "t": "...Who said that?", "cam": Vector3(5.4, 2.0, 5.2), "look": Vector3(1.8, 1.4, 0), "wake": 2},
	{"sp": "NIZHAL", "t": "Your shadow. Keep up. The palace is coming down.", "cam": Vector3(6.0, 2.1, 6.2), "look": Vector3(1.4, 1.3, -0.3), "wake": 2},
]
var ENDING := [
	{"sp": "VO", "t": "Aditya stood where the priests had left him, the crown half-raised.", "cam": Vector3(172.4, 3.8, 7.0), "look": Vector3(178.0, 2.8, -1.2)},
	{"sp": "VO", "t": "We climbed the same walls as boys. He never once looked down on me.", "cam": Vector3(175.2, 3.4, 5.2), "look": Vector3(178.4, 3.1, -1.2)},
	{"sp": "NIZHAL", "t": "Nobody saw it was you. You could just walk away.", "cam": Vector3(175.6, 2.9, 5.6), "look": Vector3(175.4, 2.3, -0.4)},
	{"sp": "ILAN", "t": "I could have.", "cam": Vector3(178.6, 3.0, 5.4), "look": Vector3(176.4, 2.7, 0)},
	{"sp": "VO", "t": "I didn't.", "cam": Vector3(171, 8, 15), "look": Vector3(178, 2, -2)},
	{"sp": "NIZHAL", "t": "You said he never looked down on you. Prove it.", "cam": Vector3(175.6, 2.9, 5.6), "look": Vector3(175.4, 2.3, -0.4)},
	{"sp": "VO", "t": "Before I tell you about the stepwell, you should know who I was.", "cam": Vector3(173.5, 3.2, 6.5), "look": Vector3(178.4, 3.0, -1.2)},
	{"sp": "VO", "t": "Four Pongals before the coronation. Mattu Pongal. I was sixteen.", "cam": Vector3(171, 8, 15), "look": Vector3(178, 4, -2)},
]
static func AV(x: float, y: float, z: float) -> Vector3: return Vector3(A + x, y, z)
var JK_INTRO := [
	{"sp": "VO", "t": "Sevvappur village. Every house had boiled its Pongal at sunrise.", "cam": AV(-9, 3.2, 9), "look": AV(-2, 1.2, -1)},
	{"sp": "VO", "t": "Kolams at every door. Sugarcane at every gate. The parai never stopped.", "cam": AV(6, 5, 16), "look": AV(20, 1.5, -4)},
	{"sp": "VEERAN", "t": "Your father know you're here?", "cam": AV(21.4, 1.8, 4.2), "look": AV(23.2, 1.5, -1)},
	{"sp": "ILAN", "t": "My father's carving a wall in Kanchi.", "cam": AV(25.6, 1.8, 3.6), "look": AV(24, 1.5, 0)},
	{"sp": "VEERAN", "t": "Then I'll be the one who carries you home.", "cam": AV(21.4, 1.8, 4.2), "look": AV(23.2, 1.5, -1)},
	{"sp": "HEADMAN", "t": "From the house of Muthan the potter: Vellaiyan!", "cam": AV(37, 2.4, 7.5), "look": AV(43, 1.6, 0)},
	{"sp": "VO", "t": "Hold the hump. Not the horns, not the tail. Fifteen strides, and the cloth on his horns is yours.", "cam": AV(30, 2.6, 9), "look": AV(36, 1.2, 0)},
]
var JK_BETWEEN := [[
	{"sp": "VO", "t": "Vellaiyan was a gentle bull. Every boy in the district had held him.", "cam": AV(14, 3, 9), "look": AV(20, 1.4, -2)},
	{"sp": "HEADMAN", "t": "From the house of the Pulikulam herders: Karuppan!", "cam": AV(37, 2.4, 7.5), "look": AV(43, 1.6, 0)},
	{"sp": "VEERAN", "t": "Not that one. Karuppan spins.", "cam": AV(21.4, 1.8, 4.2), "look": AV(23.2, 1.5, -1)},
	{"sp": "ILAN", "t": "Then I'll spin with him.", "cam": AV(25.6, 1.8, 3.6), "look": AV(24, 1.5, 0)},
], [
	{"sp": "HEADMAN", "t": "From the royal herd, the bull of the palace: Sivappan!", "cam": AV(37, 2.4, 7.5), "look": AV(43, 1.6, 0)},
	{"sp": "VO", "t": "Nobody had held Sivappan in three Pongals.", "cam": AV(34, 1.4, 6), "look": AV(43, 1.9, 0)},
	{"sp": "VO", "t": "On the elders' platform, the prince had stopped leaning over the rail. He was gripping it.", "cam": AV(17, 3.4, 1.5), "look": AV(20, 3.0, -6.3)},
]]
var JK_OUTRO := [
	{"sp": "HEADMAN", "t": "Sivappan of the palace herd has been held! Honour to the royal house!", "cam": AV(8, 3, 10), "look": AV(14, 1.5, -3)},
	{"sp": "VO", "t": "That was the rule. The honour goes to the house that raised the bull.", "cam": AV(1, 1.8, 5), "look": AV(3, 1.3, 0)},
	{"sp": "VO", "t": "Nobody asked my name. I told myself I didn't mind.", "cam": AV(-0.6, 1.6, 4.2), "look": AV(2.6, 1.3, 0)},
	{"sp": "ADITYA", "t": "You held him.", "cam": AV(5.6, 1.6, 3.6), "look": AV(3.6, 1.4, 0)},
	{"sp": "ILAN", "t": "Your house held him. The headman said so.", "cam": AV(1.2, 1.6, 3.6), "look": AV(3.2, 1.4, 0)},
	{"sp": "ADITYA", "t": "I was watching. You held him.", "cam": AV(5.6, 1.6, 3.6), "look": AV(3.6, 1.4, 0)},
	{"sp": "VO", "t": "He was the only one who said my name that day. You forget the wrong things.", "cam": AV(-4, 4, 12), "look": AV(4, 1.2, -2)},
]

var level: Level
var player: Player
var nizhal: Dictionary
var ghost: Dictionary
var camera: Camera3D
var ui: UI
var audio: Audio
var arena: Arena
var lane_glows: Array = []
var walker_rigs: Array = []
var walkers: Array = []
var OBJ: Array = []

var state := "loading"
var cut_lines: Array = []
var cut_i := 0
var cut_t := 0.0
var cut_then := ""
var in_arena := false
var cp_idx := 0
var deaths := 0
var mem_count := 0
var play_time := 0.0
var hall_spawned := false
var death_t := -1.0
var obj_i := 0
var obj_on := false
var obj_t := 0.0
var obj_cool := 0.0
var shake := 0.0
var hit_stop := 0.0
var t := 0.0
var cam_pos := Vector3(9, 1.2, 17)
var cam_look := Vector3(-4, 34, -26)
var cam_pos_t := cam_pos
var cam_look_t := cam_look
var cam_y := 0.0
var cam_ahead := 1.7
var nz_up := 0.0
var lie := 1.0
var last_no_shade := -99.0
var debris: Array = []
var debris_t := 0.0
var autotest := false
var bot := {}

# ------------------------------------------------------------ setup
func _ready() -> void:
	autotest = "--autotest" in OS.get_cmdline_user_args()
	_inputs()
	level = Level.new(); add_child(level)
	player = Player.new(); add_child(player); player.setup(level)
	player.stepped.connect(_on_stepped)
	player.cut_swung.connect(_on_cut)
	player.jumped.connect(func(): audio.play("jump", -6))
	player.landed.connect(func(): audio.play("land", -4))
	var shadow_mat := _shadow_mat(Color(0.55, 0.3, 1.4))
	nizhal = Build.rig({"skin": shadow_mat, "cloth": shadow_mat, "hair": shadow_mat, "eye": Build.glow("eyeV", Color(0.7, 0.45, 1.6), 3.0)})
	_no_shadows(nizhal.root); add_child(nizhal.root)
	var gm := StandardMaterial3D.new(); gm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED; gm.albedo_color = Color(0.6, 0.45, 1.0, 0.3); gm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ghost = Build.rig({"skin": gm, "cloth": gm, "hair": gm}); _no_shadows(ghost.root); add_child(ghost.root); Build.pose(ghost, "idle")
	var wm := _shadow_mat(Color(0.9, 0.18, 0.55))
	for i in 7:
		var r := Build.rig({"skin": wm, "cloth": wm, "hair": wm, "eye": Build.glow("eyeR", Color(1.0, 0.2, 0.4), 3.0)})
		_no_shadows(r.root); (r.root as Node3D).scale = Vector3.ONE*1.12; r.root.visible = false; add_child(r.root); walker_rigs.append(r)
	var lg := StandardMaterial3D.new(); lg.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED; lg.albedo_color = Color(0.5, 0.3, 1.0, 0.28); lg.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA; lg.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	for i in 24:
		var q := Build.node(self, Build.box(1, 0.01, 0.9), lg, Vector3.ZERO, Vector3.ZERO, Vector3.ONE, false); q.visible = false; lane_glows.append(q)
	camera = Camera3D.new(); camera.fov = 38; camera.far = 1200; add_child(camera); camera.current = true
	ui = UI.new(); add_child(ui)
	audio = Audio.new(); add_child(audio)
	_objectives()
	new_game()
	state = "title"
	ui.hud.visible = false
	if autotest: _bot_start()

func _shadow_mat(rim: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.02, 0.012, 0.03, 0.92); m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA; m.roughness = 1.0
	m.rim_enabled = true; m.rim = 1.0; m.rim_tint = 0.0
	m.emission_enabled = true; m.emission = rim*0.12
	return m

func _no_shadows(n: Node) -> void:
	if n is GeometryInstance3D: (n as GeometryInstance3D).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for c in n.get_children(): _no_shadows(c)

func _inputs() -> void:
	var keys := {"left": [KEY_A, KEY_LEFT], "right": [KEY_D, KEY_RIGHT], "jump": [KEY_SPACE, KEY_W, KEY_UP], "step": [KEY_K, KEY_SHIFT, KEY_E, KEY_L], "cut": [KEY_J, KEY_X, KEY_F], "advance": [KEY_ENTER, KEY_SPACE]}
	var pads := {"jump": [JOY_BUTTON_A], "step": [JOY_BUTTON_X, JOY_BUTTON_RIGHT_SHOULDER], "cut": [JOY_BUTTON_B, JOY_BUTTON_Y], "advance": [JOY_BUTTON_START, JOY_BUTTON_A], "left": [JOY_BUTTON_DPAD_LEFT], "right": [JOY_BUTTON_DPAD_RIGHT]}
	for a in keys:
		if not InputMap.has_action(a): InputMap.add_action(a, 0.2)
		for k in keys[a]:
			var e := InputEventKey.new(); e.physical_keycode = k; InputMap.action_add_event(a, e)
		for b in pads.get(a, []):
			var j := InputEventJoypadButton.new(); j.button_index = b; InputMap.action_add_event(a, j)
	for a in [["left", -1.0], ["right", 1.0]]:
		var m := InputEventJoypadMotion.new(); m.axis = JOY_AXIS_LEFT_X; m.axis_value = a[1]; InputMap.action_add_event(a[0], m)

func _objectives() -> void:
	OBJ = [
		{"at": -99.0, "icon": "◀ ▶", "text": "Drag anywhere on the left side of the screen to run. On a keyboard, hold D.", "done": func(): return player.position.x > 6},
		{"at": 7.0, "icon": "JUMP", "btn": "jump", "text": "Jump onto the stone step.", "done": func(): return player.is_on_floor() and player.position.y > 1.1},
		{"icon": "HOLD", "btn": "jump", "text": "Hold Jump to jump higher, onto the next step.", "done": func(): return player.is_on_floor() and player.position.y > 2.3},
		{"at": 22.0, "icon": "JUMP", "btn": "jump", "text": "Run and jump across the gap.", "done": func(): return player.position.x > 33.4 and player.is_on_floor()},
		{"at": 39.0, "icon": "STEP", "btn": "step", "text": "Too far to jump. Tap Step to teleport into the shade where the violet ghost stands.", "done": func(): return player.position.x > 50.5 and player.is_on_floor()},
		{"icon": "i", "text": "You can only Step into shade. A violet glow on the ground marks shade in reach.", "info": 5.0},
		{"at": 62.0, "icon": "STEP", "btn": "step", "text": "Step from shade to shade under the elephants.", "done": func(): return player.position.x > 77.6 and player.is_on_floor()},
		{"at": 84.0, "icon": "▲ ◆", "btn": "step", "text": "You can Step in mid-air. Jump first, then Step, to save a fall.", "done": func(): return player.position.x > 88.6 and player.is_on_floor()},
		{"at": 95.5, "icon": "STEP", "btn": "step", "text": "The banner's shadow swings. Wait for the ghost, then Step.", "done": func(): return player.position.x > 103 and player.is_on_floor()},
		{"at": 108.5, "icon": "CUT", "btn": "cut", "text": "No shade ahead. Stand by the rope post and tap Cut.", "done": func(): return level.CANOPIES[0].cut},
		{"icon": "STEP", "btn": "step", "text": "The canopy made shade. Step into it.", "done": func(): return player.position.x > 119.5 and player.is_on_floor()},
		{"icon": "CUT", "btn": "cut", "text": "Cut the next rope, then Step across.", "done": func(): return player.position.x > 133.5 and player.is_on_floor()},
		{"at": 146.0, "icon": "CUT", "btn": "cut", "text": "Run! Cut knocks shadows back. Knock one into sunlight and it burns.", "done": func(): return player.position.x > 167.3},
		{"at": 169.0, "icon": "▶", "text": "Go to the prince.", "done": func(): return false},
	]

func new_game() -> void:
	for tr in TRIGGERS: tr.done = false
	level.reset()
	cp_idx = 0; deaths = 0; play_time = 0.0; hall_spawned = false; mem_count = 0; obj_i = 0; obj_on = false; obj_cool = 0.0
	walkers = _make_walkers()
	for o in OBJ: o.erase("nudged")
	player.spawn(Vector3(2, 0, 0))
	ui.hide_obj()

func _make_walkers() -> Array:
	var out := []
	for x in [150.0, 156.0, 161.0]: out.append({"x": x, "y": 0.0, "hp": 1, "alive": true, "active": false, "wake": 9.0, "spd": 2.0, "kv": 0.0, "burn": 0.0, "ph": randf()*6})
	return out

# ------------------------------------------------------------ story flow
func start_cut(lines: Array, then: String) -> void:
	ui.clear_toasts(); ui.hide_obj(); ui.touch.hint = ""
	state = "cut"; cut_lines = lines; cut_i = 0; cut_t = 0.0; cut_then = then
	ui.cine(true); ui.touch.mode = "hidden"; ui.touch.release_all()
	_show_line()

func _show_line() -> void:
	var L: Dictionary = cut_lines[cut_i]
	ui.subtitle(L.sp, L.t, in_arena or cut_lines == JK_OUTRO)
	cam_look_t = L.look; cam_pos_t = L.cam

func advance() -> void:
	match state:
		"title":
			ui.title_box.visible = false; start_cut(INTRO, "play")
		"cut":
			if cut_t < 0.35: return
			cut_i += 1; cut_t = 0.0
			if cut_i < cut_lines.size(): _show_line(); return
			ui.hide_sub()
			if cut_then == "arena":
				enter_arena(); start_cut(JK_INTRO, "jk"); return
			ui.cine(false)
			if cut_then == "jk":
				state = "jk"; ui.touch.mode = "tap"; arena.start_bull(arena.next_bull); return
			if cut_then == "credits":
				state = "credits"; _credits(); return
			state = "play"; ui.touch.mode = "play"; ui.hud.visible = true
		"credits":
			ui.credits_box.visible = false; exit_arena(); new_game(); start_cut(INTRO.slice(5), "play")

func _credits() -> void:
	ui.touch.mode = "hidden"; ui.jk_box.visible = false; ui.hud.visible = false
	var m := int(play_time/60); var s := int(play_time) % 60
	ui.credits_stats.text = "Time %d:%02d · Shadow-memories %d/%d · Retold %d times · Jallikattu %d points" % [m, s, mem_count, Level.MEMS.size(), deaths, arena.score if arena else 0]
	ui.credits_rank.text = ("Every memory found. " if mem_count == Level.MEMS.size() else "%d shadow-memories are still out there. " % (Level.MEMS.size() - mem_count)) + "Play again to beat your time."
	ui.credits_box.visible = true

func enter_arena() -> void:
	if arena == null:
		arena = Arena.new(); add_child(arena); arena.build(self)
	in_arena = true; arena.next_bull = 0; arena.score = 0
	player.visible = false; nizhal.root.visible = false; ghost.root.visible = false
	var env: Environment = level.env
	var sm: ProceduralSkyMaterial = env.sky.sky_material
	sm.sky_top_color = Color(0.3, 0.47, 0.76); sm.sky_horizon_color = Color(1.0, 0.87, 0.68)
	env.fog_light_color = Color(0.85, 0.71, 0.56); env.fog_density = 0.0055
	level.sun.look_at_from_position(Vector3.ZERO, -Vector3(0.72, 0.5, 0.48), Vector3.UP); level.sun.light_color = Color(1.0, 0.82, 0.61)
	ui.hud.visible = false

func exit_arena() -> void:
	in_arena = false
	player.visible = true
	var env: Environment = level.env
	var sm: ProceduralSkyMaterial = env.sky.sky_material
	sm.sky_top_color = Color(0.25, 0.17, 0.38); sm.sky_horizon_color = Color(1.0, 0.72, 0.5)
	env.fog_light_color = Color(0.78, 0.56, 0.42); env.fog_density = 0.0075
	level.sun.look_at_from_position(Vector3.ZERO, Level.SUN_D, Vector3.FORWARD); level.sun.light_color = Color(1.0, 0.84, 0.65)

# ------------------------------------------------------------ the frame
func _physics_process(dt: float) -> void:
	if state == "loading": return
	if autotest: _bot_tick()
	var touch: TouchControls = ui.touch
	var adv := Input.is_action_just_pressed("advance") or touch.tap
	if hit_stop > 0: hit_stop -= dt; touch.consume(); return
	t += dt
	level.step(dt)
	match state:
		"title", "cut", "credits":
			cut_t += dt
			if state == "cut" and (cut_lines == ENDING): _walk_to_prince(dt)
			if adv: advance()
		"play":
			play_time += dt
			_play(dt, touch)
		"jk":
			arena.update(dt, adv or Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("cut") or Input.is_action_just_pressed("step") or touch.pressed.jump)
	touch.consume()

func _walk_to_prince(dt: float) -> void:
	if player.position.x < 176.2:
		player.position.x = minf(176.2, player.position.x + Player.RUN*0.35*dt); player.phase += dt*6
	player.face = 1

func _play(dt: float, touch: TouchControls) -> void:
	var ax := Input.get_axis("left", "right")
	if absf(touch.axis) > absf(ax): ax = touch.axis
	if player.alive:
		player.control(dt, ax, Input.is_action_just_pressed("jump") or touch.pressed.jump, Input.is_action_pressed("jump") or touch.held.jump,
			Input.is_action_just_pressed("step") or touch.pressed.step, Input.is_action_just_pressed("cut") or touch.pressed.cut)
		if (Input.is_action_just_pressed("step") or touch.pressed.step) and player.target == null and player.step_cd <= 0 and t - last_no_shade > 6:
			last_no_shade = t; audio.play("fizzle"); ui.say("NIZHAL", "No shade in reach. In full sun, you're just a man.")
		if not player.alive: _die(true)
	else:
		death_t += dt
		if death_t > (0.85 if player.fell else 1.3): _respawn()
	_walkers(dt)
	_objectives_step(dt)
	for tr in TRIGGERS:
		if not tr.done and player.position.x >= tr.x and player.alive:
			tr.done = true
			for l in tr.lines: ui.say(l[0], l[1])
			if tr.get("spawn", false) and not hall_spawned:
				hall_spawned = true; shake = 0.6; audio.play("rumble")
				for x in [141.6, 142.3, 143.0]: walkers.append({"x": x, "y": 0.0, "hp": 1, "alive": true, "active": true, "wake": 999.0, "spd": 3.0, "kv": 0.0, "burn": 0.0, "ph": randf()*6})
	if player.is_on_floor() and player.alive:
		for i in range(CHECKPOINTS.size() - 1, cp_idx, -1):
			if player.position.x >= CHECKPOINTS[i].z: cp_idx = i; break
	if player.alive:
		for m in level.memory_nodes:
			if m.got: continue
			if Vector2(player.position.x - m.x, player.position.y + 0.9 - m.y).length() < 0.85:
				m.got = true; m.node.visible = false; mem_count += 1; audio.play("collect"); hit_stop = 0.05
				if mem_count == 1: ui.say("HINT", "Shadow-memories: %d are hidden along the way. Some hang over gaps; grab them in a jump, then Step to safety." % Level.MEMS.size())
				ui.say("MEM", "%s. %s" % [m.name, m.line])
	if hall_spawned and player.position.x > Level.HALL.x0 and player.position.x < Level.HALL.x1 - 2:
		debris_t -= dt
		if debris_t <= 0:
			debris_t = 0.35 + randf()*0.4
			var d := Build.node(self, Build.sph(0.2 + randf()*0.25, 6, 4), Build.M("mason"), Vector3(player.position.x + 2 + randf()*7, Level.HALL.y0 - 0.3, -0.5 - randf()*2.5))
			debris.append({"n": d, "vy": 0.0})
	for d in debris:
		d.vy -= 18.0*dt; d.n.position.y += d.vy*dt; d.n.rotation.x += dt*4
		if d.n.position.y < 0.15: d.n.queue_free(); d.dead = true; shake = maxf(shake, 0.12)
	debris = debris.filter(func(d): return not d.get("dead", false))
	if player.alive and player.position.x > 175.5:
		player.velocity = Vector3.ZERO; ui.hud.visible = false; start_cut(ENDING, "arena")

func _on_stepped(_from, _to) -> void:
	audio.play("step"); hit_stop = 0.06; Input.vibrate_handheld(12)

func _on_cut() -> void:
	audio.play("cut", -4)
	for i in level.CANOPIES.size():
		var c: Dictionary = level.CANOPIES[i]
		if not c.cut and absf(player.position.x - c.post) < 2.2:
			level.cut_canopy(i); audio.play("cloth")
			ui.say("VO", "That silk was meant to shade the prince." if i == 0 else "He wouldn't miss it.")
	var near = null
	for w in walkers:
		if w.alive and w.burn == 0.0 and absf(w.x - player.position.x) < 2.6 and (near == null or absf(w.x - player.position.x) < absf(near.x - player.position.x)): near = w
	if near != null: player.face = int(signf(near.x - player.position.x))
	for w in walkers:
		if not w.alive or w.burn > 0: continue
		var d: float = (w.x - player.position.x)*player.face
		if d > -0.4 and d < 2.5 and absf(player.position.y - w.y) < 1.6:
			w.hp -= 1; w.kv = player.face*12.0; w.active = true; hit_stop = 0.05
			if w.hp <= 0: w.burn = 0.35

func _walkers(dt: float) -> void:
	for w in walkers:
		if not w.alive or absf(w.x - player.position.x) > 14: continue
		w.ph += dt*5
		if w.burn > 0:
			w.burn -= dt
			if w.burn <= 0: w.alive = false
			continue
		if w.kv != 0.0:
			w.x += w.kv*dt; w.kv *= pow(0.02, dt)
			if absf(w.kv) < 0.2: w.kv = 0.0
		if not level.shade_at(w.x, w.y): w.burn = 0.7; audio.play("burn"); continue
		var dx: float = player.position.x - w.x
		if not w.active and absf(dx) < w.wake: w.active = true
		if w.active and player.alive and absf(dx) > 0.1:
			var dir := signf(dx); var nx: float = w.x + dir*w.spd*dt
			if level.shade_at(nx + dir*0.3, w.y): w.x = nx
		if player.alive and absf(dx) < 0.4 and player.position.y < w.y + 1.6 and player.position.y + 1.75 > w.y: _die(false)

func _die(fell: bool) -> void:
	player.alive = false; player.fell = fell; deaths += 1; death_t = 0.0; audio.play("death"); Input.vibrate_handheld(40)
	ui.death_label.text = "“%s”" % DEATH_LINES[(deaths - 1) % DEATH_LINES.size()]

func _respawn() -> void:
	if player.fell: player.spawn(player.safe)
	else:
		player.spawn(Vector3(CHECKPOINTS[cp_idx].x, CHECKPOINTS[cp_idx].y, 0)); walkers = _make_walkers(); hall_spawned = false
		for tr in TRIGGERS:
			if tr.get("spawn", false): tr.done = false
	ui.death_label.text = ""; death_t = -1.0

func _objectives_step(dt: float) -> void:
	if obj_cool > 0:
		obj_cool -= dt
		if obj_cool <= 0 and not obj_on: ui.hide_obj()
		return
	if obj_i >= OBJ.size(): return
	var o: Dictionary = OBJ[obj_i]
	if not obj_on:
		if not o.has("at") or player.position.x >= o.at:
			obj_on = true; obj_t = 0.0; ui.show_obj(o.icon, o.text); ui.touch.hint = o.get("btn", "")
		else: return
	obj_t += dt
	if not o.has("info") and not o.has("nudged") and obj_t > 12:
		o.nudged = true
		var k: String = o.get("btn", "")
		ui.say("HINT", {"step": "Stuck? Walk to the edge, wait for the violet ghost to appear in the shade ahead, then tap Step.", "cut": "Stuck? Stand right beside the wooden post and tap Cut.", "jump": "Stuck? Run at the edge and tap Jump just before you reach it. Hold Jump to go higher."}.get(k, "Stuck? Keep moving right."))
	var nxt = null
	for j in range(obj_i + 1, OBJ.size()):
		if OBJ[j].has("at"): nxt = OBJ[j]; break
	var skipped: bool = nxt != null and player.position.x >= nxt.at + 2
	var done: bool = (obj_t > o.info) if o.has("info") else o.done.call()
	if done or skipped:
		obj_on = false; obj_i += 1; obj_cool = 0.9; ui.show_obj(o.icon, o.text, true); ui.touch.hint = ""
		if not o.has("info"): audio.play("chime", -6)

# ------------------------------------------------------------ what you see
func _process(dt: float) -> void:
	if state == "loading": return
	var young := in_arena
	ui.step(dt, young)
	audio.set_mood(_mood())
	var focus_x := player.position.x
	if in_arena and arena:
		focus_x = arena.visuals(dt, t)
		_hide_chapter_actors()
	else:
		_chapter_visuals(dt)
	_camera(dt, focus_x)

func _mood() -> String:
	if state == "title": return "title"
	if in_arena: return "pongal"
	if state == "credits" or (state == "cut" and cut_lines == ENDING): return "end"
	if state == "cut" and cut_lines == INTRO: return "title" if cut_i < 3 else "noon"
	if hall_spawned and player.position.x > Level.HALL.x0 - 2 and player.position.x < Level.HALL.x1 + 2: return "chase"
	return "noon"

func _hide_chapter_actors() -> void:
	for g in lane_glows: g.visible = false
	for r in walker_rigs: r.root.visible = false

func _chapter_visuals(dt: float) -> void:
	if state == "play" or state == "cut" or state == "title":
		level.compute_shadows(player.position.x - 14, player.position.x + 16)
	player.pose_rig(t)
	if state == "cut" and cut_lines == ENDING: Build.pose(player.rig, "run" if player.position.x < 176.19 else "idle", player.phase, t)
	var want_lie := 0.0
	if state == "title" or (state == "cut" and cut_lines == INTRO and cut_lines[cut_i].get("wake", -1) < 2): want_lie = 1.0
	lie = lerpf(lie, want_lie, minf(1.0, dt*2.5))
	var tilt: Node3D = player.rig.tilt
	tilt.rotation.x = -lie*PI/2*0.98; tilt.position = Vector3(0, lie*0.12, lie*0.9)
	player.rig.root.visible = player.alive
	var want_up := 1.0
	if state == "title" or (state == "cut" and cut_lines == INTRO and cut_lines[cut_i].get("wake", -1) < 1): want_up = 0.0
	nz_up = lerpf(nz_up, want_up, minf(1.0, dt*1.4))
	var nr: Node3D = nizhal.root
	nr.visible = player.alive
	nr.position = player.nz_pos; nr.rotation.y = PI/2 if player.face > 0 else -PI/2
	Build.pose(nizhal, "air" if not player.is_on_floor() else ("run" if absf(player.velocity.x) > 0.5 else "idle"), player.phase - 0.5, t + 0.4)
	(nizhal.tilt as Node3D).rotation.x = (1.0 - nz_up)*PI/2
	var tg = player.target
	ghost.root.visible = tg != null and player.alive and state == "play"
	if ghost.root.visible:
		ghost.root.position = Vector3(tg.x, tg.y, 0); ghost.root.rotation.y = nr.rotation.y
	var gi := 0
	if state == "play":
		for s in level.shadows:
			if gi >= lane_glows.size(): break
			if s.x2 - s.x1 < 0.6: continue
			var dd := minf(absf(s.x1 - player.position.x), absf(s.x2 - player.position.x))
			if dd > Player.STEP_R + 1 and not (player.position.x > s.x1 and player.position.x < s.x2): continue
			var g: MeshInstance3D = lane_glows[gi]; gi += 1
			g.visible = true; g.position = Vector3((s.x1 + s.x2)/2, s.y + 0.015, 0.2); g.scale = Vector3(s.x2 - s.x1, 1, 1)
	for k in range(gi, lane_glows.size()): lane_glows[k].visible = false
	for i in walker_rigs.size():
		var r: Dictionary = walker_rigs[i]
		if i >= walkers.size() or not walkers[i].alive: r.root.visible = false; continue
		var w: Dictionary = walkers[i]
		r.root.visible = true; r.root.position = Vector3(w.x, w.y, -0.05); r.root.rotation.y = PI/2 if player.position.x > w.x else -PI/2
		Build.pose(r, "hunch", w.ph, t)
		var k2: float = maxf(0.05, w.burn/0.7) if w.burn > 0 else 1.0
		r.root.scale = Vector3(1.12, 1.12*k2, 1.12)
	# HUD
	var ready := player.target != null and player.step_cd <= 0 and state == "play"
	ui.touch.ready_step = ready
	ui.touch.ready_cut = state == "play" and _cut_ready()
	ui.eye.text = "Shadow in reach" if ready else ("In shadow" if level.shade_at(player.position.x, player.position.y) else "In the sun")
	ui.eye_dot.color = Color(0.65, 0.55, 0.98) if ready else Color(0.24, 0.19, 0.31)
	ui.mem.text = "◆ %d/%d   %d:%02d" % [mem_count, Level.MEMS.size(), int(play_time/60), int(play_time) % 60]

func _cut_ready() -> bool:
	for c in level.CANOPIES:
		if not c.cut and absf(player.position.x - c.post) < 2.2: return true
	for w in walkers:
		if w.alive and w.burn == 0.0 and absf(w.x - player.position.x) < 2.6: return true
	return false

func _camera(dt: float, focus_x: float) -> void:
	var vp := get_viewport().get_visible_rect().size
	var aspect := vp.x/maxf(1.0, vp.y)
	if state == "play":
		if player.is_on_floor() or player.position.y < cam_y - 0.6 or not player.alive: cam_y += (player.position.y - cam_y)*minf(1.0, dt*4)
		cam_ahead += ((player.face*1.7 + player.velocity.x*0.2) - cam_ahead)*minf(1.0, dt*2.4)
		var dist := maxf(14.5, 7.2/(tan(deg_to_rad(19))*aspect))
		cam_look_t = Vector3(player.position.x + cam_ahead, cam_y + 1.7, 0)
		cam_pos_t = Vector3(cam_look_t.x - 0.8, cam_look_t.y + 1.6 + dist*0.05, dist)
	elif state == "jk":
		var d2 := maxf(9.0, 6.0/(tan(deg_to_rad(19))*aspect))
		cam_look_t = Vector3(focus_x, 1.5, 0); cam_pos_t = Vector3(focus_x + 0.4, 2.7, d2)
	var k := minf(1.0, dt*(1.4 if state == "cut" else 7.0))
	cam_pos = cam_pos.lerp(cam_pos_t, k); cam_look = cam_look.lerp(cam_look_t, k)
	shake = maxf(0, shake - dt)
	var sh := Vector3(randf() - 0.5, randf() - 0.5, 0)*shake*0.25
	camera.position = cam_pos + sh
	camera.look_at(cam_look, Vector3.UP)

# ------------------------------------------------------------ self-test (godot --headless -- --autotest)
func _bot_start() -> void:
	bot = {"phase": "intro", "log": [], "last_obj": -1, "frames": 0, "wait": 0}
	print("[bot] start")

func _bot_tick() -> void:
	bot.frames += 1
	var tc: TouchControls = ui.touch
	if bot.frames > 120*60*6: print("[bot] TIMEOUT state=", state, " x=", player.position.x); get_tree().quit(1); return
	if state in ["title", "cut", "credits"]:
		if bot.frames % 40 == 0:
			if state == "credits": print("[bot] REACHED CREDITS deaths=", deaths, " memories=", mem_count, " jk_score=", arena.score); get_tree().quit(0)
			tc.tap = true
		return
	if state == "play":
		if obj_i != bot.last_obj: print("[bot] objective ", obj_i, " at x=", snappedf(player.position.x, 0.1), " y=", snappedf(player.position.y, 0.01)); bot.last_obj = obj_i
		var px := player.position.x; var py := player.position.y
		var run := 1.0
		for c in level.CANOPIES:
			if not c.cut and px > c.post - 1.5 and px < c.post + 1.0:
				run = 0.0
				if bot.frames % 20 == 0: tc.pressed.cut = true
		if px > 95.0 and px < 96.0 and not (player.target != null and player.target.x > 103): run = 0.0
		if player.is_on_floor() and ((px > 8.6 and px < 9.2 and py < 0.1) or (px > 12.4 and px < 13 and py > 1.1 and py < 1.3) or (px > 29.0 and px < 29.8)):
			tc.pressed.jump = true; tc.held.jump = true; bot.hold = 40
		if bot.get("hold", 0) > 0:
			bot.hold -= 1
			if bot.hold == 0: tc.held.jump = false
		if player.target != null and player.target.x - px > 3: tc.pressed.step = true
		for w in walkers:
			if w.alive and w.burn == 0.0 and absf(w.x - px) < 2.2 and bot.frames % 15 == 0: tc.pressed.cut = true
		tc.axis = run
	elif state == "jk":
		var j = arena.jk
		if j == null: return
		if j.phase == "charge" and j.tta < 0.12 and not j.has("bot_g"): j.bot_g = true; tc.tap = true
		if j.phase == "ride" and j.in_win:
			var w: int = j.beat_n + 1 if (j.per - j.buck_t) < 0.3 else j.beat_n
			if not j.hit.has(w) and j.get("bot_l", -9) != w: j.bot_l = w; tc.tap = true
		if j.phase == "snatch" and j.t > j.dip_at and not j.snatch_try: tc.tap = true
		if j.phase == "result" and bot.get("res", -1) != j.i*10 + int(j.success):
			bot.res = j.i*10 + int(j.success); print("[bot] bull ", j.i, " success=", j.success, " hearts=", j.hearts, " streak=", j.best_combo, " score=", arena.score)
