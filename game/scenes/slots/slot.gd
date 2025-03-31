class_name Slot
extends Control

const Small_Item_UI  := preload("res://game/scenes/items/small_item_ui.tscn")
const Medium_Item_UI := preload("res://game/scenes/items/medium_item_ui.tscn")
const Large_Item_UI  := preload("res://game/scenes/items/large_item_ui.tscn")
@export var stats: SlotStats: set = _set_stats
@export var slot_size: Vector2 = Vector2(150, 300)
@export var debugShape: CollisionShape2D

var _start_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _set_stats(value: SlotStats) -> void:
	if stats == value:
		return

	if stats != null:
		stats.stats_changed.disconnect(update_stats)

	stats = value

	if stats == null:
		return

	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_slot()


func update_slot() -> void:
	if not is_node_ready():
		await ready

	for child in self.get_children():
		child.queue_free()

	for item in stats.items:
		var item_ui: ItemUI = _create_item_ui(item)
		add_child(item_ui)

	var require_size: Vector2 = stats.slot_quantity * slot_size
	var start_x: float        = self.size.x / 2 - require_size.x / 2
	_start_position = Vector2(start_x, 0)

	update_stats()


func update_stats() -> void:
	update_items_position()
	_sort_children()


func _create_item_ui(item_stats: ItemStats) -> ItemUI:
	var item_ui_scene: PackedScene = _get_item_ui_scene(item_stats.item_size)
	var item_ui: ItemUI            = item_ui_scene.instantiate() as ItemUI
	item_ui.stats = item_stats
	return item_ui


func _get_item_ui_scene(item_size: ItemStats.ItemSize) -> PackedScene:
	match item_size:
		ItemStats.ItemSize.Small:
			return Small_Item_UI
		ItemStats.ItemSize.Medium:
			return Medium_Item_UI
		ItemStats.ItemSize.Large:
			return Large_Item_UI
		_:
			return null


func reset_slots() -> void:
	_sort_children()
	stats.remap_items_id()


func remove_item(item: ItemUI) -> void:
	stats.remove_item(item.stats)


func get_start_slot_index(item: ItemUI) -> int:
	return stats.get_start_index(item.stats)


func put_item(item: ItemUI, to_index: int) ->void:
	print("put_item: %s..%s" % [to_index, item.item_size])
	item.reparent(self)
	stats.put_item(item.stats, to_index)


func _sort_children() -> void:
	var children: Array[Node] = get_children().filter(func (x): return x is ItemUI)
	# 按 position.x 从小到大排序
	children.sort_custom(func(a, b): return a.position.x < b.position.x)
	# 重新排列子节点顺序（调整场景树中的顺序）
	for idx in range(children.size()):
		move_child(children[idx], idx)


func update_items_position() -> void:
	for child in self.get_children():
		if child.is_queued_for_deletion():
			continue

		if not child is ItemUI:
			continue

		var slot_intex := stats.get_start_index(child.stats)
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

	var can_insert := stats.has_enough_space_after(slot_index, drop_item.stats)

	if can_insert:
		return true

	if drop_item.get_parent() == self:
		return false

	return stats.has_contiguous_space_after(slot_index, drop_item.stats)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var origin_slot: Slot = data.item.get_parent() as Slot
	var target_slot: Slot = self
	var drop_item: ItemUI = data.item
	var target_position   = at_position - data.offset
	var slot_index: int   = _find_nearest_index(target_position)

	if origin_slot == target_slot:
		_change_location(drop_item, slot_index)
	else:
		if stats.has_enough_space_after(slot_index, drop_item.stats):
			_change_location(drop_item, slot_index)
		else:
			_swap_items(slot_index, drop_item)


func _change_location(drop_item: ItemUI, to_index: int) -> void:
	if drop_item.get_parent() != self:
		drop_item.reparent(self)

	stats.insert_item(drop_item.stats, to_index)
	update_items_position()
	reset_slots()
	print("index : %s" % to_index)
	print("item.position : %s" % drop_item.position)


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
		var item_stats: ItemStats = stats.get_item(current_index)
		if item_stats != null:
			var item_ui: ItemUI = _get_item(item_stats)
			result.append(item_ui)
			current_index += item_stats.item_size
		else:
			current_index += 1

	return result


func _get_item(item_stats: ItemStats) -> ItemUI:
	for child in self.get_children():
		if not child is ItemUI:
			continue

		var item: ItemUI = child as ItemUI
		if item.stats == item_stats:
			return item

	return null


func _find_nearest_index(at_position: Vector2) -> int:
	if at_position.x < _start_position.x:
		return 0

	var slot_quantity: int = stats.slot_quantity

	if at_position.x > _start_position.x + slot_quantity * slot_size.x:
		return slot_quantity - 1

	return roundi((at_position.x - _start_position.x) / slot_size.x)


func _calculate_position(index: int) -> Vector2:
	return _start_position + Vector2(index * slot_size.x, 0)



	
	
	
