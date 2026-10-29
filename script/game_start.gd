extends Control

@onready var player_name = $Name


func _on_submit_pressed() -> void:
	if player_name.text != "":
		var choosen_name = player_name.text
		SaveLoad.save(choosen_name, "test")
		next_page()
		
func next_page() -> void:
	get_parent().change_scene_fluid("res://scenes/username_control.tscn")
