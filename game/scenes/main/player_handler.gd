extends Node

@export var character_template: CharacterStats

@onready var _player_ui: PlayerUI = %PlayerUI
@onready var _backpack_ui: BackpackUI = %BackpackUI

var _character_stats: CharacterStats


func _ready() -> void:
	_character_stats = character_template.create_instance()
	owner.set_meta("player_stats", _character_stats)

	_player_ui.stats = _character_stats
	_backpack_ui.stats = _character_stats.backpack
	_backpack_ui.hide()


func _exit_tree():
	_character_stats.dispose()
	_character_stats = null


func _sell_item(item_ui: ItemUI) -> void:
	var item: ItemStats = item_ui.stats
	item_ui.hide()
	item_ui.queue_free()

	item.deactivate_abilities()
	item.owner.remove_item(item)

	_character_stats.gain_coins(item.price)


func _buy_item(item_ui: ItemUI) ->void:
	var item_stats: ItemStats = item_ui.stats
	if _character_stats.is_owner(item_stats):
		return
	# buy
	_character_stats.lose_coins(item_stats.price)
	if item_stats.is_level_up:
		upgrade_item(item_ui)
		return
	# 
	item_stats.price /= 2
	item_stats.coin_not_enough = false
	item_stats.activate_abilities.call_deferred()
	
	
func upgrade_item(item_ui: ItemUI) -> void:
	item_ui.hide()
	item_ui.queue_free()
	
	var item_stats: ItemStats = item_ui.stats
	var character_item: ItemStats = _character_stats.find_same_item(item_stats.id)
	character_item.level_up()
	
