extends Node2D

# Window size variables
const MAX_W = 480 # px
const MAX_H = 270 # px

# Hold selected laser in a 'reference' variable
onready var selected_laser := get_node("Lasers/NW_Laser")


func _ready():
	# Have all lasers point at their corresponding corners
	$Lasers/NW_Laser.point_at(0, 0)
	$Lasers/NE_Laser.point_at(MAX_W, 0)
	$Lasers/SW_Laser.point_at(0, MAX_H)
	$Lasers/SE_Laser.point_at(MAX_W, MAX_H)
	
	# Select laser 0 (NW) by default
	select_laser(0)
	

func select_laser(x):
	# Simple function for selecting laser
	# 0: NW
	# 1: NE
	# 2: SW
	# 3: SE
	
	if typeof(x) != TYPE_INT:
		push_error("Int expected for selecting lasers.")
	if x < 0 or x > 3:
		push_error("Laser should be between 0 and 3 inclusive.")
		
	# Set all lasers to selected == false first
	$Lasers/NW_Laser.selected = false
	$Lasers/NE_Laser.selected = false
	$Lasers/SW_Laser.selected = false
	$Lasers/SE_Laser.selected = false
	
	# Now handle selecting the correct laser
	if x == 0:
		$Lasers/NW_Laser.selected = true
		selected_laser = get_node("Lasers/NW_Laser")
	elif x == 1:
		$Lasers/NE_Laser.selected = true
		selected_laser = get_node("Lasers/NE_Laser")
	elif x == 2:
		$Lasers/SW_Laser.selected = true
		selected_laser = get_node("Lasers/SW_Laser")
	elif x == 3:
		$Lasers/SE_Laser.selected = true
		selected_laser = get_node("Lasers/SE_Laser")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
