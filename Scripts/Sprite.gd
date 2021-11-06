extends Sprite
tool

func _process(delta: float) -> void:
	if !Engine.editor_hint:
		rotation_degrees += 10
