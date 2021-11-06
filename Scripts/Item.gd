extends Area
class_name Item

onready var pick_sound: AudioStreamPlayer = $pick

func _on_Item_body_entered(body: Node) -> void:
	if body != null and body.name == "Player":
		event(body)	
		
func event(_player: Player) -> void:
	pick_sound.play()
	hide()
	
func _on_pick_finished() -> void:
	queue_free()
