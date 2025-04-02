class_name RunStats
extends Resource

signal stats_changed
@export var days: int
@export var next_day_target: int


func next_day()-> void:
	days += 1
	if days % 24 == 0:
		next_day_target += days * 3
	elif days % 8 == 0:
		next_day_target += days * 2
	else:
		next_day_target += days * 1

	stats_changed.emit()
	
		
