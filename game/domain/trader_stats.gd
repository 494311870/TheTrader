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


func set_up():
	if not self.desktop:
		self.desktop = SlotStats.new()


## func is_valid(item:ItemStats) -> bool
func refresh_desktop(is_valid: Callable) -> void:
	item_generator.pool = item_pool
	var items: Array[ItemStats] = item_generator.generate(is_valid)
	desktop.set_up_with_items(items)
