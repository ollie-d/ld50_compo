extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var c = move_and_collide(Vector2(1, 1) * delta)
	if c:
		print('died')


func _on_Rotation_Timer_timeout():
	self.rotate(deg2rad(1))
	
	
func destroy():
	# Destroy object
	self.queue_free()
