extends ItemAbility

@export var _value: UpgradableValue
@export var _item_tag: ItemTag

var value:
	get: return _value.get_value(owner.level)


func _on_trigger() -> void:
	var items: Array[ItemStats] = get_adjacent_items()
	var count: int              = items.filter(_has_tag).size()
	owner.bonus = value if count == 2 else 0


func _has_tag(item: ItemStats) -> bool:
	return item.has_tag(_item_tag)


func get_description() -> String:
	return description.format([_item_tag, value])
