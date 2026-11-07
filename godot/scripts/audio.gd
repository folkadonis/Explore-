## Score and sound effects. Music crossfades between moods; effects play from a small pool.
class_name Audio
extends Node

var music := {}
var players: Array[AudioStreamPlayer] = []
var current := ""
var sfx_pool: Array[AudioStreamPlayer] = []
var sfx := {}
var started := false

func _ready() -> void:
	for m in ["title", "noon", "chase", "pongal", "end"]:
		var s: AudioStreamOggVorbis = load("res://assets/audio/music_%s.ogg" % m)
		s.loop = true
		music[m] = s
	for i in 2:
		var p := AudioStreamPlayer.new(); p.volume_db = -80; add_child(p); players.append(p)
	for f in ["step", "jump", "land", "cut", "cloth", "death", "burn", "rumble", "fizzle", "chime", "collect", "roar", "hoof", "firm", "bell"]:
		sfx[f] = load("res://assets/audio/sfx_%s.ogg" % f)
	for i in 8:
		var p2 := AudioStreamPlayer.new(); add_child(p2); sfx_pool.append(p2)

func set_mood(m: String) -> void:
	if m == current or not music.has(m): return
	current = m
	var incoming := players[0] if not players[0].playing or players[0].volume_db < -40 else players[1]
	var outgoing := players[1] if incoming == players[0] else players[0]
	incoming.stream = music[m]; incoming.volume_db = -40; incoming.play()
	var tw := create_tween().set_parallel(true)
	tw.tween_property(incoming, "volume_db", -6.0, 1.6)
	tw.tween_property(outgoing, "volume_db", -80.0, 1.6)

func play(name: String, vol := 0.0, pitch := 1.0) -> void:
	if not sfx.has(name): return
	for p in sfx_pool:
		if not p.playing:
			p.stream = sfx[name]; p.volume_db = vol; p.pitch_scale = pitch; p.play(); return
