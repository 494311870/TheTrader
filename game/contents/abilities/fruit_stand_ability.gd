extends ItemAbility

@export var item_tag: ItemTag


func _on_trigger():
	var items: Array[ItemStats] = owner.get_other_items()
	var count: int              = items.filter(_has_tag).size()
	owner.bonus = count


func _has_tag(item: ItemStats) -> bool:
	return item.has_tag(item_tag)

func get_description() -> String:
	return description.format([item_tag])
	