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
