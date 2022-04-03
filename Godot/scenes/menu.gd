# TODO
# - add home button and maybe sound options on pause menu
# - fix bug where the end message changing text is visible for about 1 frame
# - make the game harder after 20k? Maybe off a waterfall?
#	- Increase obstacle speed?
#	- Add obstacles that move at different speeds? e.g. driftwood


extends Node

const game = preload("res://scenes/main.tscn")
const instructions = preload("res://scenes/instructions.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBox0/Hiscore.text = "High Score: {hs}".format({"hs":Global.highscore})
	if !MusicController.get_child(0).playing and !MusicController.muted:
		MusicController.play_music()
		$Center0/V0/C3/H0/Sound.texture_normal = load("res://assets/sprites/buttons/sound_button.png")
	elif MusicController.muted:
		MusicController.stop_music()
		$Center0/V0/C3/H0/Sound.texture_normal = load("res://assets/sprites/buttons/sound_button_muted.png")

func _process(delta):
	pass


func _on_Play_pressed():
	get_parent().add_child(game.instance())
	queue_free()


func _on_Credits_pressed():
	get_parent().add_child(instructions.instance())
	queue_free()


func _on_Sound_pressed():
	if MusicController.get_child(0).playing:
		# Mute music
		MusicController.stop_music()
		MusicController.muted = true
		$Center0/V0/C3/H0/Sound.texture_normal = load("res://assets/sprites/buttons/sound_button_muted.png")
	else:
		# Play music
		MusicController.play_music()
		MusicController.muted = false
		$Center0/V0/C3/H0/Sound.texture_normal = load("res://assets/sprites/buttons/sound_button.png")
