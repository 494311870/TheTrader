class_name SlotStats
extends Resource

const Max_Slot_Quantity := 10
signal stats_changed
signal set_up_requested
@export_range(1, Max_Slot_Quantity, 1)
var slot_quantity: int = 10
@export var items: Array[ItemStats] = []

var _slots      := PackedInt32Array()
var _slots_temp := PackedInt32Array()


func set_up_with_empty()-> void:
	_slots.resize(slot_quantity)
	_slots.fill(-1)
	set_up_requested.emit()


func set_up_with_items(initial_items: Array[ItemStats])-> void:
	self.items.clear()
	self.items.append_array(initial_items)
	_shrink()
	_slots.resize(slot_quantity)
	_slots.fill(-1)

	var slot_index := 0
	for item: ItemStats in self.items:
		item.owner = self
		item.id_in_slot = _get_next_item_id()
		for i in range(0, item.item_size):
			_slots[slot_index] = item.id_in_slot
			slot_index += 1

	set_up_requested.emit()


func _shrink() -> void:
	var quantity: int = 0
	for item in items:
		quantity += item.item_size

	slot_quantity = quantity


func clear() -> void:
	self.items.clear()
	_slots.resize(slot_quantity)
	_slots.fill(-1)


func remap_items_id() -> void:
	_slots_temp.resize(_slots.size())
	_slots_temp.fill(-1)

	var id := 0
	for item in items:
		var start_index := get_start_index(item)
		item.id_in_slot = id

		for i in range(0, item.item_size):
			_slots_temp[start_index + i] = id

		id += 1

	_slots.clear()
	_slots.append_array(_slots_temp)

	print(get_name(), _slots)


func get_start_index(item: ItemStats) -> int:
	return _slots.find(item.id_in_slot)


func get_adjacent_items(item: ItemStats) -> Array[ItemStats]:
	var result: Array[ItemStats] = []

	var left: ItemStats = get_left_item(item)
	if left:
		result.append(left)

	var right: ItemStats = get_right_item(item)
	if right:
		result.append(right)

	return result


func get_left_item(item: ItemStats) -> ItemStats:
	var start_index: int = get_start_index(item)
	if start_index - 1 >= 0 and _slots[start_index - 1] != -1:
		return get_item(start_index - 1)

	return null


func get_right_item(item: ItemStats) -> ItemStats:
	var start_index: int = get_start_index(item)
	var item_size: int   = item.item_size
	var end_index: int   = start_index + item_size - 1

	if end_index + 1 < _slots.size() and _slots[end_index + 1] != -1:
		return get_item(end_index + 1)

	return null


func get_space() -> int:
	return _slots.count(-1)


func has_enough_space_after(start_index: int, item: ItemStats) -> bool:
	var space          := 0
	var item_size: int =  item.item_size
	var item_id: int   =  item.id_in_slot \
						  if (item.owner == self)\
						  else  - 1

	for i in range(start_index, _slots.size()):
		if _slots[i] == -1 || _slots[i] == item_id:
			space += 1
		if space >= item_size:
			return true

	return false


func has_contiguous_space_after(start_index: int, item_size: int) -> bool:
	var index_begin: int = start_index
	var index_end: int   = index_begin

	while true:
		if index_begin > 0 and _slots[index_begin -1] == _slots[index_begin]:
			return false

		if _slots[index_end] == -1:
			index_end += 1
		else:
			var next_item_size: int = _get_item_size(index_end)
			index_end += next_item_size

		if index_end - index_begin == item_size:
			return true

		if index_end - index_begin > item_size:
			return false

	return false


func get_item(slot_index: int) -> ItemStats:
	var id: int = _slots[slot_index]
	if id< 0:
		return null

	for item in items:
		if item.id_in_slot == id:
			return item

	return null


func put_item(item: ItemStats, start_index: int) -> void:
	item.id_in_slot = _get_next_item_id()
	items.append(item)
	item.owner = self
	for i in range(0, item.item_size):
		_slots[start_index + i] = item.id_in_slot

	_raise_stats_changed()


func remove_item(item: ItemStats) -> void:
	var start_index: int = _slots.find(item.id_in_slot)
	print("remove: %s | %s" % [start_index, item.item_size])
	for i in range(0, item.item_size):
		_slots[start_index + i] = -1

	items.erase(item)
	item.owner = null
	_raise_stats_changed()


func insert_item(target_item: ItemStats, to_index: int) -> void:
	if target_item.owner != null:
		target_item.owner.remove_item(target_item)

	items.append(target_item)
	target_item.owner = self
	target_item.id_in_slot = _get_next_item_id()

	var backup := PackedInt32Array()
	for i in range(0, target_item.item_size):
		backup.append(target_item.id_in_slot)

	# move other
	var item_size: int = target_item.item_size
	var move_start_index: int
	if _slots[to_index] == -1:
		move_start_index = to_index
	else:
		move_start_index = _slots.find(_slots[to_index])

	for i in range(move_start_index, _slots.size()):
		var item_id := _slots[i]
		if item_id < 0 and item_size > 0:
			item_size -=1
			continue

		backup.append(item_id)

	for i in range(move_start_index, _slots.size()):
		_slots[i] = backup[i - move_start_index]

	print(get_name(), _slots)
	_raise_stats_changed()


func _raise_stats_changed() -> void:
	stats_changed.emit()


func _get_next_item_id() -> int:
	var max_value: int = 0
	for i in range(0, _slots.size()):
		if _slots[i] > max_value:
			max_value = _slots[i]

	return max_value + 1


func _get_item_size(start_index: int) ->int:
	var result: int  = 1
	var item_id: int = _slots[start_index]
	for i in range(start_index + 1, _slots.size()):
		if _slots[i] ==item_id:
			result += 1
		else:
			break

	return result
