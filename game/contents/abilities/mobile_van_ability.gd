extends ItemAbility

@export var _value: UpgradableValue

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	owner.bonus += 1


func get_description() -> String:
	return description.format([value])
