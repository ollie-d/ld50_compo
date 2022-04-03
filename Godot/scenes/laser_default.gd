extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const COOLDOWN_TIME := 5.0 # second(s)
const FIRE_TIME := 0.3   # second(s); length of effect 
const SM := 0.3 # smoothing factor for laser following mouse

var selected := false
var alive := true
var firing := false
var cooling_down := false
var can_fire := true

var smoothed_mouse_pos: Vector2

var explosion_frame := -1
var max_frame := 52
var is_exploding := false

var animation_dt := 0.03
var delta_sum := 0.0

signal laser_death

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set timer times (both oneshots)
	rng = RandomNumberGenerator.new()
	rng.randomize()
	randomize()
	$Fire_Timer.wait_time = FIRE_TIME
	$Cooldown_Timer.wait_time = COOLDOWN_TIME


func point_at(x, y):
	look_at(Vector2(x, y))


func fire():
	# Fire yer laser
	if not cooling_down and not firing:
		# Play random laser sound
		if not MusicController.muted:
			$sfx.get_child(rng.randi_range(0, 1)).play()
		
		$Sprite.frame = 1
		$Beam.disabled = false
		firing = true
		cooling_down = false
		can_fire = false
		#$Sprite/Beam.visible = true
		$Fire_Timer.start()
	
	
func cooldown():
	# Time to recharge
	$Sprite.modulate = Color(1, 0, 0, 1)
	$Sprite.frame = 0
	$Beam.disabled = true
	firing = false
	cooling_down = true
	can_fire = false
	#$Sprite/Beam.visible = false
	$Cooldown_Timer.start()
	

func destroy(body):
	# Send destruction signal to affected asteroids
	body.destroy()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_sum += delta
	if alive:
		smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), SM)
		if selected:
			#look_at(get_global_mouse_position())
			look_at(smoothed_mouse_pos)
			
			# Check for the fire input in order to shoot beam
			if Input.is_action_pressed("ui_accept"):
				fire()
	else:
		if delta_sum >= animation_dt:
			delta_sum = 0
			explosion_frame = explosion_frame + 1
			if explosion_frame <= max_frame:
				$Explosion.frame = explosion_frame
			else:
				self.visible = false
				is_exploding = false


func _on_Fire_Timer_timeout():
	cooldown()


func select(tf):
	if alive:
		if tf:
			selected = true
			$Selected.visible = true
		else:
			selected = false
			$Selected.visible = false
	return alive


func kill():
	alive = false
	is_exploding = true
	$Explosion.visible = true
	$Sprite.visible = false
	$Selected.visible = false
	$Beam.set_deferred("disabled", true)
	$Area2D/Body.set_deferred("disabled", true)
	
	# Tell main scene we've died
	emit_signal("laser_death")
	

func remove():
	self.queue_free()


func _on_Cooldown_Timer_timeout():
	$Sprite.modulate = Color(1, 1, 1, 1)
	can_fire = true
	cooling_down = false
	

func _on_Laser_body_entered(body):
	if "Asteroid" in body.get_name().substr(0, 10):
		destroy(body)


func _on_Area2D_body_entered(body):
	kill()
	if "Asteroid" in body.get_name().substr(0, 10):
		destroy(body)
	


func _on_Removal_Timer_timeout():
	self.queue_free()
