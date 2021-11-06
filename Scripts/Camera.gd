extends Camera
class_name FPCamera

var shake_force: float = 0
var shake_delta: float = 15

func _process(delta: float) -> void:
	h_offset = rand_range(-shake_force, shake_force)
	v_offset = rand_range(-shake_force, shake_force)
	
	shake_force = lerp(shake_force, 0, shake_delta * delta)

func shake(force: float) -> void:
	shake_force = max(shake_force, force)
