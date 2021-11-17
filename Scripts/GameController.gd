extends Spatial

var paused := false
var game_over := false

export var pause_menu_path = "res://Scenes/PauseMenu.tscn"
var pause_menu

export var game_over_menu_path = "res://Scenes/GameOverMenu.tscn"
var game_over_menu

var waves := []
var wave_index = 0
var wave_kills = 0

var spawn_positions = []

enum Types { PET, PVC, PEBD, PEAD, PP, PS }

# Called when the node enters the scene tree for the first time.


func _ready():
	for file in get_dir_contents("res://Scenes/Waves/")[0]:
		if file == "res://Scenes/Waves/AbstractWave.tscn":
			continue
		
		waves.append(load(file).instance())
		
	pause_menu = load(pause_menu_path).instance()
	game_over_menu = load(game_over_menu_path).instance()
	for position in $SpawnPositions.get_children():
		spawn_positions.append(position)
		
	spawn_wave()
	
func set_player_to_enemies() -> void:
	get_tree().call_group("zombies", "set_player", $Player)

func spawn_wave():
	var wave = waves[wave_index]
	var enemy : Resource
	
	for i in wave.PET:
		enemy = load("res://Scenes/PETZombie.tscn")
		spawn_enemy(enemy)
		
	for i in wave.PVC:
		enemy = load("res://Scenes/PVCZombie.tscn")
		spawn_enemy(enemy)
		
	for i in wave.PEBD:
		enemy = load("res://Scenes/PEBDZombie.tscn")
		spawn_enemy(enemy)
		
	for i in wave.PEAD:
		enemy = load("res://Scenes/PEADZombie.tscn")
		spawn_enemy(enemy)
		
	for i in wave.PP:
		spawn_enemy(enemy)
		
	for i in wave.PS:
		spawn_enemy(enemy)
		
	set_player_to_enemies()

func spawn_enemy(enemy : Resource):
	randomize()
	
	
	var i = randi() % spawn_positions.size()
	
	var instance : KinematicBody = enemy.instance()
	var target_pos = spawn_positions[i].translation
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	instance.translation = target_pos + Vector3(rng.randf_range(-10, 10), 0, rng.randf_range(-10, 10))
	$Enemies.add_child(instance)

func _process(delta):
	if Input.is_action_just_pressed("pause") && !paused:
		pause()
		
func game_over() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	add_child(game_over_menu)
	get_tree().paused = true

func pause() -> void:
	paused = true
	get_tree().get_nodes_in_group("gun")[0].get_node("CenterContainer/Crosshair").visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	add_child(pause_menu)
	get_tree().paused = true
		
func resume() -> void:
	paused = false
	get_tree().get_nodes_in_group("gun")[0].get_node("CenterContainer/Crosshair").visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	remove_child(pause_menu)

func get_dir_contents(rootPath: String) -> Array:
	var files = []
	var directories = []
	var dir = Directory.new()

	if dir.open(rootPath) == OK:
		dir.list_dir_begin(true, false)
		_add_dir_contents(dir, files, directories)
	else:
		push_error("An error occurred when trying to access the path.")

	return [files, directories]
	
func _add_dir_contents(dir: Directory, files: Array, directories: Array):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			print("Found directory: %s" % path)
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		else:
			print("Found file: %s" % path)
			files.append(path)

		file_name = dir.get_next()

	dir.list_dir_end()

func on_enemy_killed() -> void:
	wave_kills += 1
	
	if wave_kills >= waves[wave_index].get_enemy_amount():
		next_wave()
		
func next_wave() -> void:
	wave_index += 1
	spawn_wave()
