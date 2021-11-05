extends Item

onready var medkit: MeshInstance = $medkit

export var hp_recovery: int = 5

func event(player: Player) -> void:
	if !player.hp >= 20:
		player.rec_hp(hp_recovery)
		pick_sound.play()
		hide()

func _process(delta):
	medkit.rotate_y(deg2rad(5.0))
