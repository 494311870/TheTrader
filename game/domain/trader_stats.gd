class_name TraderStats
extends Resource

@export_group("Attributes")
@export var desktop: SlotStats
@export var item_pool: ItemPool
@export var item_generator: ItemGenerator
@export var ability: Ability
@export_group("Visuals")
@export var art: Texture2D
@export var name: String

@export_multiline var description: String
@export var desktop_style_box: StyleBox


func refresh_desktop():
	item_generator.pool = item_pool
	var items: Array[ItemStats] = item_generator.generate()
	if not desktop:
		desktop = SlotStats.new()

	desktop.set_up_with_items(items)
