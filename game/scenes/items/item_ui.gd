class_name ItemUI 
extends Control

enum ItemSize {
	Small = 1,
	Medium = 2,
	Large = 3,
}

@export var item_size: ItemSize

var item_index: int = 0
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
	
	
	
