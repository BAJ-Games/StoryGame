extends Control

@onready var player_name = $Name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_submit_pressed() -> void:
	if player_name.text != "":
		var choosen_name = player_name.text
