extends ItemAbility

@export var _value: UpgradableValue
@export var _difference: UpgradableValue

var value:
	get: return _value.get_value(owner.level)

var difference:
	get: return _difference.get_value(owner.level)


func _on_trigger()-> void:
	_check_difference.call_deferred()

func _check_difference()-> void:
	var items: Array[ItemStats] = get_adjacent_items()
	owner.bonus = 0
	if items.size() == 2:
		if abs(items[0].price - items[1].price) == difference:
			owner.bonus = value
		
func get_description() -> String:
	return description.format([difference, value])
