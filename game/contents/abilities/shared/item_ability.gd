class_name ItemAbility
extends Ability

@export var trigger: Item.Trigger

var owner: ItemStats
var character: CharacterStats


func raise_trigger() -> void:
	_on_trigger()


func _on_trigger()-> void:
	pass


func get_desktop_items() -> Array[ItemStats]:
	return character.desktop.items


func get_desktop_other_items() -> Array[ItemStats]:
	if owner.owner != character.desktop:
		return get_desktop_items()

	var result: Array[ItemStats] = get_desktop_items()
	result.erase(owner)
	return result


func get_all_items() -> Array[ItemStats]:
	return character.get_all_items()


func get_other_items() -> Array[ItemStats]:
	var result: Array[ItemStats] = character.get_all_items()
	result.erase(owner)
	return result


func get_adjacent_items() -> Array[ItemStats]:
	return owner.get_adjacent_items()


func get_right_item() -> ItemStats:
	var slot: SlotStats = owner.owner;
	return slot.get_right_item(owner)