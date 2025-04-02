class_name SlotUI
extends Control

@export var stats: SlotStats: set = _set_stats

@onready var slot: Slot = %Slot


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set_stats(value: SlotStats) -> void:
	stats = value
	if not is_node_ready():
		await ready

	slot.stats = value
	_update_slot()


func _update_slot():
	pass


func add_item(item: ItemStats) ->void:
	slot.add_item(item)
	slot.update_stats()
	
