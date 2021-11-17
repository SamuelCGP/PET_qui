extends Control

func _on_QuitButton_button_down():
	get_tree().quit()

func _on_Retry_button_down():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/World.tscn")

