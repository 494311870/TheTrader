extends ItemAbility

@export var _value: UpgradableValue

var value: int:
	get: return _value.get_value(owner.level)

func _on_trigger()-> void:
	print("this happens once when trigger")


func get_description() -> String:
	return description.format([value])