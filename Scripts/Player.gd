extends KinematicBody
class_name Player

const MOVE_SPEED: float = 4.0
const MOUSE_SENS: float = 0.25

var hp: int = 20
var cur_speed: int = MOVE_SPEED
var move_vec: Vector3 = Vector3()

onready var audio_music: AudioStreamPlayer = $music
onready var audio_hit: AudioStreamPlayer = $rec_dmg
onready var audio_hp: AudioStreamPlayer = $rec_hp
onready var hp_bar: ProgressBar = $VBoxContainer/hp_bar
onready var gun_controller: GunController = $GunController as GunController

onready var max_hp: int = hp_bar.value

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)

	update_hud()
	
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	if event is InputEventMouseMotion:
		rotation_degrees.x -= MOUSE_SENS * event.relative.y
		rotation_degrees.x = clamp(rotation_degrees.x, -45, 90)
		
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		
func _physics_process(_delta: float):
	var input_z: float = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_fowards")
	var input_x: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	move_vec = Vector3(input_x, 0, input_z)
	
	var running_delta := int(Input.is_action_pressed("sprint")) * MOVE_SPEED
	cur_speed = MOVE_SPEED + (running_delta)
	
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec = move_and_slide(move_vec * cur_speed, Vector3.UP, true)
	
	if Input.is_action_just_released("nextGun"): gun_controller.next_gun()
	if Input.is_action_just_released("previousGun"): gun_controller.previous_gun()

func kill() -> void:
	var controller = get_tree().get_nodes_in_group("controller")[0]
	if !controller.game_over:
		controller.game_over()

func rec_hp(h: int) -> void:
	hp = hp + h
	
	if hp >= max_hp:
		hp = max_hp
		
	audio_hp.play()
	update_hud()
	
func rec_dmg(dmg):
	hp = hp - dmg
	audio_hit.play()
	update_hud()

func update_hud():
	hp_bar.value = hp
