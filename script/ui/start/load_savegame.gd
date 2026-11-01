extends Control

@onready var savegame_list: ItemList = $ItemList
@onready var load_button: Button = $Button

const SAVE_FOLDER = "user://savegames/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_savegame_list()
	
	load_button.disabled = true
	
	savegame_list.item_selected.connect(_on_save_item_selected)
	load_button.pressed.connect(_on_load_button_pressed)

func get_save_files() -> Array:
	var files: Array = []
	var dir = DirAccess.open(SAVE_FOLDER)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".res"):
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return files


# Befüllt die UI-Liste mit den Dateinamen
func populate_savegame_list() -> void:
	savegame_list.clear()
	var saves = get_save_files()
	
	for save_name in saves:
		# Fügt den Namen der Datei zur Liste hinzu
		savegame_list.add_item(save_name)


# Wird aufgerufen, wenn der Spieler auf einen Eintrag in der Liste klickt
func _on_save_item_selected(index: int) -> void:
	# Aktiviert den Laden-Button, da eine Auswahl existiert
	load_button.disabled = false


# Wird aufgerufen, wenn der Spieler auf "Spiel laden" drückt
func _on_load_button_pressed() -> void:
	# Holt die Spalten-ID des aktuell ausgewählten Elements
	var selected_indexes = savegame_list.get_selected_items()
	
	if selected_indexes.size() > 0:
		var selected_index = selected_indexes[0]
		# Holt den Text (Dateinamen) des ausgewählten Elements
		var selected_file_name = savegame_list.get_item_text(selected_index)
		
		# Der vollständige Pfad zur Datei
		var full_path = SAVE_FOLDER + selected_file_name
		
		# Starte den Ladevorgang
		load_savegame(full_path)


# Hier verarbeitest du die ausgewählte Datei
func load_savegame(path: String) -> void:
	print("Lade Speicherstand von: ", path)
	
	# Beispiel, wenn du deine Speicherstände als Resource (.tres) speicherst:
	var save_data = ResourceLoader.load(path)
	if save_data:
		# Hier übergibst du die Daten an dein Spiel (z.B. an einen Autoload/Singleton)
		# GameManager.current_save = save_data
		# get_tree().change_scene_to_file("res://world.tscn")
		pass
