extends Node

var menu

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = load("res://scenes/menu.tscn")


func _on_Home_pressed():
	get_parent().add_child(menu.instance())
	queue_free()


func _on_Clear_Hiscores_pressed():
	print("Hiscores cleared")
	$Clear_Hiscores/Label.text = "Cleared!"
	Global.highscore = 0
	Global.save_score()
