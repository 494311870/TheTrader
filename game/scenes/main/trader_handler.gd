extends Node

@export var item_pool: ItemPool

@onready var trader_ui: TraderUI = %TraderUI

var _trader_stats: TraderStats
var _customer: CharacterStats
var _level_weights: PackedInt32Array = [0, 5, 0, 0, 0]


func _ready() -> void:
	item_pool.initialize()
	_customer = owner.get_meta("player_stats")


func _show_trader(trader_stats: TraderStats) -> void:
	_trader_stats = trader_stats
	if not is_node_ready():
		await ready

	_trader_stats.set_up()
	_trader_stats.item_pool = item_pool

	trader_ui.stats = _trader_stats
	trader_ui.customer = _customer
	trader_ui.show_scene()


	