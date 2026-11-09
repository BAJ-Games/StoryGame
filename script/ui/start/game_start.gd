extends Control

@onready var player_name = $Name
@onready var exists_node : Control = $Exists

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		back()

func _on_submit_pressed() -> void:
	save_logic()
		
func next_page(choosen_name) -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/username_control.tscn", false, choosen_name)


func _on_back_pressed() -> void:
	back()

func back() -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/play_menu.tscn", true)


func _on_no_pressed() -> void:
	exists_node.hide()


func _on_yes_pressed() -> void:
	save_logic(true)
	
func save_logic(replace : bool = false) -> void:
	if player_name.text != "":
		var choosen_name = player_name.text
		var exists = SaveLoad.save(choosen_name, choosen_name, true, replace)
		if exists:
			print("Savegame with that username already exists")
			exists_node.show()
		else:
			next_page(choosen_name)
