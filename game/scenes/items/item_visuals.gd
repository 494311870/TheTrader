class_name ItemVisuals
extends Control

@export var stats: ItemStats: set = _set_stats

@onready var icon: TextureRect = %Icon


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set_stats(value: ItemStats) -> void:
	if stats == value:
		return
	
	if stats != null:
		stats.stats_changed.disconnect(update_stats)
	
	stats = value

	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_item()


func update_stats() -> void:
	pass


func update_item() -> void:

	if not is_node_ready():
		await ready

	icon.texture = stats.art

	update_stats()
