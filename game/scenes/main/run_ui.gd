class_name RunUI
extends PanelContainer

@export var stats: RunStats: set = _set_stats

@onready var _days_label: Label = %DaysLabel
@onready var _target_label: Label = %TargetLabel


func _set_stats(value: RunStats) -> void:
	if stats == value:
		return

	if stats != null:
		stats.stats_changed.disconnect(_update_stats)

	stats = value

	if not stats.stats_changed.is_connected(_update_stats):
		stats.stats_changed.connect(_update_stats)	
		
	_update_stats()


func _update_stats() -> void:
	if not is_node_ready():
		await ready

	_days_label.text = str(stats.days)
	_target_label.text = str(stats.next_day_target)



