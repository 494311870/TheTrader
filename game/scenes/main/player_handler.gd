extends Node

@export var character_template: CharacterStats

@onready var _player_ui: PlayerUI = %PlayerUI
@onready var _backpack_ui: BackpackUI = %BackpackUI


func _ready() -> void:
	var player: CharacterStats = character_template.create_instance()
	_player_ui.stats = player
	_backpack_ui.stats = player.backpack
	_backpack_ui.hide()
	
	
	