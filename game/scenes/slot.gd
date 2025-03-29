extends Control

@export var slot_quantity: int = 10
@export var slot_size: Vector2 = Vector2(150, 300)
@export var start_position: Vector2
@export var debugShape: CollisionShape2D

var _slots: PackedInt32Array = PackedInt32Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	# init slot
	for i in range(0, slot_quantity):
		_slots.append(-1)


func _notification(what: int) -> void:

	if what == NOTIFICATION_DRAG_END:
		pass


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data != null && data.has("item")


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var origin_slot       = data.item.get_parent()
	var target_slot: Node = self
	if origin_slot == target_slot:
		var item: Control   = data.item
		var drop_position = at_position - data.offset
		var index: int      = _find_nearest_index(drop_position)
		print("index : %s" % index)
		item.position = _calculate_position(index)
		print("item.position : %s" % item.position)
		


func _find_nearest_index(at_position: Vector2) -> int:
	if at_position.x < start_position.x:
		return 0

	if at_position.x > start_position.x + slot_quantity * slot_size.x:
		return slot_quantity - 1

	return roundi((at_position.x - start_position.x) / slot_size.x)


func _calculate_position(index: int) -> Vector2:
	return start_position + Vector2(index * slot_size.x, 0)
	
	
	
