extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		back()


func _on_back_pressed() -> void:
	back()

func back() -> void:
	get_parent().change_scene_fluid("res://scenes/start_menu.tscn", true)
