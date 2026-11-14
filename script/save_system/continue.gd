extends Control

@onready var savegame : String
@onready var username : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	savegame = SaveLoad.load_which_savegame()
	print("Current savegame: " + savegame)
	var loading_string = "Loading " + savegame + " savegame"
	$Loading___.text = loading_string
	check_load()
	var your_name_string = "Your Name:
		" + username
	$YourName.text = your_name_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_load() -> void:
	var error = SaveLoad.load(savegame)
	if error is String:
		print("Succesfully loaded username from savegame.")
		username = error
	else:
		print("Error loading username from savegame. Errorcode:" , error)
		username = "Error"
