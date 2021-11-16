extends Spatial

var paused := false
var game_over := false

export var pause_menu_path = "res://Scenes/PauseMenu.tscn"
var pause_menu

export var game_over_menu_path = "res://Scenes/GameOverMenu.tscn"
var game_over_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu = load(pause_menu_path).instance()
	game_over_menu = load(game_over_menu_path).instance()

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
