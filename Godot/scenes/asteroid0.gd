extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity: Vector2

var explosion_frame := -1
var max_frame := 0

var explosion_type = 0

var is_exploding = false

var rotation_speed := 1

onready var explosion := get_node("Explosion0")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Determine explosion type
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomize()
	
	explosion_type = rng.randi_range(0, 1)
	if explosion_type == 0:
		max_frame = 42
		explosion = get_node("Explosion0")
	elif explosion_type == 1:
		max_frame = 30
		explosion = get_node("Explosion1")
		
	explosion.frame = 0
	
	rotation_speed = int(rng.randi_range(1, 2) * sign(rng.randf_range(-1, 1)))


func init(vec):
	# Initialize velocity vector
	velocity = vec

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#var c = move_and_collide(Vector2(1, 1) * delta)
	#if c:
#		pass


func _physics_process(delta):
	if not is_exploding:
		var c = move_and_collide(velocity * delta)
		if c:
			velocity = velocity.bounce(c.normal)
	else:
		explosion_frame = explosion_frame + 1
		if explosion_frame <= max_frame:
			explosion.frame = explosion_frame
		else:
			remove()


func _on_Rotation_Timer_timeout():
	self.rotate(deg2rad(rotation_speed))
	
	
func destroy():
	is_exploding = true
	$Sprite.visible = false
	$Body.call_deferred("set", "disabled", true)
	explosion.visible = true
	

func remove():
	self.visible = false
	self.queue_free()
	
	
func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


