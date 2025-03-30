extends Control

@export var slot_quantity: int = 10
@export var slot_size: Vector2 = Vector2(150, 300)
@export var start_position: Vector2
@export var debugShape: CollisionShape2D

var _slots := PackedInt32Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	# init slot
	_slots.resize(slot_quantity)
	_slots.fill(-1)

	for child in self.get_children():
		if child is Control and child.visible == false:
			child.queue_free()

	_reset_slots()


func _reset_slots() -> void:
	_sort_children()

	_slots.fill(-1)

	var item_index := 0
	for child in self.get_children():
		if not (child is ItemUI):
			continue

		if child.is_queued_for_deletion():
			continue

		child.item_index = item_index
		var slot_intex := _find_nearest_index(child.position)
		for i in range(0, child.item_size):
			_slots[slot_intex + i] = item_index

		item_index += 1

	print(_slots)


func _sort_children() -> void:
	var children: Array[Node] = get_children().filter(func (x): return x is ItemUI)
	# 按 position.x 从小到大排序
	children.sort_custom(func(a, b): return a.position.x < b.position.x)
	# 重新排列子节点顺序（调整场景树中的顺序）
	for idx in range(children.size()):
		move_child(children[idx], idx)


func _update_item_position() -> void:
	for child in self.get_children():
		if not (child is ItemUI):
			continue

		var slot_intex := _slots.find(child.item_index)
		child.position = _calculate_position(slot_intex)


func _notification(what: int) -> void:

	if what == NOTIFICATION_DRAG_END:
		pass


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data == null:
		return false
	if not data.has("item"):
		return false

	var drop_item: ItemUI = data.item
	var target_position   = at_position - data.offset
	var slot_index: int   = _find_nearest_index(target_position)
	return _has_enough_space_after(slot_index, drop_item)


func _has_enough_space_after(target_start: int, drop_item: ItemUI) -> bool:
	var space          := 0
	var item_size: int =  drop_item.item_size
	for i in range(target_start, _slots.size()):
		if _slots[i] == -1 || _slots[i] == drop_item.item_index:
			space += 1
			if space >= item_size:
				return true

	return false


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var origin_slot       = data.item.get_parent()
	var target_slot: Node = self
	if origin_slot == target_slot:
		_change_location(at_position, data)


func _change_location(at_position: Vector2, data: Variant) -> void:
	var drop_item: ItemUI = data.item
	var target_position   = at_position - data.offset
	var slot_index: int   = _find_nearest_index(target_position)

	_insert_item(drop_item, slot_index)
	_update_item_position()
	_reset_slots()
	print("index : %s" % slot_index)
	print("item.position : %s" % drop_item.position)


func _insert_item(drop_item: ItemUI, to_index: int) -> void:
	var drop_item_index: int

	if drop_item.get_parent() == self:
		drop_item_index = drop_item.item_index
		var slot_index: int = _slots.find(drop_item_index)
		for i in range(0, drop_item.item_size):
			_slots[slot_index + i] = -1
	else:
		drop_item.reparent(self)
		drop_item.item_index = _get_next_item_index()
		drop_item_index = drop_item.item_index

	var backup := PackedInt32Array()
	for i in range(0, drop_item.item_size):
		backup.append(drop_item_index)

	# move other
	var item_size: int = drop_item.item_size
	var move_start_index: int
	if _slots[to_index] == -1:
		move_start_index = to_index
	else:
		move_start_index = _slots.find(_slots[to_index])
	
	for i in range(move_start_index, _slots.size()):
		var item_index := _slots[i]
		if item_index < 0 and item_size > 0:
			item_size -=1
			continue

		backup.append(item_index)

	for i in range(move_start_index, _slots.size()):
		_slots[i] = backup[i - move_start_index]

	print(_slots)


func _get_next_item_index() -> int:
	for i in range(_slots.size(), 0, -1):
		if _slots[i] >= 0:
			return _slots[i] + 1

	return 0


func _find_nearest_index(at_position: Vector2) -> int:
	if at_position.x < start_position.x:
		return 0

	if at_position.x > start_position.x + slot_quantity * slot_size.x:
		return slot_quantity - 1

	return roundi((at_position.x - start_position.x) / slot_size.x)


func _calculate_position(index: int) -> Vector2:
	return start_position + Vector2(index * slot_size.x, 0)
	
	
	
