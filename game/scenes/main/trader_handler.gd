extends Node

@export var item_pool: ItemPool

@onready var trader_ui: TraderUI = %TraderUI

var level_weights: PackedInt32Array = [0, 5, 0, 0, 0]


func _ready() -> void:
	item_pool.initialize()


func _show_trader(trader_stats: TraderStats) -> void:
	if not is_node_ready():
		await ready

	var character_stats: CharacterStats = owner.get_meta("player_stats")

	trader_stats.refresh_desktop(item_pool)
	for item in trader_stats.desktop.items:
		var character_item: ItemStats = character_stats.find_same_item(item.id)
		if character_item:
			item.level = character_item.level
		else:
			item.level = ItemStats.ItemLevel.Bronze

		item.price = _get_item_base_price(item)

	trader_ui.stats = trader_stats
	trader_ui.show_scene()


func _get_item_base_price(item: ItemStats) -> int:
	var level: int = item.level
	var size: int  = item.item_size
	return size * level * 2

