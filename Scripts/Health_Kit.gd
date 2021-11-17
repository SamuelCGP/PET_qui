extends Item
class_name HealthKit

export var hp_recovery: int = 20
var rotate_speed: float = 100.0

onready var medkit: MeshInstance = $medkit

func event(player: Player) -> void:
	if !player.hp >= player.hp_bar.max_value:
		player.rec_hp(hp_recovery)
		pick_sound.play()
		hide()

func _process(delta: float) -> void:
	medkit.rotate_y(deg2rad(rotate_speed) * delta)
