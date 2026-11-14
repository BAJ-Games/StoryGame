extends GdUnitTestSuite

func test_username_scene_can_be_loaded():
	var scene = load("res://scenes/ui/start/username_control.tscn")
	
	assert_that(scene).is_not_null()

func test_username_scene_has_correct_root():
	var scene = load("res://scenes/ui/start/username_control.tscn")
	var username_control = scene.instantiate()

	assert_that(username_control).is_not_null()
	assert_that(username_control.name).is_equal("UsernameControl")

	username_control.free()

func test_scene_manager_starts_with_company_icon():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	assert_that(scene_manager.current_scene).is_not_null()
	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/company_icon.tscn"
	)

	scene_manager.free()
	
func test_scene_manager_can_change_scene_with_fade():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	scene_manager.change_scene_fade(
		"res://scenes/ui/start/username_control.tscn"
	)

	await get_tree().create_timer(0.7).timeout

	assert_that(scene_manager.current_scene).is_not_null()
	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/username_control.tscn"
	)

	scene_manager.free()

func test_scene_manager_can_change_scene_with_fluid():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	scene_manager.change_scene_fluid(
		"res://scenes/ui/start/username_control.tscn"
	)

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene).is_not_null()
	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/username_control.tscn"
	)

	scene_manager.free()

func test_scene_manager_can_change_scene_with_fade_black():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	scene_manager.change_scene_fade_black(
		"res://scenes/ui/start/username_control.tscn",
		0.2
	)

	await get_tree().create_timer(1.3).timeout

	assert_that(scene_manager.current_scene).is_not_null()
	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/username_control.tscn"
	)

	scene_manager.free()

func test_scene_manager_fluid_reverse_starts_on_left():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	scene_manager.change_scene_fluid(
		"res://scenes/ui/start/username_control.tscn",
		true
	)

	await get_tree().process_frame

	var next_scene = scene_manager.get_child(
		scene_manager.get_child_count() - 1
	)

	assert_that(next_scene.position.x < 0.0).is_true()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/username_control.tscn"
	)

	scene_manager.free()


func test_player_save_has_empty_name_by_default():
	var save = PlayerSave.new()

	assert_that(save).is_not_null()
	assert_that(save.name).is_equal("")

func test_player_save_can_store_name():
	var save = PlayerSave.new()

	save.name = "Testspieler"

	assert_that(save.name).is_equal("Testspieler")

func test_save_system_can_save_player():
	var save_load = load("res://script/save_system/save_load.gd").new()

	var result = save_load.save(
		"Testspieler",
		"test_save"
	)

	assert_that(result).is_equal(false)
	assert_that(
		FileAccess.file_exists("user://savegames/test_save.res")
	).is_true()
	
	save_load.free()

func test_save_system_can_load_player():
	var save_load = load("res://script/save_system/save_load.gd").new()

	save_load.save(
		"Testspieler",
		"test_load"
	)

	var result = save_load.load("test_load")

	assert_that(result).is_equal("Testspieler")
	
	save_load.free()

func test_save_system_detects_existing_savegame():
	var save_load = load("res://script/save_system/save_load.gd").new()

	save_load.save(
		"Testspieler",
		"test_existing"
	)

	var result = save_load.save(
		"NeuerSpieler",
		"test_existing",
		true
	)

	assert_that(result).is_equal(true)
	
	save_load.free()

func test_save_system_can_replace_existing_savegame():
	var save_load = load("res://script/save_system/save_load.gd").new()

	save_load.save(
		"AlterSpieler",
		"test_replace"
	)

	var result = save_load.save(
		"NeuerSpieler",
		"test_replace",
		true,
		true
	)

	assert_that(result).is_equal(false)

	var loaded_name = save_load.load("test_replace")

	assert_that(loaded_name).is_equal("NeuerSpieler")
	
	save_load.free()

func test_save_system_returns_error_for_missing_savegame():
	var save_load = load("res://script/save_system/save_load.gd").new()

	var result = save_load.load("this_save_does_not_exist")

	assert_that(result).is_equal(ERR_FILE_NOT_FOUND)
	
	save_load.free()

func test_save_system_can_save_and_load_current_savegame():
	var save_load = load("res://script/save_system/save_load.gd").new()

	save_load.save_which_savegame("my_save")

	var result = save_load.load_which_savegame()

	assert_that(result).is_equal("my_save")
	
	save_load.free()

func test_save_system_returns_error_when_no_current_savegame_exists():
	var save_load = load("res://script/save_system/save_load.gd").new()

	var path = "user://which_savegame.res"

	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

	var result = save_load.load_which_savegame()

	assert_that(result).is_equal(ERR_FILE_NOT_FOUND)
	
	save_load.free()

func test_savegame_save_can_store_savegame_name():
	var save = SavegameSave.new()

	assert_that(save.savegame).is_equal("")

	save.savegame = "my_save"

	assert_that(save.savegame).is_equal("my_save")

func test_continue_can_load_username():
	var save_load = load("res://script/save_system/save_load.gd").new()

	save_load.save("Testspieler", "test_continue")

	var continue_script = load(
		"res://script/save_system/continue.gd"
	).new()

	continue_script.savegame = "test_continue"

	continue_script.check_load()

	assert_that(continue_script.username).is_equal("Testspieler")
	
	save_load.free()
	continue_script.free()

func test_continue_sets_error_for_missing_savegame():
	var continue_script = load(
		"res://script/save_system/continue.gd"
	).new()

	continue_script.savegame = "does_not_exist"

	continue_script.check_load()

	assert_that(continue_script.username).is_equal("Error")
	
	continue_script.free()

func test_username_control_can_load_username():
	var save_load = load("res://script/save_system/save_load.gd").new()
	save_load.save("Testspieler", "test_username")

	var username_control = load(
		"res://script/ui/start/username_control.gd"
	).new()

	username_control.variable1 = "test_username"
	username_control.check_load()

	assert_that(username_control.username).is_equal("Testspieler")
	
	save_load.free()
	username_control.free()

func test_username_control_sets_error_for_missing_savegame():
	var username_control = load(
		"res://script/ui/start/username_control.gd"
	).new()

	username_control.variable1 = "does_not_exist"
	username_control.check_load()

	assert_that(username_control.username).is_equal("Error")
	
	username_control.free()

func test_username_control_yes_saves_current_savegame():
	var username_control = load(
		"res://script/ui/start/username_control.gd"
	).new()

	username_control.variable1 = "test_yes"

	username_control._on_yes_pressed()

	var save_load = load(
		"res://script/save_system/save_load.gd"
	).new()

	var result = save_load.load_which_savegame()

	assert_that(result).is_equal("test_yes")
	
	username_control.free()
	save_load.free()

func test_start_menu_play_changes_to_play_menu():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var start_menu = load(
		"res://scenes/ui/start/start_menu.tscn"
	).instantiate()

	scene_manager.add_child(start_menu)

	start_menu._on_play_pressed()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/play_menu.tscn"
	)

	scene_manager.free()

func test_start_menu_load_changes_to_load_savegame():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var start_menu = load(
		"res://scenes/ui/start/start_menu.tscn"
	).instantiate()

	scene_manager.add_child(start_menu)

	start_menu._on_load_pressed()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/load_savegame.tscn"
	)

	scene_manager.free()

func test_play_menu_back_changes_to_start_menu():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var play_menu = load(
		"res://scenes/ui/start/play_menu.tscn"
	).instantiate()

	scene_manager.add_child(play_menu)

	play_menu.back()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/start_menu.tscn"
	)

	scene_manager.free()

func test_play_menu_new_game_changes_to_game_start():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var play_menu = load(
		"res://scenes/ui/start/play_menu.tscn"
	).instantiate()

	scene_manager.add_child(play_menu)

	play_menu._on_new_game_pressed()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/game_start.tscn"
	)

	scene_manager.free()

func test_play_menu_continue_changes_to_continue():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var play_menu = load(
		"res://scenes/ui/start/play_menu.tscn"
	).instantiate()

	scene_manager.add_child(play_menu)

	play_menu._on_continue_pressed()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/continue.tscn"
	)

	scene_manager.free()

func test_game_start_can_create_new_savegame():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var game_start = load(
		"res://scenes/ui/start/game_start.tscn"
	).instantiate()

	scene_manager.add_child(game_start)

	game_start.player_name.text = "Testspieler"
	game_start.save_logic()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/username_control.tscn"
	)

	scene_manager.free()

func test_game_start_back_returns_to_play_menu():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	scene_manager.change_scene_fluid(
		"res://scenes/ui/start/game_start.tscn"
	)

	await get_tree().create_timer(1.2).timeout

	var game_start = scene_manager.current_scene

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/game_start.tscn"
	)

	game_start.back()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/play_menu.tscn"
	)

	scene_manager.free()

func test_game_start_detects_existing_savegame():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var game_start = load(
		"res://scenes/ui/start/game_start.tscn"
	).instantiate()

	scene_manager.add_child(game_start)
	await get_tree().process_frame

	var test_name = "ExistingTestPlayer"

	# Erstellt das Savegame, das bereits existieren soll
	SaveLoad.save(test_name, test_name)

	game_start.player_name.text = test_name
	game_start.save_logic()

	await get_tree().process_frame

	assert_that(game_start.exists_node.visible).is_true()
	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/company_icon.tscn"
	)

	DirAccess.remove_absolute("user://savegames/" + test_name + ".res")
	scene_manager.free()

func test_game_start_no_keeps_existing_savegame():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var game_start = load(
		"res://scenes/ui/start/game_start.tscn"
	).instantiate()

	scene_manager.add_child(game_start)
	await get_tree().process_frame

	var test_name = "NoTestPlayer"

	SaveLoad.save("OriginalName", test_name)

	game_start.player_name.text = test_name
	game_start.save_logic()

	await get_tree().process_frame

	assert_that(game_start.exists_node.visible).is_true()

	# "Nein" drücken
	game_start._on_no_pressed()

	await get_tree().process_frame

	assert_that(game_start.exists_node.visible).is_false()

	# Prüfen, dass das vorhandene Savegame unverändert geblieben ist
	var loaded_name = SaveLoad.load(test_name)

	assert_that(loaded_name).is_equal("OriginalName")

	DirAccess.remove_absolute("user://savegames/" + test_name + ".res")
	scene_manager.free()

func test_game_start_yes_overwrites_existing_savegame():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	var game_start = load(
		"res://scenes/ui/start/game_start.tscn"
	).instantiate()

	scene_manager.add_child(game_start)
	await get_tree().process_frame

	var test_name = "YesTestPlayer"

	# Vorhandenes Savegame mit altem Namen erstellen
	SaveLoad.save("OldName", test_name)

	game_start.player_name.text = test_name
	game_start.save_logic()

	await get_tree().process_frame

	assert_that(game_start.exists_node.visible).is_true()

	# "Ja" zum Überschreiben
	game_start._on_yes_pressed()

	await get_tree().create_timer(1.2).timeout

	# Das Savegame muss jetzt den neuen Namen enthalten
	var loaded_name = SaveLoad.load(test_name)

	assert_that(loaded_name).is_equal(test_name)

	# Danach muss UsernameControl aktiv sein
	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/username_control.tscn"
	)

	DirAccess.remove_absolute("user://savegames/" + test_name + ".res")
	scene_manager.free()

func test_load_savegame_finds_save_files():
	var scene = load("res://scenes/ui/start/load_savegame.tscn")
	var load_savegame = scene.instantiate()

	add_child(load_savegame)
	await get_tree().process_frame

	var test_name = "LoadTestPlayer"

	# Test-Savegame erstellen
	SaveLoad.save(test_name, test_name)

	var files = load_savegame.get_save_files()

	assert_that(files).contains(test_name + ".res")

	# Aufräumen
	DirAccess.remove_absolute("user://savegames/" + test_name + ".res")
	load_savegame.free()

func test_load_savegame_populates_savegame_list():
	var scene = load("res://scenes/ui/start/load_savegame.tscn")
	var load_savegame = scene.instantiate()

	add_child(load_savegame)
	await get_tree().process_frame

	var test_name = "ListTestPlayer"

	SaveLoad.save(test_name, test_name)

	load_savegame.populate_savegame_list()

	var item_count = load_savegame.savegame_list.item_count
	var found = false

	for i in range(item_count):
		if load_savegame.savegame_list.get_item_text(i) == test_name:
			found = true
			break

	assert_that(found).is_true()

	DirAccess.remove_absolute("user://savegames/" + test_name + ".res")
	load_savegame.free()

func test_load_savegame_enables_load_button_when_save_is_selected():
	var scene = load("res://scenes/ui/start/load_savegame.tscn")
	var load_savegame = scene.instantiate()

	add_child(load_savegame)
	await get_tree().process_frame

	var test_name = "SelectionTestPlayer"

	SaveLoad.save(test_name, test_name)
	load_savegame.populate_savegame_list()

	assert_that(load_savegame.load_button.disabled).is_true()

	# Ersten Eintrag auswählen
	load_savegame.savegame_list.select(0)
	load_savegame._on_save_item_selected(0)

	assert_that(load_savegame.load_button.disabled).is_false()

	DirAccess.remove_absolute("user://savegames/" + test_name + ".res")
	load_savegame.free()

func test_load_savegame_can_load_selected_save():
	var scene = load("res://scenes/ui/start/load_savegame.tscn")
	var load_savegame = scene.instantiate()

	add_child(load_savegame)
	await get_tree().process_frame

	var test_name = "LoadButtonTestPlayer"

	SaveLoad.save(test_name, test_name)

	var save_path = "user://savegames/" + test_name + ".res"

	# Die Funktion darf beim Laden keinen Fehler verursachen
	load_savegame.load_savegame(save_path)

	var loaded_data = ResourceLoader.load(save_path)

	assert_that(loaded_data).is_not_null()
	assert_that(loaded_data.name).is_equal(test_name)

	DirAccess.remove_absolute(save_path)
	load_savegame.free()

func test_load_savegame_button_loads_selected_save():
	var scene = load("res://scenes/ui/start/load_savegame.tscn")
	var load_savegame = scene.instantiate()

	add_child(load_savegame)
	await get_tree().process_frame

	var test_name = "ButtonLoadTestPlayer"

	SaveLoad.save(test_name, test_name)
	load_savegame.populate_savegame_list()

	assert_that(load_savegame.savegame_list.item_count).is_greater(0)

	# Savegame auswählen
	load_savegame.savegame_list.select(0)
	load_savegame._on_save_item_selected(0)

	assert_that(load_savegame.load_button.disabled).is_false()

	# Laden ausführen
	load_savegame._on_load_button_pressed()

	# Prüfen, dass die Datei weiterhin korrekt geladen werden kann
	var save_path = "user://savegames/" + test_name + ".res"
	var loaded_data = ResourceLoader.load(save_path)

	assert_that(loaded_data).is_not_null()
	assert_that(loaded_data.name).is_equal(test_name)

	DirAccess.remove_absolute(save_path)
	load_savegame.free()

func test_load_savegame_back_returns_to_start_menu():
	var scene = load("res://scenes/scene_manager.tscn")
	var scene_manager = scene.instantiate()

	add_child(scene_manager)
	await get_tree().process_frame

	scene_manager.change_scene_fluid(
		"res://scenes/ui/start/load_savegame.tscn"
	)

	await get_tree().create_timer(1.2).timeout

	var load_savegame = scene_manager.current_scene

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/load_savegame.tscn"
	)

	load_savegame.back()

	await get_tree().create_timer(1.2).timeout

	assert_that(scene_manager.current_scene_path).is_equal(
		"res://scenes/ui/start/start_menu.tscn"
	)

	scene_manager.free()
