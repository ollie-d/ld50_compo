extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const COOLDOWN_TIME := 5.0 # second(s)
const FIRE_TIME := 0.3   # second(s); length of effect 
const SM := 0.3 # smoothing factor for laser following mouse

var selected := false
var firing := false
var cooling_down := false
var can_fire := true

var smoothed_mouse_pos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set timer times (both oneshots)
	$Fire_Timer.wait_time = FIRE_TIME
	$Cooldown_Timer.wait_time = COOLDOWN_TIME


func point_at(x, y):
	look_at(Vector2(x, y))


func fire():
	# Fire yer laser
	if not cooling_down and not firing:
		$Sprite.frame = 1
		$Beam.disabled = false
		firing = true
		cooling_down = false
		can_fire = false
		$Fire_Timer.start()
	
	
func cooldown():
	# Time to recharge
	$Sprite.frame = 0
	$Beam.disabled = true
	firing = false
	cooling_down = true
	can_fire = false
	$Cooldown_Timer.start()
	

func destroy(body):
	# Send destruction signal to affected asteroids
	body.destroy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), SM)
	if selected:
		#look_at(get_global_mouse_position())
		look_at(smoothed_mouse_pos)
		
		# Check for the fire input in order to shoot beam
		if Input.is_action_pressed("ui_accept"):
			fire()


func _on_Fire_Timer_timeout():
	print('On fire timedout')
	cooldown()


func _on_Cooldown_Timer_timeout():
	can_fire = true
	cooling_down = false


func _on_Laser_body_entered(body):
	if body.get_name() == "KinematicBody2D":
		destroy(body)
