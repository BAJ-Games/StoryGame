extends Node

@onready var current_scene = $StartMenu

func change_scene_fluid(next_scene_path: String, reverse: bool = false):
	# 1. Neue Szene laden und instanziieren
	var next_scene_resource = load(next_scene_path)
	var next_scene = next_scene_resource.instantiate()
	
	# Neue Szene als Kind zum Manager hinzufügen
	add_child(next_scene)
	
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
	)
