extends Control

@onready var player_name = $Name

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		back()

func _on_submit_pressed() -> void:
	if player_name.text != "":
		var choosen_name = player_name.text
		SaveLoad.save(choosen_name, choosen_name)
		next_page(choosen_name)
		
func next_page(choosen_name) -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/username_control.tscn", false, choosen_name)


func _on_back_pressed() -> void:
	back()

func back() -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/play_menu.tscn", true)
