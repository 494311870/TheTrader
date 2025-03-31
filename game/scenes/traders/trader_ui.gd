class_name TraderUI
extends Control

@export var stats: TraderStats: set = _set_stats

@onready var slot_ui: SlotUI = $SlotUI
@onready var trader_art: TextureRect = %TraderArt


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _set_stats(value: TraderStats) -> void:
	stats = value
	
	if not is_node_ready():
		await ready
		
	slot_ui.stats = stats.desktop
	_update_trader()


func _update_trader() -> void:
	trader_art.texture = stats.art


func show_scene() -> void:
	show()

