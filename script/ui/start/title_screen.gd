extends Control

@onready var progress_bar = $TextureRect/ProgressBar

var duration : float = 6.0
var elapsed : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += delta
	
	progress_bar.value = (elapsed / duration) * 100.0
	
	if elapsed >= duration:
		progress_bar.value = 100.0
		get_parent().change_scene_fade("res://scenes/ui/start/start_menu.tscn")
