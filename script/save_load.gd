extends Node

func save(player_name, savegame : String) -> void:
	var player_save = PlayerSave.new()
	
	player_save.name = player_name
	
	var path : String = "user://savegame_" + savegame + ".res"
	
	ResourceSaver.save(player_save, path)
	
	print("Was saved")
	
func load(savegame : String):
	var path = "user://savegame_" + savegame + ".res"
	
	if FileAccess.file_exists(path):
		var data = ResourceLoader.load(path) as PlayerSave
		
		if data:
			var player_name = data.name
			return player_name
