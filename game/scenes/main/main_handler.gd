extends Node

signal show_trader_requested(trader_stats: TraderStats)
signal show_game_over_requested(result: String)
@export_dir var _traders_dir: String
@export var _traders: Array[TraderStats] = []
@export var _run_stats_template: RunStats

@onready var _run_ui: RunUI = %RunUI

var _player: CharacterStats
var _previous_trader: TraderStats
var _run_stats: RunStats


func _ready() -> void:
	_set_up()
	_next_day.call_deferred()


func _set_up() -> void:
	_player = owner.get_meta("player_stats")

	_run_stats = _run_stats_template.duplicate()
	_run_ui.stats =_run_stats

	if not _traders_dir:
		return

	_traders.clear()
	var resources: Array = ResourceUtility.load_from_path(_traders_dir)
	for resource in resources:
		if resource is TraderStats:
			_traders.append(resource)


func _next_day() ->void:
	if _run_stats.days != 0:
		_player.earn_income()

	_run_stats.next_day()
	_refresh_trader()


func _game_fail() -> void:
	show_game_over_requested.emit("失败")


func _game_success() -> void:
	show_game_over_requested.emit("成功")


func _on_leave_requested() -> void:
	# check score target
	# gain income
	if _player.coin < _run_stats.next_day_target:
		_game_fail()
		return

	_next_day()


func _refresh_trader() ->void:
	var  available_traders: Array[TraderStats] = []
	available_traders.append_array(_traders)
	if _previous_trader:
		available_traders.erase(_previous_trader)

	_previous_trader = available_traders.pick_random()
	show_trader_requested.emit(_previous_trader)


func _restart_game():
	get_tree().reload_current_scene()
