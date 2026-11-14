extends Control

@onready var variable1 : String = "Name"
@onready var check_label : Label = $Label
@onready var username : String = "Default"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func setup_scene():
	check_load()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	check_label.text = username
	
func check_load():
	var error = SaveLoad.load(variable1)
	if error is String:
		print("Succesfully loaded username from savegame.")
		username = error
	else:
		print("Error loading username from savegame. Errorcode:" , error)
		username = "Error"


func _on_yes_pressed() -> void:
	var scene_path = self.scene_file_path
	SaveLoad.save_which_savegame(scene_path)


func _on_no_pressed() -> void:
	get_parent().change_scene_fluid("res://scenes/ui/start/game_start.tscn", true)
