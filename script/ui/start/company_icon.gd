extends Control

var duration : float = 3.0
var elapsed : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += delta
	
	if elapsed >= duration:
		get_parent().change_scene_fade_black("res://scenes/ui/start/title_screen.tscn", 2.0)
