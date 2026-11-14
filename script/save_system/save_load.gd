extends Node

func save(player_name, savegame : String, creation : bool = false, replace : bool = false):
	var creation_check_path = "user://savegames/" + savegame + ".res"
	if replace == false:
			if creation == true:
				if FileAccess.file_exists(creation_check_path):
					return true
				else:
					pass
			else:
				pass
	
	var player_save = PlayerSave.new()
	
	player_save.name = player_name
	
	var path : String = "user://savegames/" + savegame + ".res"
	
	ResourceSaver.save(player_save, path)
	
	print("Was saved")
	
	return false
	
func load(savegame : String):
	var path = "user://savegames/" + savegame + ".res"
	
	if FileAccess.file_exists(path):
		var data = ResourceLoader.load(path) as PlayerSave
		
		if data == null:
			return ERR_FILE_CORRUPT
		
		
		var player_name = data.savegame
		return player_name
	else:
		print("Savegame-File doesn't exist at path:", path)
		return ERR_FILE_NOT_FOUND


func save_which_savegame(current_savegame : String):
	
	var which_savegame_save = PlayerSave.new()
	
	which_savegame_save.name = current_savegame
	
	var path : String = "user://which_savegame.res"
	
	ResourceSaver.save(which_savegame_save, path)
	
	print("Which savegame was saved")

func load_which_savegame():
	var path = "user://which_savegame.res"
	
	if FileAccess.file_exists(path):
		var data = ResourceLoader.load(path) as PlayerSave
		
		if data == null:
			return ERR_FILE_CORRUPT
		
		
		var which_savegame = data.savegame
		return which_savegame
	else:
		print("Savegame-File doesn't exist at path:", path)
		return ERR_FILE_NOT_FOUND
