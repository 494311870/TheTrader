extends Node

@export var character_template: CharacterStats

@onready var _player_ui: PlayerUI = %PlayerUI
@onready var _backpack_ui: BackpackUI = %BackpackUI

var _character_stats: CharacterStats


func _ready() -> void:
	_character_stats = character_template.create_instance()
	owner.set_meta("player_stats", _character_stats)

	_player_ui.stats = _character_stats
	_backpack_ui.stats = _character_stats
	_backpack_ui.hide()

	_character_stats.desktop.stats_changed.connect(_on_character_slot_changed)
	_character_stats.backpack.stats_changed.connect(_on_character_slot_changed)


func _exit_tree():
	_character_stats.dispose()
	_character_stats = null


func update_trader(trader_stats: TraderStats) -> void:
	_character_stats.current_trader = trader_stats


func _sell_item(item_ui: ItemUI) -> void:
	var item: ItemStats = item_ui.stats
	item_ui.hide()
	item_ui.queue_free()

	_trigger_sell_abilities(item)
	item.deactivate_abilities()
	item.owner.remove_item(item)
	

	_character_stats.gain_coins(item.price)

	_update_trader_items_stats()


func _update_trader_items_stats() -> void:
	var trader: TraderStats = _character_stats.current_trader
	if not trader:
		return

	for item in trader.desktop.items:
		var character_item: ItemStats = _character_stats.find_same_item(item.id)
		item.is_level_up = character_item != null


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
	item_stats.activate_abilities(_character_stats)
	_trigger_buy_abilities.call_deferred(item_stats)


func upgrade_item(item_ui: ItemUI) -> void:
	item_ui.hide()
	item_ui.queue_free()

	var item_stats: ItemStats     = item_ui.stats
	var character_item: ItemStats = _character_stats.find_same_item(item_stats.id)
	character_item.level_up()
	_character_stats.trigger_items_abilities(Item.Trigger.SlotChanged)
	_trigger_buy_abilities.call_deferred(character_item)


func _on_character_slot_changed() -> void:
	_character_stats.trigger_items_abilities(Item.Trigger.SlotChanged)


func _trigger_buy_abilities(item: ItemStats) -> void:
	item.trigger_abilities(Item.Trigger.SelfBuy)
	var other_items: Array[ItemStats] = _character_stats.get_all_items()
	other_items.erase(item)
	for other_item in other_items:
		other_item.trigger_abilities(Item.Trigger.OtherBuy)


func _trigger_sell_abilities(item: ItemStats) -> void:
	item.trigger_abilities(Item.Trigger.SelfSell)
	var other_items: Array[ItemStats] = _character_stats.get_all_items()
	other_items.erase(item)
	for other_item in other_items:
		other_item.trigger_abilities(Item.Trigger.OtherSell)


	
