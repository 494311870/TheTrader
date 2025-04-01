extends ItemAbility

@export var _item_tag: ItemTag
@export var _bonus: UpgradableValue

var bonus: int:
	get: return _bonus.get_value(owner.level)


func _on_trigger():
	var items: Array[ItemStats] = owner.get_other_items()
	var count: int              = items.filter(_has_tag).size()
	owner.bonus = count * bonus


func _has_tag(item: ItemStats) -> bool:
	return item.has_tag(_item_tag)


func get_description() -> String:
	return description.format([_item_tag,bonus])
	
