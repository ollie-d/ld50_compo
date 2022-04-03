# TODO
# - add home button and maybe sound options on pause menu
# - fix bug where the end message changing text is visible for about 1 frame
# - make the game harder after 20k? Maybe off a waterfall?
#	- Increase obstacle speed?
#	- Add obstacles that move at different speeds? e.g. driftwood


extends Node

const game = preload("res://scenes/main.tscn")
#const creds = preload("res://scenes/Credits.tscn")
#const rocks = preload("res://scenes/Rock.tscn")
#const options = preload("res://scenes/Options.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBox0/Hiscore.text = "High Score: {hs}".format({"hs":Global.highscore})
	if !MusicController.get_child(0).playing and !MusicController.muted:
		MusicController.play_music()
	elif MusicController.muted:
		MusicController.stop_music()

func _process(delta):
	pass


func _on_Play_pressed():
	get_parent().add_child(game.instance())
	queue_free()
