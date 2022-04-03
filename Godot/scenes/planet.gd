extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal game_over
signal planet_hit

const CONTINENT_RESTART := 219 # x-coord for continent to be moved
const CONTINENT_WIDTH := 308 # px
const ROTATION_SPEED := 2 # number of pixels to move continents every timer tick

var max_frame := 58
var frame_count := -1


var planet_colors := ["#03045e", "#e0c3fc", "#a01a58", "#00b4d8", "#48cae4",
					  "#90e0ef", "#caf0f8", "#7b2cbf", "#c77dff", "#f4a261"]
					
var continent_colors := ["#7f5539", "#9d0208", "#718355", "#bb3e03", "#03071e",
						 "#ede0d4", "#ced4da", "#ffafcc", "#0a9396", "#ffaa00"]

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomize()
	
	$Planet.modulate = planet_colors[rng.randi_range(0, 9)]
	var cont_i = rng.randi_range(0, 9)
	$Continents0.modulate = continent_colors[cont_i]
	$Continents1.modulate = continent_colors[cont_i]
	
	# Determine a random axial tilt
	$Planet.rotate(rad2deg(rng.randf_range(-7.0, 7.0)))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func kill():
	if not MusicController.muted:
		$sfx.play()
	emit_signal("planet_hit")
	$Continents0.visible = false
	$Continents1.visible = false
	$Explosion.visible = true
	$Explosion_Timer.start()


func game_over():
	emit_signal("game_over")
	$Explosion_Timer.stop()
	$Explosion.visible = false

func destroy(body):
	# Send destruction signal to affected asteroids
	body.destroy()


func _on_Hitbox_body_entered(body):
	kill()
	if "Asteroid" in body.get_name().substr(0, 10):
		destroy(body)


func _on_Explosion_Timer_timeout():
	frame_count = frame_count + 1
	if frame_count >= max_frame:
		game_over()
	elif frame_count == 7:
		# This is when the explosion covers the planet so we can hide it
		$Planet.visible = false
		$Rotation_Timer.stop()
	else:
		$Explosion.frame = frame_count


func _on_Rotation_Timer_timeout():
	# Scroll continents
	$Continents0.position.x = $Continents0.position.x + ROTATION_SPEED
	$Continents1.position.x = $Continents1.position.x + ROTATION_SPEED
	
	if $Continents0.position.x >= CONTINENT_RESTART:
		$Continents0.position.x = $Continents1.position.x - CONTINENT_WIDTH
	if $Continents1.position.x >= CONTINENT_RESTART:
		$Continents1.position.x = $Continents0.position.x - CONTINENT_WIDTH
