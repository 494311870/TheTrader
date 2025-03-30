class_name Slot
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

	reset_slots()


func reset_slots() -> void:
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

	print(get_name(), _slots)


func remove_item(item: ItemUI) -> void:
	var start_index: int = _slots.find(item.item_index)
	for i in range(0, item.item_size):
		_slots[start_index + i] = -1


func get_start_slot_index(item: ItemUI) -> int:
	return _slots.find(item.item_index)


func put_item(put_item: ItemUI, to_index: int) ->void:
	print("put_item: %s..%s" % [to_index, put_item.item_size])
	put_item.reparent(self)
	put_item.item_index = _get_next_item_index()
	for i in range(0, put_item.item_size):
		_slots[to_index + i] = put_item.item_index


func _sort_children() -> void:
	var children: Array[Node] = get_children().filter(func (x): return x is ItemUI)
	# 按 position.x 从小到大排序
	children.sort_custom(func(a, b): return a.position.x < b.position.x)
	# 重新排列子节点顺序（调整场景树中的顺序）
	for idx in range(children.size()):
		move_child(children[idx], idx)


func update_items_position() -> void:
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

	var can_insert := _has_enough_space_after(slot_index, drop_item)
	if can_insert:
		return true

	if drop_item.get_parent() == self:
		return false

	# can swap
	return _has_contiguous_space_after(slot_index, drop_item)


func _has_enough_space_after(start_index: int, drop_item: ItemUI) -> bool:
	var space                := 0
	var item_size: int       =  drop_item.item_size
	var drop_item_index: int =  drop_item.item_index \
								if (drop_item.get_parent() == self)\
								else  - 1

	for i in range(start_index, _slots.size()):
		if _slots[i] == -1 || _slots[i] == drop_item_index:
			space += 1
		if space >= item_size:
			return true

	return false


func _has_contiguous_space_after(start_index: int, drop_item: ItemUI) -> bool:
	var drop_item_size: int = drop_item.item_size

	var index_begin: int = start_index
	var index_end: int   = index_begin

	while true:
		if index_begin > 0 and _slots[index_begin -1] == _slots[index_begin]:
			return false

		if _slots[index_end] == -1:
			index_end += 1
		else:
			var next_item_size: int = _get_slot_item_size(index_end)
			index_end += next_item_size

		if index_end - index_begin == drop_item_size:
			return true

		if index_end - index_begin > drop_item_size:
			return false

	return false


func _get_slot_item_size(start_index: int) ->int:
	var result: int     = 1
	var item_index: int = _slots[start_index]
	for i in range(start_index + 1, _slots.size()):
		if _slots[i] ==item_index:
			result += 1
		else:
			break

	return result


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var origin_slot: Slot = data.item.get_parent() as Slot
	var target_slot: Slot = self
	var drop_item: ItemUI = data.item
	var target_position   = at_position - data.offset
	var slot_index: int   = _find_nearest_index(target_position)

	if origin_slot == target_slot:
		# delete drop_item
		remove_item(drop_item)
		_change_location(drop_item, slot_index)
	else:
		if _has_enough_space_after(slot_index, drop_item):
			# insert
			drop_item.reparent(target_slot)
			drop_item.item_index = _get_next_item_index()
			origin_slot.reset_slots()
			_change_location(drop_item, slot_index)
		else:
			#swap
			_swap_items(slot_index, drop_item)


func _change_location(drop_item: ItemUI, to_index: int) -> void:
	_insert_item(drop_item, to_index)
	update_items_position()
	reset_slots()
	print("index : %s" % to_index)
	print("item.position : %s" % drop_item.position)


func _insert_item(drop_item: ItemUI, to_index: int) -> void:
	var drop_item_index: int = drop_item.item_index

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

	print(get_name(), _slots)


func _swap_items(start_index: int, drop_item: ItemUI) -> void:
	var origin_slot: Slot = drop_item.get_parent() as Slot
	var target_slot: Slot = self

	var drop_item_size: int = drop_item.item_size;
	var swap_put_index: int       = origin_slot.get_start_slot_index(drop_item)
	var swap_items: Array[ItemUI] = _get_items(start_index, start_index + drop_item_size)

	print("swap_items : %s | %s" % [drop_item, swap_items])
	# remove
	origin_slot.remove_item(drop_item)
	for item in swap_items:
		target_slot.remove_item(item)

	# put
	target_slot.put_item(drop_item, start_index)
	target_slot.update_items_position()
	target_slot.reset_slots()

	for item in swap_items:
		origin_slot.put_item(item, swap_put_index)
		swap_put_index += item.item_size

	origin_slot.update_items_position()
	origin_slot.reset_slots()


func _get_items(start_index: int, end_index: int) -> Array[ItemUI]:
	var result: Array[ItemUI] = []

	var current_index: int = start_index
	while current_index < end_index:
		var item_index := _slots[current_index]
		if item_index >= 0:
			var item: ItemUI = _get_item(item_index)
			result.append(item)
			current_index += item.item_size
		else: 
			current_index += 1

	return result


func _get_item(item_index: int) -> ItemUI:
	for child in self.get_children():
		if child.item_index == item_index:
			return child
	return null


func _get_next_item_index() -> int:
	var max_value: int = 0
	for i in range(0, _slots.size()):
		if _slots[i] > max_value:
			max_value = _slots[i]

	return max_value + 1


func _find_nearest_index(at_position: Vector2) -> int:
	if at_position.x < start_position.x:
		return 0

	if at_position.x > start_position.x + slot_quantity * slot_size.x:
		return slot_quantity - 1

	return roundi((at_position.x - start_position.x) / slot_size.x)


func _calculate_position(index: int) -> Vector2:
	return start_position + Vector2(index * slot_size.x, 0)
	
	
	
