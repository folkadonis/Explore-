## Everything drawn over the 3D view. Nothing here takes touches; the TouchControls do.
class_name UI
extends CanvasLayer

const GOLD := Color(0.91, 0.71, 0.36)
const VIOLET := Color(0.65, 0.55, 0.98)
const INK := Color(0.96, 0.93, 0.89)
const PANEL := Color(0.055, 0.035, 0.085, 0.8)

var f_display: Font
var f_body: Font
var f_bold: Font
var f_italic: Font
var root: Control
var touch: TouchControls
var eye: Label
var eye_dot: ColorRect
var chap: Label
var mem: Label
var obj_box: PanelContainer
var obj_icon: Label
var obj_text: Label
var toast_box: PanelContainer
var toast_por: TextureRect
var toast_name: Label
var toast_text: Label
var bars: Array = []
var sub_box: VBoxContainer
var sub_por: TextureRect
var sub_name: Label
var sub_text: Label
var sub_hint: Label
var title_box: VBoxContainer
var death_label: Label
var credits_box: VBoxContainer
var credits_stats: Label
var credits_rank: Label
var hud: Control
var jk_box: PanelContainer
var jk_name: Label
var jk_line: Label
var jk_hearts: Label
var jk_flash: Label
var jk_res: PanelContainer
var jk_res_h: Label
var jk_res_p: Label
var jk_res_s: Label
var ring: Control
var ring_state := {"show": false, "pos": Vector2.ZERO, "scale": 1.0, "now": false, "beat": false, "label": ""}
var toast_q: Array = []
var toast_cur = null
var portraits := {}
var flash_t := 0.0

func _ready() -> void:
	f_display = load("res://assets/ui/Marcellus-Regular.ttf")
	f_body = load("res://assets/ui/AlegreyaSans-Regular.ttf")
	f_bold = load("res://assets/ui/AlegreyaSans-Bold.ttf")
	f_italic = load("res://assets/ui/AlegreyaSans-Italic.ttf")
	portraits = {"adult": load("res://assets/ui/ilan.webp"), "young": load("res://assets/ui/ilan16.webp")}
	root = Control.new(); root.set_anchors_preset(Control.PRESET_FULL_RECT); root.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(root)
	_build_hud(); _build_obj(); _build_toast(); _build_bars(); _build_sub(); _build_jk(); _build_title(); _build_death(); _build_credits()
	touch = TouchControls.new(); root.add_child(touch)
	_ignore(root)

func _ignore(n: Node) -> void:
	if n is Control and n != touch: (n as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
	for c in n.get_children(): _ignore(c)

func lab(text: String, font: Font, size: int, col := INK) -> Label:
	var l := Label.new(); l.text = text
	l.add_theme_font_override("font", font); l.add_theme_font_size_override("font_size", size); l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.6)); l.add_theme_constant_override("shadow_offset_y", 2)
	return l

func panel(radius := 12, border := Color(0, 0, 0, 0)) -> PanelContainer:
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new(); sb.bg_color = PANEL; sb.set_corner_radius_all(radius); sb.content_margin_left = 16; sb.content_margin_right = 16; sb.content_margin_top = 9; sb.content_margin_bottom = 10
	if border.a > 0: sb.border_color = border; sb.set_border_width_all(1)
	p.add_theme_stylebox_override("panel", sb)
	return p

func _build_hud() -> void:
	hud = Control.new(); hud.set_anchors_preset(Control.PRESET_FULL_RECT); root.add_child(hud)
	var pill := panel(999); pill.position = Vector2(18, 16); hud.add_child(pill)
	var h := HBoxContainer.new(); h.add_theme_constant_override("separation", 10); pill.add_child(h)
	eye_dot = ColorRect.new(); eye_dot.custom_minimum_size = Vector2(22, 10); eye_dot.color = Color(0.24, 0.19, 0.31); eye_dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER; h.add_child(eye_dot)
	eye = lab("In the sun", f_bold, 15); h.add_child(eye)
	chap = lab("I · The Coronation of Ash", f_display, 17); chap.set_anchors_preset(Control.PRESET_TOP_RIGHT); chap.position = Vector2(-300, 16); chap.size = Vector2(282, 30); chap.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; hud.add_child(chap)
	mem = lab("◆ 0/8   0:00", f_bold, 15, Color(0.85, 0.8, 1.0)); mem.set_anchors_preset(Control.PRESET_TOP_RIGHT); mem.position = Vector2(-300, 46); mem.size = Vector2(282, 26); mem.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; hud.add_child(mem)

func _build_obj() -> void:
	obj_box = panel(12, Color(0.65, 0.55, 0.98, 0.5)); obj_box.set_anchors_preset(Control.PRESET_CENTER_TOP); obj_box.position = Vector2(-300, 64); obj_box.custom_minimum_size = Vector2(600, 0); root.add_child(obj_box)
	var h := HBoxContainer.new(); h.add_theme_constant_override("separation", 14); obj_box.add_child(h)
	obj_icon = lab("", f_bold, 15, Color(0.9, 0.87, 0.98)); obj_icon.custom_minimum_size = Vector2(70, 0); obj_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; h.add_child(obj_icon)
	obj_text = lab("", f_body, 18); obj_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; obj_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL; h.add_child(obj_text)
	obj_box.visible = false

func _build_toast() -> void:
	toast_box = panel(12); toast_box.set_anchors_preset(Control.PRESET_CENTER_BOTTOM); toast_box.position = Vector2(-280, -128); toast_box.custom_minimum_size = Vector2(560, 0); root.add_child(toast_box)
	var h := HBoxContainer.new(); h.add_theme_constant_override("separation", 12); toast_box.add_child(h)
	toast_por = TextureRect.new(); toast_por.custom_minimum_size = Vector2(44, 44); toast_por.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; toast_por.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; h.add_child(toast_por)
	var v := VBoxContainer.new(); v.size_flags_horizontal = Control.SIZE_EXPAND_FILL; h.add_child(v)
	toast_name = lab("", f_display, 13, GOLD); v.add_child(toast_name)
	toast_text = lab("", f_body, 18); toast_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; v.add_child(toast_text)
	toast_box.visible = false

func _build_bars() -> void:
	for top in [true, false]:
		var b := ColorRect.new(); b.color = Color.BLACK
		b.set_anchors_preset(Control.PRESET_TOP_WIDE if top else Control.PRESET_BOTTOM_WIDE)
		b.size = Vector2(4000, 0); b.position = Vector2(0, 0)
		root.add_child(b); bars.append(b)

func _build_sub() -> void:
	sub_box = VBoxContainer.new(); sub_box.set_anchors_preset(Control.PRESET_CENTER_BOTTOM); sub_box.position = Vector2(-380, -190); sub_box.custom_minimum_size = Vector2(760, 0); sub_box.alignment = BoxContainer.ALIGNMENT_END; root.add_child(sub_box)
	sub_por = TextureRect.new(); sub_por.custom_minimum_size = Vector2(52, 52); sub_por.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; sub_por.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; sub_box.add_child(sub_por)
	sub_name = lab("", f_display, 15, GOLD); sub_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sub_box.add_child(sub_name)
	sub_text = lab("", f_italic, 25); sub_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sub_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; sub_box.add_child(sub_text)
	sub_hint = lab("Tap to continue", f_body, 14, Color(1, 1, 1, 0.55)); sub_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sub_box.add_child(sub_hint)
	sub_box.visible = false

func _build_jk() -> void:
	jk_box = panel(12); jk_box.set_anchors_preset(Control.PRESET_CENTER_BOTTOM); jk_box.position = Vector2(-200, -150); jk_box.custom_minimum_size = Vector2(400, 0); root.add_child(jk_box)
	var v := VBoxContainer.new(); v.alignment = BoxContainer.ALIGNMENT_CENTER; jk_box.add_child(v)
	jk_name = lab("", f_display, 16, GOLD); jk_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v.add_child(jk_name)
	jk_line = lab("", f_bold, 18); jk_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v.add_child(jk_line)
	jk_hearts = lab("◆ ◆ ◆", f_bold, 26, GOLD); jk_hearts.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v.add_child(jk_hearts)
	var tip := lab("TAP ANYWHERE", f_bold, 13, Color(1, 1, 1, 0.65)); tip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v.add_child(tip)
	jk_box.visible = false
	jk_flash = lab("", f_display, 34, GOLD); jk_flash.set_anchors_preset(Control.PRESET_CENTER); jk_flash.position = Vector2(-300, 30); jk_flash.size = Vector2(600, 50); jk_flash.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; root.add_child(jk_flash)
	jk_res = panel(14, Color(0.91, 0.71, 0.36, 0.5)); jk_res.set_anchors_preset(Control.PRESET_CENTER); jk_res.position = Vector2(-260, -110); jk_res.custom_minimum_size = Vector2(520, 0); root.add_child(jk_res)
	var v2 := VBoxContainer.new(); jk_res.add_child(v2)
	jk_res_h = lab("", f_display, 30); jk_res_h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v2.add_child(jk_res_h)
	jk_res_p = lab("", f_body, 17); jk_res_p.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; jk_res_p.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; v2.add_child(jk_res_p)
	jk_res_s = lab("", f_bold, 18, GOLD); jk_res_s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v2.add_child(jk_res_s)
	jk_res.visible = false
	ring = Control.new(); ring.set_anchors_preset(Control.PRESET_FULL_RECT); root.add_child(ring)
	ring.draw.connect(_draw_ring)

func _draw_ring() -> void:
	var r: Dictionary = ring_state
	if not r.show: return
	var base := 48.0
	var col := Color.WHITE if r.now else GOLD
	ring.draw_arc(r.pos, base, 0, TAU, 48, Color(1, 1, 1, 0.5), 2.0)
	ring.draw_arc(r.pos, base*r.scale, 0, TAU, 64, col, 4.0)
	if r.label != "": ring.draw_string(f_bold, r.pos + Vector2(-50, 6), r.label, HORIZONTAL_ALIGNMENT_CENTER, 100, 16, Color.WHITE)

func _build_title() -> void:
	title_box = VBoxContainer.new(); title_box.set_anchors_preset(Control.PRESET_FULL_RECT); title_box.alignment = BoxContainer.ALIGNMENT_CENTER; root.add_child(title_box)
	for t in [["VEL NADU · THE CORONATION MORNING", f_display, 15, VIOLET], ["Shadows of Kanchi", f_display, 76, INK], ["Chapter I · The Coronation of Ash", f_italic, 24, Color(0.94, 0.85, 0.68)], ["", f_body, 10, INK], ["Tap to begin", f_body, 18, Color(1, 1, 1, 0.8)]]:
		var l := lab(t[0], t[1], t[2], t[3]); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; title_box.add_child(l)

func _build_death() -> void:
	death_label = lab("", f_italic, 30, GOLD); death_label.set_anchors_preset(Control.PRESET_FULL_RECT); death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; root.add_child(death_label)

func _build_credits() -> void:
	credits_box = VBoxContainer.new(); credits_box.set_anchors_preset(Control.PRESET_FULL_RECT); credits_box.alignment = BoxContainer.ALIGNMENT_CENTER; root.add_child(credits_box)
	var bg := ColorRect.new(); bg.color = Color(0.03, 0.02, 0.05, 0.86); bg.set_anchors_preset(Control.PRESET_FULL_RECT); bg.show_behind_parent = true; credits_box.add_child(bg)
	for t in [["END OF CHAPTER I · INTERLUDE I", f_display, 15, VIOLET], ["The Coronation of Ash", f_display, 46, INK]]:
		var l := lab(t[0], t[1], t[2], t[3]); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; credits_box.add_child(l)
	credits_stats = lab("", f_body, 19); credits_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; credits_box.add_child(credits_stats)
	credits_rank = lab("", f_italic, 19, Color(0.94, 0.85, 0.68)); credits_rank.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; credits_rank.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; credits_box.add_child(credits_rank)
	var n := lab("Next: The Drowned Stepwell", f_italic, 19, Color(0.94, 0.85, 0.68)); n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; credits_box.add_child(n)
	var a := lab("Tap to play again", f_body, 15, Color(1, 1, 1, 0.6)); a.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; credits_box.add_child(a)
	credits_box.visible = false

# ------------------------------------------------------------ API used by the game
const NAMES := {"VO": "ILAN", "MEM": "SHADOW-MEMORY", "HINT": ""}
func portrait_for(sp: String, young: bool):
	if sp in ["ILAN", "VO", "NIZHAL"]: return portraits["young" if young else "adult"]
	return null

func say(sp: String, text: String) -> void:
	toast_q.append({"sp": sp, "text": text, "dur": maxf(2.8, text.length()*0.06), "t": 0.0})

func clear_toasts() -> void:
	toast_q.clear(); toast_cur = null; toast_box.visible = false

func show_obj(icon: String, text: String, done := false) -> void:
	obj_box.visible = true; obj_icon.text = "✓" if done else icon; obj_text.text = text
	(obj_box.get_theme_stylebox("panel") as StyleBoxFlat).border_color = Color(0.53, 0.89, 0.68) if done else Color(0.65, 0.55, 0.98, 0.5)

func hide_obj() -> void: obj_box.visible = false

func subtitle(sp: String, text: String, young := false) -> void:
	sub_box.visible = true
	sub_name.text = NAMES.get(sp, sp)
	sub_name.add_theme_color_override("font_color", VIOLET if sp == "NIZHAL" else GOLD)
	sub_text.text = text
	var p = portrait_for(sp, young)
	sub_por.texture = p; sub_por.visible = p != null
	sub_por.modulate = Color(0.25, 0.2, 0.35) if sp == "NIZHAL" else Color.WHITE

func hide_sub() -> void: sub_box.visible = false

func cine(on: bool) -> void:
	var h := get_viewport().get_visible_rect().size.y*0.11 if on else 0.0
	for i in 2:
		var b: ColorRect = bars[i]
		var tw := create_tween(); tw.tween_property(b, "size:y", h, 0.7)
		if i == 1: tw.parallel().tween_property(b, "position:y", get_viewport().get_visible_rect().size.y - h, 0.7)

func flash(text: String, good: bool) -> void:
	jk_flash.text = text; jk_flash.add_theme_color_override("font_color", GOLD if good else Color(1, 0.55, 0.48)); flash_t = 0.7

func step(dt: float, young: bool) -> void:
	if toast_cur == null and toast_q.size() > 0:
		toast_cur = toast_q.pop_front()
		toast_box.visible = true
		var sp: String = toast_cur.sp
		toast_name.text = NAMES.get(sp, sp); toast_name.visible = toast_name.text != ""
		toast_name.add_theme_color_override("font_color", VIOLET if sp in ["NIZHAL", "MEM"] else GOLD)
		toast_text.text = toast_cur.text
		var p = portrait_for(sp, young)
		toast_por.texture = p; toast_por.visible = p != null
		toast_por.modulate = Color(0.25, 0.2, 0.35) if sp == "NIZHAL" else Color.WHITE
	if toast_cur != null:
		toast_cur.t += dt
		if toast_cur.t > toast_cur.dur: toast_cur = null; toast_box.visible = false
	flash_t = maxf(0, flash_t - dt); jk_flash.visible = flash_t > 0
	ring.queue_redraw()
