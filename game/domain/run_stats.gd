class_name RunStats
extends Resource

signal stats_changed
@export var days: int
@export var next_day_target: int

var _target: int


func next_day()-> void:
	days += 1
	if days % 24 == 0:
		_target *= 2
	elif days % 8 == 0:
		_target += days * 2
	else:
		_target += days * 1
	
	next_day_target += _target

	stats_changed.emit()
	
		
