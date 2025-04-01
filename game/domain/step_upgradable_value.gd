class_name StepUpgradableValue
extends UpgradableValue

@export var base_value: int = 1;
@export var step_value: int = 1;

func get_value(level: int) -> int:
	return base_value + (level - 1) * step_value;
	
