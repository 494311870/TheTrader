class_name CharacterStats
extends Resource

signal stats_changed
signal new_item_added(item: ItemStats)
@export var desktop: SlotStats
@export var backpack: SlotStats
@export var coin: int
@export var income: int

var current_trader: TraderStats


func create_instance() -> CharacterStats:
	var instance: CharacterStats = duplicate()

	instance.desktop = SlotStats.new()
	instance.desktop.slot_quantity = 10
	instance.desktop.set_up_with_empty()

	instance.backpack = SlotStats.new()
	instance.backpack.slot_quantity = 10
	instance.backpack.set_up_with_empty()

	return instance


func dispose():
	for item in desktop.items:
		item.deactivate_abilities()
	for item in backpack.items:
		item.deactivate_abilities()

	desktop.clear()
	backpack.clear()


func is_owner(item: ItemStats) -> bool:
	return item.owner == desktop or item.owner == backpack


func find_same_item(id: String) -> ItemStats:
	for item in desktop.items:
		if item.id == id:
			return item

	for item in backpack.items:
		if item.id == id:
			return item

	return null


func get_all_items() -> Array[ItemStats]:
	return desktop.items + backpack.items


func calculate_bonus() -> int:
	var result: int = 0
	for item in desktop.items:
		result += item.bonus

	return result


func gain_coins(value: int) -> void:
	if value <= 0:
		return

	coin += value
	stats_changed.emit()


func lose_coins(value: int) -> void:
	if value <= 0:
		return

	coin = max(coin - value, 0)
	stats_changed.emit()


func earn_income()-> void:
	#	gain_coins(income)
	pass


func increase_income(value: int) -> void:
	if value <= 0:
		return

	income += value
	stats_changed.emit()


func decrease_income(value: int) -> void:
	if value <= 0:
		return

	income = max(income - value, 0)
	stats_changed.emit()


func trigger_items_abilities(trigger: Item.Trigger):
	var items: Array[ItemStats] = get_all_items()
	for item in items:
		item.trigger_abilities(trigger)


func add_new_item(item: ItemStats) -> void:
	if desktop.get_space() >= item.item_size:
		desktop.insert_item(item, 0)
		new_item_added.emit(item)
	elif backpack.get_space() >= item.item_size:
		backpack.insert_item(item, 0)
		new_item_added.emit(item)
