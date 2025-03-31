class_name ItemPool
extends Resource

@export_dir var _dirPath: String
@export var _pool: Array[ItemStats] = []

var _is_initialized: bool


func initialize() -> void:
	if _is_initialized:
		return
	_is_initialized = true
	if not _dirPath:
		return

	_pool.clear()
	var items: Array = ResourceUtility.load_from_path(_dirPath)
	for item in items:
		if item is ItemStats:
			_pool.append(item)


func filter_with_tags(tags: Array[ItemTag]) -> Array[ItemStats]:
	var result: Array[ItemStats] = []
	for item in _pool:
		if _is_valid(item, tags):
			result.append(item)
		
	return result


func _is_valid(item: ItemStats, filter_tags: Array[ItemTag]) -> bool:
	for tag in filter_tags:
		if item.has_tag(tag):
			return true

	return false