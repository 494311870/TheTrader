class_name ResourceUtility

static func list_files(path: String) -> Array[String]:
	var result: Array[String] = []
	var dir_access: DirAccess = DirAccess.open(path)

	dir_access.list_dir_begin()

	var next: String = dir_access.get_next()
	while next != "":
		if dir_access.current_is_dir():
			continue
		else:
			var full_path: String = dir_access.get_current_dir() + "/" + next
			var real_path: String = get_real_path(full_path)
			result.append(real_path)

		next = dir_access.get_next()

	dir_access.list_dir_end()

	return result


static func get_real_path(full_path: String) -> String:
	return full_path.trim_suffix(".remap")


static func load_from_path(path: String) -> Array:
	var files: Array[String] = list_files(path)
	return files.map(ResourceLoader.load)
