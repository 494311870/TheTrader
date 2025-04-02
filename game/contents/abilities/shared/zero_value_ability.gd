extends ItemAbility

@export var _value: UpgradableValue

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	_set_price.call_deferred()


func _set_price()-> void:
	owner.price = 0


func get_description() -> String:
	return description
