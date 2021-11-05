extends KinematicBody
class_name Player

const MOVE_SPEED = 4
const MOUSE_SENS = 0.5

onready var audio_music: AudioStreamPlayer = $music
onready var audio_hit: AudioStreamPlayer = $hit
onready var hp_bar: ProgressBar = $CanvasLayer/VBoxContainer/hp_bar

var hp: int = 20
var cur_speed: int = MOVE_SPEED

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()
		
func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("move_fowards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("sprint"):
		cur_speed = MOVE_SPEED * 2
	if Input.is_action_just_released("sprint"):
		cur_speed = MOVE_SPEED
		
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * cur_speed * delta)

func rec_damage(dmg):
	hp = hp - dmg
	audio_hit.play()
	update_hud()
	
func kill():
	get_tree().reload_current_scene()

func update_hud():
	hp_bar.value = hp
