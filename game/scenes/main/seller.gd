extends Control

signal sell_requested(item_ui: ItemUI)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data == null:
		return false
	if not data.has("item"):
		return false

	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var drop_item: ItemUI = data.item
	sell_requested.emit(drop_item)
	