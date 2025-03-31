class_name ItemStats
extends Resource

const Small_Tag  := preload("res://game/contents/tags/small.tres")
const Medium_Tag := preload("res://game/contents/tags/medium.tres")
const Large_Tag  := preload("res://game/contents/tags/large.tres")
enum ItemSize{
	Small = 1,
	Medium = 2,
	Large = 3,
}
enum ItemLevel{
	Bronze = 1,
	Silver = 2,
	Gold = 3,
	Diamond = 4,
	Legendary = 5
}
signal stats_changed
@export var art: Texture2D
@export var name: String
@export var description: String
@export var item_size: ItemSize = ItemSize.Small
@export var level: ItemLevel
@export var price: int
@export var tags: Array[ItemTag]

var id_in_slot: int
var owner: SlotStats


func create_instance() -> ItemStats:
	var instance: ItemStats = duplicate()
	return instance


func has_tag(tag: ItemTag) -> bool:
	if _get_size_tag() == tag: 
		return true

	return tags.has(tag)


func _get_size_tag() -> ItemTag:
	match item_size:
		ItemSize.Small: return Small_Tag
		ItemSize.Medium: return Medium_Tag
		ItemSize.Large: return Large_Tag
		_: return null
