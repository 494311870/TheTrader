class_name CustomUpgradableValue
extends UpgradableValue

@export var values: PackedInt32Array = [1, 2, 3, 4]


func get_value(level: int) -> int:
	var index: int = level - 1
	index = clamp(index, 0, values.size() - 1)
	return values[index]
