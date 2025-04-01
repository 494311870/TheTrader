extends Node

signal show_trader_requested(trader_stats: TraderStats)
@export_dir var _traders_dir: String
@export var traders: Array[TraderStats] = []

@onready var trader_ui: TraderUI = %TraderUI

var _previous_trader: TraderStats


func _ready() -> void:
	_set_up()
	_refresh_trader.call_deferred()

	trader_ui.leave_requested.connect(_on_leave_requested)


func _set_up() -> void:
	if not _traders_dir:
		return

	traders.clear()
	var resources: Array = ResourceUtility.load_from_path(_traders_dir)
	for resource in resources:
		if resource is TraderStats:
			traders.append(resource)


func _on_leave_requested() -> void:
	_refresh_trader()


func _refresh_trader() ->void:
	var  available_traders: Array[TraderStats] = []
	available_traders.append_array(traders)
	if _previous_trader:
		available_traders.erase(_previous_trader)

	_previous_trader = available_traders.pick_random()
	show_trader_requested.emit(_previous_trader)