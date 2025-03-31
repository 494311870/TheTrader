class_name ItemStats
extends Resource

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


