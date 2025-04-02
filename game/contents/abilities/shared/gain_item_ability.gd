extends ItemAbility

@export var _value: UpgradableValue
@export var _item_size: Item.Size
@export var _item_tags: Array[ItemTag]

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	var available_items: Array[ItemStats] = character.item_pool.filter_with_tags(_item_tags)

	if _item_size != Item.Size.Invalid:
		available_items = available_items.filter(func(item: ItemStats): return item.item_size == _item_size)

	var item: ItemStats     = available_items.pick_random()
	var instance: ItemStats = item.create_instance()

	instance.level = owner.level
	instance.price = instance.get_base_price()
	character.add_new_item(instance)


func get_description() -> String:
	var size_tag: ItemTag     = ItemStats.get_size_tag(_item_size)
	var param: Array[Variant] = []
	param.append(size_tag)
	param.append_array(_item_tags)
	return description.format(param)
