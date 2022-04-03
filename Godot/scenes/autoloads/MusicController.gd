extends Node


var music = load("res://assets/sounds/sfxrjam.ogg")
var music_state = "user://music_state.save"
var muted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_music_state()


func stop_music():
	$Music.stream = music
	$Music.stop()
	muted = true
	save_music_state()


func play_music():
	$Music.stream = music
	$Music.play()
	muted = false
	save_music_state()


func load_music_state():
	var f = File.new()
	if f.file_exists(music_state):
		f.open(music_state, File.READ)
		muted = f.get_var()
		f.close()
	else:
		muted = false


func save_music_state():
	var f = File.new()
	f.open(music_state, File.WRITE)
	f.store_var(muted)
	f.close()

