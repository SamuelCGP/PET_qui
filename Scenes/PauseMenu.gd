extends Control

func _on_PlayButton_button_down():
	get_tree().paused = false
	get_tree().get_nodes_in_group("controller")[0].resume()

func _on_OptionsButton_button_down():
	pass # Replace with function body.

func _on_QuitButton_button_down():
	get_tree().quit()
