extends VBoxContainer
var outline : ColorRect


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
	if outline:
		outline.visible = false
	
	match current_gun_type:
		GunController.Types.PET:
			outline = $PET/ColorRect
			
		GunController.Types.PVC:
			outline = $PVC/ColorRect
		
	outline.visible = true
