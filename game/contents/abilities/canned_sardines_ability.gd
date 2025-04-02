extends ItemAbility

@export var _value: UpgradableValue
@export var _item_amount: int = 7

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	var items: Array[ItemStats] = get_desktop_items()
	owner.bonus = value if items.size() >= _item_amount else 0


func get_description() -> String:
	return description.format([_item_amount, value])
