extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Start Menu Ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		print("Cancel")
		quit()


func _on_quit_pressed() -> void:
	print("Cancel")
	quit()

func quit() -> void:
	get_tree().quit()
