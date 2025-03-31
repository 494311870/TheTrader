extends Node

@export var item_pool: ItemPool

@onready var trader_ui: TraderUI = %TraderUI

var _trader_stats: TraderStats
var _customer: CharacterStats
var _level_weights: PackedInt32Array = [0, 5, 0, 0, 0]


func _ready() -> void:
	item_pool.initialize()
	_customer = owner.get_meta("player_stats")

	_customer.stats_changed.connect(_on_customer_stats_changed)


func _show_trader(trader_stats: TraderStats) -> void:
	_trader_stats = trader_stats
	if not is_node_ready():
		await ready

	_trader_stats.refresh_desktop(item_pool)
	for item in _trader_stats.desktop.items:
		var character_item: ItemStats = _customer.find_same_item(item.id)
		if character_item:
			item.level = character_item.level
		else:
			item.level = ItemStats.ItemLevel.Bronze

		item.price = _get_item_base_price(item)

	trader_ui.stats = _trader_stats
	trader_ui.show_scene()


func _get_item_base_price(item: ItemStats) -> int:
	var level: int = item.level
	var size: int  = item.item_size
	return size * level * 2


func _on_customer_stats_changed() -> void:
	if not _trader_stats:
		return

	for item in _trader_stats.desktop.items:
		item.coin_not_enough = _customer.coin < item.price
		print("%s : coin_not_enough => %s" % [item.id, item.coin_not_enough])
		