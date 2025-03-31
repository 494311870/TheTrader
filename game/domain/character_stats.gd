class_name CharacterStats
extends Resource

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
