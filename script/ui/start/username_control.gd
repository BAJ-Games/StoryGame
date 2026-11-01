extends Control

@onready var player_name : String = "Default"
@onready var check_label : Label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_name = SaveLoad.load("test")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_name = SaveLoad.load("test")
	check_label.text = player_name
