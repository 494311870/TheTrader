extends ItemAbility

@export var _value: UpgradableValue
@export var _item_tag: ItemTag

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	var items: Array[ItemStats]        = get_desktop_items()
	var filter_items: Array[ItemStats] = items.filter(_has_tag)
	if not filter_items.is_empty():
		filter_items[0].price += value


func _has_tag(item: ItemStats) -> bool:
	if not _item_tag:
		return true
	return item.has_tag(_item_tag)


func get_description() -> String:
	return description.format([_item_tag, value])
