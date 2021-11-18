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
var waves_survived = 0
var enemies_left := 0
var tutorial_skipped = false

var spawn_positions = []
var countdown_seconds : int = -1
export var countdown_duration : int = 6

signal countdown_over

func _input(event : InputEvent) -> void:
	if tutorial_skipped: return
	
	if event is InputEventKey:
		if event.pressed:
			on_skip_tutorial()

func _ready():
	pass
	
func on_skip_tutorial() -> void:
	tutorial_skipped = true
	$Tutorial.queue_free()
	
	for file in get_dir_contents("res://Scenes/Waves/")[0]:
		if file == "res://Scenes/Waves/AbstractWave.tscn":
			continue
		
		waves.append(load(file).instance())
		
	pause_menu = load(pause_menu_path).instance()
	game_over_menu = load(game_over_menu_path).instance()
	for position in $SpawnPositions.get_children():
		spawn_positions.append(position)
		
	show_wave_name()
	
func set_player_to_enemies() -> void:
	get_tree().call_group("zombies", "set_player", $Player)


func spawn_wave():
	if wave_index > waves.size() - 1: wave_index = 0
	
	var wave = waves[wave_index]
	$Player/WaveProgress.max_value = waves[wave_index].get_enemy_amount()
	
	var enemy : Resource
	for key in wave.types:
		var amount = wave.get(key)
		if amount > 0:
			enemy = load("res://Scenes/" + key + "Zombie.tscn")
		else:
			continue
		
		for i in amount:
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
	
func countdown():
	countdown_seconds = 0
	$WaveCountdown.start()
	$CountdownLabel.text = str(countdown_duration - 1)
	
func show_wave_name():
	$CountdownLabel.text = "WAVE " + str(wave_index + 1)
	$WaveName.start()

func update_wave_progress(new_value : int) -> void:
	var wave_progress : ProgressBar = $Player/WaveProgress
	var tween : Tween = $Player/WaveProgress/Tween
	tween.interpolate_property(wave_progress, "value", wave_progress.value, new_value, .2)
	tween.start()

func on_enemy_killed() -> void:
	wave_kills += 1
	
	update_wave_progress(wave_kills)
	if wave_kills >= waves[wave_index].get_enemy_amount():
		next_wave()
		
func next_wave() -> void:

	wave_kills = 0
	waves_survived += 1
	wave_index += 1
	update_wave_progress(0)
	
	if(wave_index >= waves.size()):
		end_game()
		end_game()
		return
	
	show_wave_name()
	
func end_game() -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	var win_screen : Control = load("res://Scenes/WinScreen.tscn").instance()
	add_child(win_screen)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().paused = true

func _on_WaveCountdown_timeout():
	countdown_seconds += 1
	
	if(countdown_seconds == countdown_duration):
		$CountdownLabel.text = ""
		spawn_wave()
		return
	elif(countdown_seconds == countdown_duration - 1):
		$CountdownLabel.text = "GO!"
	else:
		$CountdownLabel.text = str(countdown_duration - 1 - countdown_seconds)
		
	$WaveCountdown.start()

