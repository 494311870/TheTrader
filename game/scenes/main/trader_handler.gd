extends Node

@export var item_pool: ItemPool

@onready var trader_ui: TraderUI = %TraderUI

func _ready() -> void:
	item_pool.initialize()

func _show_trader(trader_stats: TraderStats) -> void:
	if not is_node_ready():
		await ready 
		
	trader_stats.refresh_desktop(item_pool)
	trader_ui.stats = trader_stats
	trader_ui.show_scene()

	


