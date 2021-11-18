extends VBoxContainer
onready var texture : TextureRect = $PET/Texture
var color : Color = Color("#ffffff")

func _on_GunController_gun_changed(current_gun_type):
	if texture:
		texture.modulate = Color("#ffffff")
	
	match current_gun_type:
		Enums.Types.PET:
			texture = $PET/Texture
			color = Color("#ff0000")
			
		Enums.Types.PEAD:
			texture = $PEAD/Texture
			color = Color("#ff8900")
			
		Enums.Types.PVC:
			texture = $PVC/Texture
			color = Color("#ffe900")
			
		Enums.Types.PEBD:
			texture = $PEBD/Texture
			color = Color("#14ff00")
		
	texture.modulate = Color(color)
