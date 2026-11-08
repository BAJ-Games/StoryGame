extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Start Menu Ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print("Cancel")
		quit()


func _on_quit_pressed() -> void:
	print("Cancel")
	quit()

func quit() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/play_menu.tscn")


func _on_load_pressed() -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/load_savegame.tscn")
