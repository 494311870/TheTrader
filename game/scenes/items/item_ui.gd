class_name ItemUI
extends Control

@export var item_size: ItemStats.ItemSize
@export var stats: ItemStats: set = _set_stats

@onready var visuals: ItemVisuals = %ItemVisuals

var _is_dragging: bool = false


func _notification(what: int) -> void:

	if what == NOTIFICATION_DRAG_BEGIN:
		self.set_mouse_filter(MOUSE_FILTER_IGNORE)

	if what == NOTIFICATION_DRAG_END:
		self.set_mouse_filter(MOUSE_FILTER_STOP)
		if _is_dragging:
			show()


func _get_drag_data(at_position: Vector2) -> Variant:
	_is_dragging = true
	var item: Control = duplicate()
	item.position = -at_position
	item.z_index = 10

	var preview := Control.new()
	preview.add_child(item)

	hide()
	set_drag_preview(preview)

	return {"item": self, "offset": at_position}


func _set_stats(value: ItemStats) -> void:
	stats = value
	
	if not is_node_ready():
		await ready
		
	visuals.stats = value
	
	
	
