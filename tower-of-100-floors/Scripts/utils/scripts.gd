extends Node
class_name Scripts

static func _search_item(DIR: String, item_name: String) -> bool:
	var dir = DirAccess.open(DIR)
	if dir:
		dir.list_dir_begin()
		var archive_name = dir.get_next()
		while archive_name != "":
			if not dir.current_is_dir():
				print("Arquivo encontrado: " + archive_name)
				if archive_name.contains(item_name):
					return true
			archive_name = dir.get_next()
		dir.list_dir_end()
	else:
		return false
	return false
