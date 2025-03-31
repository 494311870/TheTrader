extends Node

signal show_trader_requested(trader_stats: TraderStats)
@export var trader_stats: TraderStats


func _ready() -> void:
	show_trader_requested.emit(trader_stats)
	