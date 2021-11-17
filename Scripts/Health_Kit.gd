extends Item
class_name HealthKit

export var hp_recovery: int = 20
var rotate_speed: float = 100.0
var ghost = false
var medkit_scene : PackedScene = load("res://Scenes/Health_Kit.tscn")
var ghost_scene : PackedScene= load("res://Scenes/Ghost_Health_Kit.tscn")
var positionSin: float = 0
var startPosition: Vector3

var translation_speed := 2
var translation_amplitude := .2

onready var medkit: MeshInstance = $medkit

func _ready() -> void:
	startPosition = translation

func event(player: Player) -> void:
	if ghost: return
	if !player.hp >= player.hp_bar.max_value:
		player.rec_hp(hp_recovery)
		pick_sound.play()
		spawn(ghost_scene)
		hide()
		
func spawn(scene):
	var instance : Area = scene.instance()
	instance.translation = translation
	instance.rotation_degrees = rotation_degrees
	if !ghost:
		instance.ghost = true
	get_parent().add_child(instance)

func _process(delta: float) -> void:
	medkit.rotate_y(deg2rad(rotate_speed) * delta)
	
	positionSin += translation_speed * delta
	translation.y = startPosition.y - (sin(positionSin) * translation_amplitude)

func _on_Timer_timeout() -> void:
	spawn(medkit_scene)
	queue_free()
