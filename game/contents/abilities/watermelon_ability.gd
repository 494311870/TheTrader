extends ItemAbility

@export var _price: UpgradableValue

var price: int:
	get: return _price.get_value(owner.level)


func _on_trigger():
	owner.price += price


func get_description() -> String:
	return description.format([price])