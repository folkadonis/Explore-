## On-screen controls for phones. Touches are read here directly, before any other UI,
## so no text box can ever swallow them. Several fingers at once are fine.
class_name TouchControls
extends Control

var axis := 0.0
var held := {"jump": false, "step": false, "cut": false}
var pressed := {"jump": false, "step": false, "cut": false}
var tap := false            # any touch anywhere (used by the bull ride and cutscenes)
var mode := "play"          # "play", "tap" (one big button) or "hidden"
var ready_step := false
var ready_cut := false
var hint := ""              # which button pulses
var fingers := {}           # touch index -> "stick" or a button name
var stick_origin := Vector2.ZERO
var stick_pos := Vector2.ZERO
var font: Font
const R := 46.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)
	font = load("res://assets/ui/AlegreyaSans-Bold.ttf")

func buttons() -> Dictionary:
	var s := size
	var m := 22.0
	if mode == "tap": return {"jump": [Vector2(s.x - 70 - m, s.y - 70 - m), 64.0]}
	return {
		"jump": [Vector2(s.x - 54 - m, s.y - 54 - m), 52.0],
		"step": [Vector2(s.x - 162 - m, s.y - 50 - m), 48.0],
		"cut": [Vector2(s.x - 62 - m, s.y - 166 - m), 38.0],
	}

func stick_home() -> Vector2: return Vector2(minf(size.x*0.18, 150), size.y - 110)

func _input(e: InputEvent) -> void:
	if e is InputEventScreenTouch:
		var t := e as InputEventScreenTouch
		if t.pressed:
			tap = true
			if mode == "hidden": return
			for k in buttons():
				var b: Array = buttons()[k]
				if t.position.distance_to(b[0]) < b[1] + 14:
					fingers[t.index] = k; held[k] = true; pressed[k] = true
					Input.vibrate_handheld(8)
					queue_redraw(); return
			if mode == "play" and t.position.x < size.x*0.45 and t.position.y > size.y*0.25:
				fingers[t.index] = "stick"; stick_origin = t.position; stick_pos = t.position; axis = 0.0
				queue_redraw()
		else:
			var k2: String = fingers.get(t.index, "")
			fingers.erase(t.index)
			if k2 == "stick": axis = 0.0
			elif k2 != "": held[k2] = false
			if fingers.is_empty(): release_all()
			queue_redraw()
	elif e is InputEventScreenDrag:
		var d := e as InputEventScreenDrag
		if fingers.get(d.index, "") == "stick":
			var dx := d.position.x - stick_origin.x
			if absf(dx) > R:
				stick_origin.x += dx - signf(dx)*R   # the stick follows the thumb
				dx = signf(dx)*R
			stick_pos = Vector2(stick_origin.x + dx, stick_origin.y + clampf(d.position.y - stick_origin.y, -R, R)*0.35)
			var a := dx/R
			axis = 0.0 if absf(a) < 0.2 else signf(a)*minf(1.0, (absf(a) - 0.2)/0.55)
			queue_redraw()

func release_all() -> void:
	fingers.clear(); axis = 0.0
	for k in held: held[k] = false
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED: release_all()

func consume() -> void:
	for k in pressed: pressed[k] = false
	tap = false

func _process(_dt: float) -> void:
	if hint != "" or ready_step or ready_cut: queue_redraw()

func _draw() -> void:
	if mode == "hidden": return
	var t := Time.get_ticks_msec()/1000.0
	if mode == "play":
		var c := stick_home() if not fingers.values().has("stick") else stick_origin
		var kp := c if not fingers.values().has("stick") else stick_pos
		draw_circle(c, 64, Color(0.08, 0.05, 0.13, 0.35))
		draw_arc(c, 64, 0, TAU, 48, Color(0.8, 0.75, 0.9, 0.45), 2.0)
		draw_circle(kp, 29, Color(0.96, 0.93, 0.89, 0.25))
		draw_arc(kp, 29, 0, TAU, 32, Color(0.96, 0.93, 0.89, 0.75), 2.0)
		if not fingers.values().has("stick"):
			draw_string(font, c + Vector2(-60, -82), "DRAG TO RUN", HORIZONTAL_ALIGNMENT_CENTER, 120, 14, Color(0.9, 0.87, 0.98, 0.8))
	var labels := {"jump": "JUMP", "step": "STEP", "cut": "CUT"}
	if mode == "tap": labels = {"jump": "TAP"}
	for k in buttons():
		var b: Array = buttons()[k]
		var col := Color(0.08, 0.05, 0.13, 0.45)
		if held.get(k, false): col = Color(0.49, 0.23, 0.93, 0.55)
		elif k == "step" and ready_step: col = Color(0.49, 0.23, 0.93, 0.45 + 0.1*sin(t*6))
		elif k == "cut" and ready_cut: col = Color(0.91, 0.71, 0.36, 0.38 + 0.1*sin(t*6))
		draw_circle(b[0], b[1], col)
		var edge := Color(0.65, 0.55, 0.98) if k == "step" else Color(0.85, 0.82, 0.92, 0.6)
		draw_arc(b[0], b[1], 0, TAU, 48, edge, 2.0)
		if hint == k:
			var p := fmod(t, 1.1)/1.1
			draw_arc(b[0], b[1] + 6 + p*20, 0, TAU, 48, Color(0.75, 0.6, 1.0, 1.0 - p), 3.0)
		draw_string(font, b[0] + Vector2(-50, 6), labels[k], HORIZONTAL_ALIGNMENT_CENTER, 100, 16, Color(0.97, 0.94, 0.9))
