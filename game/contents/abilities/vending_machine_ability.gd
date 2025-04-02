extends ItemAbility

@export var _value: UpgradableValue
@export var _item_size: Item.Size

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	var items: Array[ItemStats] = get_desktop_items()
	items = items.filter(func(item: ItemStats): return item.item_size == _item_size)
	owner.bonus = items.size() * value


func get_description() -> String:
	var size_tag: ItemTag     = ItemStats.get_size_tag(_item_size)
	return description.format([size_tag, value])
