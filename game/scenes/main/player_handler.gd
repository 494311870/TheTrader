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
	


func _sell_item(item_ui: ItemUI) -> void:
	var item: ItemStats = item_ui.stats
	item_ui.hide()
	item_ui.queue_free()

	item.owner.remove_item(item)

	_character_stats.gain_coins(item.price)
	
