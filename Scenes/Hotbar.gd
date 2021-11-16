extends VBoxContainer
var texture : TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GunController_gun_changed(current_gun_type):
	
	if texture:
		texture.rect_scale = Vector2(.5, .5)
		
	match current_gun_type:
		GunController.Types.PET:
			texture = get_node("PET")
			
		GunController.Types.PVC:
			texture = get_node("PVC")
		
	$Tween.interpolate_property(texture, "rect:scale", texture.rect_scale, 1, .3, Tween.EASE_IN)
