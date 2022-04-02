extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Planet.modulate = Color(0.3, 0.8, 1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
