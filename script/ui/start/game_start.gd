extends Control

@onready var player_name = $Name


func _on_submit_pressed() -> void:
	if player_name.text != "":
		var choosen_name = player_name.text
		SaveLoad.save(choosen_name, choosen_name)
		next_page(choosen_name)
		
func next_page(choosen_name) -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/username_control.tscn", false, choosen_name)
