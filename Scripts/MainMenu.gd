extends Control



func _on_PlayButton_button_down():
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_OptionsButton_button_down():
	pass # Replace with function body.


func _on_QuitButton_button_down():
	get_tree().quit()
