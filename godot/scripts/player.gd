## Ilan: run, jump, Shadow Step and Cut. A physics body kept on the lane (z = 0).
class_name Player
extends CharacterBody3D

const RUN := 6.2
const G := 26.0
const JV := 9.0
const STEP_R := 10.5

var level: Level
var face := 1
var coy := 0.0
var jbuf := 0.0
var sbuf := 0.0
var s_armed := false
var jumping := false
var step_cd := 0.0
var atk := 0.0
var atk_cd := 0.0
var phase := 0.0
var squash := 0.0
var alive := true
var fell := false
var safe := Vector3.ZERO
var target = null          # {x, y} or null
var rig: Dictionary
var nz_pos := Vector3.ZERO  # where Nizhal (his shadow) stands

signal stepped(from, to)
signal cut_swung
signal landed
signal jumped

func setup(lv: Level) -> void:
	level = lv
	collision_layer = 0
	collision_mask = Level.WALK
	floor_snap_length = 0.15
	floor_max_angle = deg_to_rad(50)
	var cs := CollisionShape3D.new()
	var sh := CapsuleShape3D.new(); sh.radius = 0.25; sh.height = 1.75
	cs.shape = sh; cs.position = Vector3(0, 0.875, 0)
	add_child(cs)
	rig = Build.rig({"skin": Build.M("skin"), "cloth": Build.M("cotton"), "hair": Build.M("hair")}, {"sash": true, "armband": true, "sword": true, "shard": Build.glow("shard", Color(0.55, 0.35, 1.2), 2.0)})
	add_child(rig.root)

func spawn(at: Vector3) -> void:
	position = Vector3(at.x, at.y, 0)
	velocity = Vector3.ZERO
	alive = true; fell = false; jumping = false; step_cd = 0; atk = 0
	safe = position
	nz_pos = position - Vector3(0.8, 0, 0)

func control(dt: float, ax: float, jump_pressed: bool, jump_held: bool, step_pressed: bool, cut_pressed: bool) -> void:
	if absf(ax) > 0.05: face = signi(int(signf(ax)))
	var on_floor := is_on_floor()
	velocity.x += (ax*RUN - velocity.x)*minf(1.0, dt*(18.0 if on_floor else 10.0))
	coy = 0.16 if on_floor else coy - dt
	jbuf = 0.2 if jump_pressed else jbuf - dt
	if jbuf > 0 and coy > 0:
		velocity.y = JV; coy = 0; jbuf = 0; jumping = true; jumped.emit()
	if jumping and not jump_held and velocity.y > 3.2:
		velocity.y = 3.2; jumping = false
	var g := G
	if velocity.y < 0: g *= 1.45
	elif jump_held and velocity.y < 1.4: g *= 0.6
	velocity.y = maxf(velocity.y - g*dt, -24.0)
	var vy0 := velocity.y
	var was_air := not on_floor
	velocity.z = 0
	move_and_slide()
	position.z = 0
	# ledge assist: low steps are walked up; a ledge you nearly made in a jump is climbed onto
	if is_on_wall() and absf(ax) > 0.1:
		for rise in [0.15, 0.3, 0.45, 0.6, 0.8]:
			if rise > (0.45 if is_on_floor() else 0.8) or velocity.y > 5: break
			if not level.solid_at(position.x + face*0.08, position.y + rise):
				position.y += rise; position.x += face*0.08; velocity.y = 0; squash = 0.12; break
	if is_on_floor():
		jumping = false
		if was_air and vy0 < -4: squash = 0.12; landed.emit()
		var f := level.floor_under(position.x, position.y)
		if not f.is_empty(): safe = Vector3(clampf(position.x, f.x0 + 0.8, f.x1 - 0.8), f.top, 0)
	phase += dt*(absf(velocity.x)*2.1 if (absf(velocity.x) > 0.5 and is_on_floor()) else 0.0)
	squash = maxf(0, squash - dt)
	# Shadow Step
	target = find_target(face)
	step_cd -= dt
	if step_pressed: sbuf = 0.25; s_armed = true
	else: sbuf -= dt
	if sbuf > 0 and step_cd <= 0 and target == null and step_pressed:
		var back = find_target(-face)
		if back != null: face = -face; target = back
	if sbuf > 0 and step_cd <= 0 and target != null:
		do_step(); sbuf = 0; s_armed = false
	elif sbuf <= 0 and s_armed:
		s_armed = false
	# Cut
	atk_cd -= dt; atk = maxf(0, atk - dt)
	if cut_pressed and atk_cd <= 0:
		atk = 0.22; atk_cd = 0.28; cut_swung.emit()
	nz_pos = nz_pos.lerp(Vector3(position.x - 0.8*face, position.y, -0.45), minf(1.0, dt*6))
	if position.y < -5 and alive: alive = false; fell = true

func find_target(dir: int):
	var best = null
	var bd := -1.0
	for s in level.shadows:
		if s.x2 - s.x1 < 0.6: continue
		var dy: float = s.y - position.y
		if absf(dy) > 5: continue
		var mx := sqrt(STEP_R*STEP_R - dy*dy)
		var tx: float
		if dir > 0:
			var lo := maxf(s.x1 + 0.3, position.x + 1.0); var hi := minf(s.x2 - 0.3, position.x + mx)
			if lo > hi: continue
			tx = hi
		else:
			var lo2 := maxf(s.x1 + 0.3, position.x - mx); var hi2 := minf(s.x2 - 0.3, position.x - 1.0)
			if lo2 > hi2: continue
			tx = lo2
		if level.solid_at(tx, s.y): continue
		var d := absf(tx - position.x)
		if d > bd: bd = d; best = {"x": tx, "y": s.y}
	return best

func do_step() -> void:
	var from := position
	position = Vector3(target.x, target.y + 0.01, 0)
	velocity = Vector3(velocity.x*0.4, 0, 0)
	coy = 0.12; jumping = false; step_cd = 0.4; squash = 0.12
	nz_pos = position - Vector3(0.8*face, 0, 0)
	stepped.emit(from, position)
	target = null

func pose_rig(t: float) -> void:
	var r := rig
	(r.root as Node3D).rotation.y = PI/2 if face > 0 else -PI/2
	var moving := absf(velocity.x) > 0.5
	var name := "air" if not is_on_floor() else ("run" if moving else "idle")
	Build.pose(r, name, phase, t, atk)
	(r.sword as Node3D).visible = atk > 0
	var sq := sin(squash/0.12*PI)*0.08 if squash > 0 else 0.0
	(r.root as Node3D).scale = Vector3(1 + sq*0.5, 1 - sq, 1 + sq*0.5)
