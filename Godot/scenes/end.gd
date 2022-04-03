extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var menu
var game


# Called when the node enters the scene tree for the first time.
func _ready():
	# Load next states
	menu = load("res://scenes/menu.tscn")
	game = load("res://scenes/main.tscn")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomize()
	var msg = "Everybody died.\r\nNumber of relationships formed: {x1}\r\nNumber of hearts broken: {x2}\r\nNumber of asteroids destroyed: {x5}\r\nNumber of citizens destroyed: {x6}\r\nScore: {x7}"
	var total_born = ceil(Global.score * rng.randf_range(10000000000, 20000000000))
	var relationships = floor(total_born / rng.randi_range(2, 6))
	var heartbreaks = floor(relationships / rng.randi_range(2, 6))
	$Center0/V0/C2/msg.text  = msg.format({"x1":relationships,
										   "x2":heartbreaks,
										   "x5":Global.asteroids_killed,
										   "x6":total_born,
										   "x7":Global.score,})


func _on_Restart_pressed():
	get_parent().add_child(game.instance())
	queue_free()


func _on_Home_pressed():
	get_parent().add_child(menu.instance())
	queue_free()
