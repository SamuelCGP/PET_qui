extends VBoxContainer
onready var outline : ColorRect = $PET/ColorRect

func _on_GunController_gun_changed(current_gun_type):
	if outline:
		outline.visible = false
	
	match current_gun_type:
		Enums.Types.PET:
			outline = $PET/ColorRect
			
		Enums.Types.PEAD:
			outline = $PEAD/ColorRect
			
		Enums.Types.PVC:
			outline = $PVC/ColorRect
			
		Enums.Types.PEBD:
			outline = $PEBD/ColorRect
		
	outline.visible = true
