extends Node

@onready var current_scene = $CompanyIcon
@onready var current_scene_path : String = "res://scenes/ui/start/company_icon.tscn"

func _ready() -> void:
	var folder_path = "user://savegames/"
	
	if not DirAccess.dir_exists_absolute(folder_path):
		var error = DirAccess.make_dir_absolute(folder_path)
		
		if error == OK:
			print("Folder was created successfully.")
		else:
			print("Error by creating folder. Errorcode:", error)
	else:
		print("Folder already exists.")

func change_scene_fluid(next_scene_path: String, reverse: bool = false, variable1 : String = "", variable2 : String = ""):
	# 1. Neue Szene laden und instanziieren
	var next_scene_resource = load(next_scene_path)
	var next_scene = next_scene_resource.instantiate()
	
	# Neue Szene als Kind zum Manager hinzufügen
	add_child(next_scene)
	
	if variable1 != "":
		if "variable1" in next_scene:
			next_scene.variable1 = variable1
		
	if variable2 != "":
		if "variable2" in next_scene:
			next_scene.variable2 = variable2
			
	if next_scene.has_method("setup_scene"):
		next_scene.setup_scene()
	
	# Bildschirmbreite ermitteln
	var screen_width = get_viewport().get_visible_rect().size.x
	
	var start_pos_next: float
	var target_pos_current: float
	
	if reverse:
		# Für Wisch nach RECHTS (z.B. Zurück-Button):
		start_pos_next = -screen_width    # Neue Szene startet links draußen
		target_pos_current = screen_width # Alte Szene fliegt nach rechts raus
	else:
		# Für Wisch nach LINKS (Standard):
		start_pos_next = screen_width     # Neue Szene startet rechts draußen
		target_pos_current = -screen_width # Alte Szene fliegt nach links raus
	
	# 2. Die neue Szene rechts außerhalb des sichtbaren Bereichs platzieren
	next_scene.position.x = start_pos_next
	
	# 3. Beide Szenen gleichzeitig per Tween nach links verschieben
	var tween = create_tween().set_parallel(true) # Aktiviert simultane Animationen
	
	# Alte Szene schiebt nach links raus
	tween.tween_property(current_scene, "position:x", target_pos_current, 1.0)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	# Neue Szene schiebt von rechts rein
	tween.tween_property(next_scene, "position:x", 0, 1.0)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	# 4. Nach dem Wisch: Alte Szene aufräumen
	tween.chain().tween_callback(func():
		current_scene.queue_free()
		current_scene = next_scene # Die neue Szene ist jetzt die aktuelle
		current_scene_path = next_scene_path
	)

func change_scene_fade(next_scene_path : String, variable1 : String = "", variable2 : String = ""):
	var next_scene_resource = load(next_scene_path)
	var next_scene = next_scene_resource.instantiate()
	
	add_child(next_scene)
	
	if variable1 != "":
		if "variable1" in next_scene:
			next_scene.variable1 = variable1
		
	if variable2 != "":
		if "variable2" in next_scene:
			next_scene.variable2 = variable2
			
	if next_scene.has_method("setup_scene"):
		next_scene.setup_scene()
	
	next_scene.modulate.a = 0.0
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(current_scene, "modulate:a", 0.0, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(tween.EASE_IN_OUT)
		
	tween.tween_property(next_scene, "modulate:a", 1.0, 0.5)\
	.set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.chain().tween_callback(func():
		current_scene.queue_free()
		current_scene = next_scene
		current_scene_path = next_scene_path
	)

func change_scene_fade_black(next_scene_path : String, black_time : float = 0.0, variable1 : String = "", variable2 : String = ""):
	var next_scene_resource = load(next_scene_path)
	var next_scene = next_scene_resource.instantiate()
	
	add_child(next_scene)
	
	var black_scene_resource = load("res://scenes/ui/blackscreen.tscn")
	var black_scene = black_scene_resource.instantiate()
	
	add_child(black_scene)
	
	if variable1 != "":
		if "variable1" in next_scene:
			next_scene.variable1 = variable1
		
	if variable2 != "":
		if "variable2" in next_scene:
			next_scene.variable2 = variable2
			
	if next_scene.has_method("setup_scene"):
		next_scene.setup_scene()
	
	next_scene.modulate.a = 0.0
	
	black_scene.modulate.a = 0.0
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(current_scene, "modulate:a", 0.0, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(black_scene, "modulate:a", 1.0, 0.5)\
	.set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.chain().tween_callback(func():
		current_scene.queue_free()
		current_scene = black_scene
		current_scene_path = next_scene_path
	)
	
	tween.tween_interval(black_time)
	
	tween.set_parallel(true)
	
	tween.tween_property(current_scene, "modulate:a", 0.0, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(next_scene, "modulate:a", 1.0, 0.5)\
	.set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.chain().tween_callback(func():
		current_scene.queue_free()
		current_scene = next_scene
		current_scene_path = next_scene_path
	)

func _process(_delta:float) -> void:
	if current_scene_path.begins_with("res://scenes/ui/start/") or current_scene.scene_file_path == "res://scenes/ui/blackscreen.tscn":
		if not $TitleMusic.playing:
			$TitleMusic.play()
	else:
		$TitleMusic.stop()
