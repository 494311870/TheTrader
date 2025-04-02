class_name BackpackUI
extends Control

@export var stats: CharacterStats: set = _set_stats

@onready var slot_ui: SlotUI = %SlotUI
@onready var art: TextureRect = %Art

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _set_stats(value: CharacterStats) -> void:
	if stats != null:
		stats.new_item_added.disconnect(_on_new_item_added)

	stats = value
	if stats == null:
		return

	if not stats.stats_changed.is_connected(_on_new_item_added):
		stats.new_item_added.connect(_on_new_item_added)

	if not is_node_ready():
		await ready

	slot_ui.stats = stats.backpack

func _on_new_item_added(item: ItemStats) -> void:
	if item.owner == slot_ui.stats:
		slot_ui.add_item(item)


func _on_backpack_clicked():
	visible = not visible
