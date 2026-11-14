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
