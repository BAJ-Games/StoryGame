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

func test_save_system_can_load_player():
	var save_load = load("res://script/save_system/save_load.gd").new()

	save_load.save(
		"Testspieler",
		"test_load"
	)

	var result = save_load.load("test_load")

	assert_that(result).is_equal("Testspieler")

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
