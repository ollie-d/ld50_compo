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

# Asteroid spawn rates (increase with score/time)
var asteroid_rates = [0.5, 0.4, 0.3, 0.2, 0.1]

var rng = RandomNumberGenerator.new()

var score := 0

var game_over := false

func _ready():
	randomize()
	
	# Have all lasers point at their corresponding corners
	$Lasers/NW_Laser.point_at(0, 0)
	$Lasers/NE_Laser.point_at(MAX_W, 0)
	$Lasers/SW_Laser.point_at(0, MAX_H)
	$Lasers/SE_Laser.point_at(MAX_W, MAX_H)
	
	# Select laser 0 (NW) by default
	select_laser(0)

	# Start score timer
	$Score_Timer.start()
	
	# Set spawn timer to easiest
	$Spawn_Timer.wait_time = asteroid_rates[0]
	
	

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
	for l in $Lasers.get_children():
		l.select(false)
	
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
	if not game_over:
		# Update score
		$HBox0/Score.text = "Score: {s}".format({"s":score})
		
		# Update timer rates based on score
		var timer = 0.1
		if score <= 100:
			timer = asteroid_rates[0]
		elif score > 100 and score <= 200:
			timer = asteroid_rates[1]
		elif score > 200 and score <= 300:
			timer = asteroid_rates[2]
		elif score > 300 and score <= 400:
			timer = asteroid_rates[3]
		else:
			timer = asteroid_rates[4]
		
		$Spawn_Timer.wait_time = timer
		
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
	$Asteroids.add_child(asteroid)
	asteroid.position = spawn_location.position
	#print(spawn_location.position)
	#print(asteroid.position)
	#asteroid.move_and_collide(velocity.rotated(direction))
	
	num_asteroids_spawned = num_asteroids_spawned + 1


func _on_Planet_game_over():
	# Save high score if we beat our previous
	Global.score = score
	if score > Global.highscore:
		Global.highscore = score
		Global.save_score()
	
	# Get to end screen
	var end = load("res://scenes/end.tscn")
	get_parent().add_child(end.instance())
	queue_free()


func _on_Planet_planet_hit():
	game_over = true
	$Spawn_Timer.stop()
	$Score_Timer.stop()
	
	# Kill all lasers
	for l in $Lasers.get_children():
		l.kill()
		$Lasers.remove_child(l)
		l.remove()
		
	# Destroy all asteroids
	for a in $Asteroids.get_children():
		#$Asteroid.remove_child(a)
		a.destroy()


func _on_Score_Timer_timeout():
	score = score + 1
	Global.score = score


func _on_NW_Laser_laser_death():
	$CanvasLayer/L1.visible = false
	#$Lasers.remove_child($Lasers/NW_Laser)


func _on_NE_Laser_laser_death():
	$CanvasLayer/L2.visible = false
	#$Lasers.remove_child($Lasers/NE_Laser)


func _on_SW_Laser_laser_death():
	$CanvasLayer/L3.visible = false
	#$Lasers.remove_child($Lasers/SW_Laser)


func _on_SE_Laser_laser_death():
	$CanvasLayer/L4.visible = false
	#$Lasers.remove_child($Lasers/SE_Laser)
