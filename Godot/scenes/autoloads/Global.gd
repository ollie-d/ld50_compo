extends Node

var score_file = "user://highscore.save"
var highscore
var score
var show_instructions = false
var asteroids_killed := 0

func load_score():
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		highscore = f.get_var()
		f.close()
	else:
		highscore = 0

func save_score():
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_var(highscore)
	f.close()

func _ready():
	print('Loaded score')
	load_score()
	
func asteroid_killed():
	asteroids_killed = asteroids_killed + 1
