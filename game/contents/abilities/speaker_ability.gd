extends ItemAbility

@export var _value: UpgradableValue

var _previous_item: ItemStats

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	var target_item: ItemStats = get_right_item()
	
	if target_item == _previous_item:
		return
	
	if _previous_item:
		_previous_item.price -= value
		_previous_item = null
	
	if not target_item:
		return
		
	target_item.price += value
	_previous_item = target_item


func get_description() -> String:
	return description.format([value])
