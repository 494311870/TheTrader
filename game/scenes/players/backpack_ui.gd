class_name BackpackUI
extends Control

@export var stats: SlotStats: set = _set_stats

@onready var slot_ui: SlotUI = $SlotUI
@onready var art: TextureRect = %Art

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _set_stats(value: SlotStats) -> void:
	stats = value

	if not is_node_ready():
		await ready

	slot_ui.stats = stats


func _on_backpack_clicked():
	visible = not visible