extends Control

func _get_drag_data(at_position: Vector2) -> Variant:
	var item: Control = duplicate()
	item.position = -at_position

	var preview := Control.new()
	preview.add_child(item)

	set_drag_preview(preview)
	return {"item": self, "offset": at_position}
	
	
	
