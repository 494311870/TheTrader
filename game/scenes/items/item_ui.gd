class_name ItemUI
extends Control

enum FailCode{
	Not_Enough_Coin = 0
}
signal drag_failed(fail_code: FailCode)
signal level_up_requested(item_ui: ItemUI)
signal show_tool_tip_requested(item_ui: ItemUI)
signal hide_tool_tip_requested()
@export var item_size: Item.Size
@export var stats: ItemStats: set = _set_stats

@onready var visuals: ItemVisuals = %ItemVisuals

var _is_dragging: bool = false


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _notification(what: int) -> void:

	if what == NOTIFICATION_DRAG_BEGIN:
		self.set_mouse_filter(MOUSE_FILTER_IGNORE)

	if what == NOTIFICATION_DRAG_END:
		self.set_mouse_filter(MOUSE_FILTER_STOP)
		if _is_dragging:
			show()


func _get_drag_data(at_position: Vector2) -> Variant:
	if stats.coin_not_enough:
		drag_failed.emit(FailCode.Not_Enough_Coin)
		return null

#	if stats.is_level_up:
#		level_up_requested.emit(self)
#		return null

	_is_dragging = true
	hide_tool_tip_requested.emit()

	var item: Control = duplicate()
	item.position = -at_position
	item.z_index = 10

	var preview := Control.new()
	preview.add_child(item)

	hide()
	set_drag_preview(preview)

	return {"item": self, "offset": at_position}


func _set_stats(value: ItemStats) -> void:
	stats = value

	if not is_node_ready():
		await ready

	visuals.stats = value


func _on_mouse_entered()->void:
	show_tool_tip_requested.emit(self)


func _on_mouse_exited()->void:
	hide_tool_tip_requested.emit()