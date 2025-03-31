class_name CharacterStats
extends Resource

signal stats_changed
@export var desktop: SlotStats
@export var backpack: SlotStats
@export var coin: int
@export var income: int


func create_instance() -> CharacterStats:
	var instance: CharacterStats = duplicate()

	instance.desktop = SlotStats.new()
	instance.desktop.slot_quantity = 10
	instance.desktop.set_up_with_empty()

	instance.backpack = SlotStats.new()
	instance.backpack.slot_quantity = 10
	instance.backpack.set_up_with_empty()

	return instance


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
	
