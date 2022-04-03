extends Node

# Allow instancing of asteroids
export(PackedScene) var asteroid_scene


# Window size variables
const MAX_W = 480 # px
const MAX_H = 270 # px

# Count asteroids
var num_asteroids_spawned := 0

# Hold selected laser in a 'reference' variable
onready var selected_laser := get_node("Lasers/NW_Laser")


var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	
	# Have all lasers point at their corresponding corners
	$Lasers/NW_Laser.point_at(0, 0)
	$Lasers/NE_Laser.point_at(MAX_W, 0)
	$Lasers/SW_Laser.point_at(0, MAX_H)
	$Lasers/SE_Laser.point_at(MAX_W, MAX_H)
	
	# Select laser 0 (NW) by default
	select_laser(0)
	
	# Stall asteroid
	$Asteroid.init(Vector2(0, 0))
	
	

func select_laser(x):
	# Simple function for selecting laser
	# 0: NW
	# 1: NE
	# 2: SW
	# 3: SE
	
	var last_laser = selected_laser

	if typeof(x) != TYPE_INT:
		push_error("Int expected for selecting lasers.")
	if x < 0 or x > 3:
		push_error("Laser should be between 0 and 3 inclusive.")
		
	# Set all lasers to selected = false first
	$Lasers/NW_Laser.select(false)
	$Lasers/NE_Laser.select(false)
	$Lasers/SW_Laser.select(false)
	$Lasers/SE_Laser.select(false)
	
	# Now handle selecting the correct laser
	if x == 0:
		if $Lasers/NW_Laser.alive:
			selected_laser = get_node("Lasers/NW_Laser")
		else:
			selected_laser = last_laser
	elif x == 1:
		if $Lasers/NE_Laser.alive:
			selected_laser = get_node("Lasers/NE_Laser")
		else:
			selected_laser = last_laser
	elif x == 2:
		if $Lasers/SW_Laser.alive:
			selected_laser = get_node("Lasers/SW_Laser")
		else:
			selected_laser = last_laser
	elif x == 3:
		if $Lasers/SE_Laser.alive:
			selected_laser = get_node("Lasers/SE_Laser")
		else:
			selected_laser = last_laser

	# Make the final selection
	selected_laser.select(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle laser selection
	if Input.is_action_just_pressed("ui_up"):
		# 1 key on keyboard
		select_laser(0)
	elif Input.is_action_just_pressed("ui_down"):
		# 2 key on keyboard
		select_laser(1)
	elif Input.is_action_just_pressed("ui_left"):
		# 3 key on keyboard
		select_laser(2)
	elif Input.is_action_just_pressed("ui_right"):
		# 4 key on keyboard
		select_laser(3)
	
	# Handle asteroid spawning
	


func _on_Spawn_Timer_timeout():
	var asteroid = asteroid_scene.instance()

	# Choose a random location on Path2D.
	var spawn_location = get_node("Spawner/Loc")
	spawn_location.offset = randi()

	var vel := Vector2(15, 15) # init to 15 15 in case something goes wrong
	if spawn_location.position.x < 0 and spawn_location.position.y < 0:
		vel = Vector2(rng.randf_range(1.0, 20.0), rng.randf_range(1.0, 20.0))
	elif spawn_location.position.x < 0 and spawn_location.position.y > MAX_H:
		vel = Vector2(rng.randf_range(1.0, 20.0), rng.randf_range(-20.0, -1.0))
	elif spawn_location.position.x > MAX_W and spawn_location.position.y > MAX_H:
		vel = Vector2(rng.randf_range(-20.0, -1.0), rng.randf_range(-20.0, -1.0))
	elif spawn_location.position.x > MAX_W and spawn_location.position.y < 0:
		vel = Vector2(rng.randf_range(-20.0, -1.0), rng.randf_range(1.0, 20.0))
	else:
		vel = Vector2(rng.randf_range(-20.0, 20.0), rng.randf_range(-20.0, 20.0))
	
	asteroid.init(vel)
	add_child(asteroid)
	asteroid.position = spawn_location.position
	#print(spawn_location.position)
	#print(asteroid.position)
	#asteroid.move_and_collide(velocity.rotated(direction))
	
	num_asteroids_spawned = num_asteroids_spawned + 1
	
	
