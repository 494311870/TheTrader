extends Control

signal sell_requested(item_ui: ItemUI)


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = Color.TRANSPARENT


func _process(_delta: float) -> void:
	var viewport: Viewport = get_viewport()
	if not viewport.gui_is_dragging():
		return

	var data = viewport.gui_get_drag_data()
	if not _can_drop_data(Vector2.ZERO, data):
		return

	# 获取鼠标位置和屏幕尺寸
	var mouse_pos: Vector2   = viewport.get_mouse_position()
	var screen_height: float = get_viewport_rect().size.y

	# 计算透明度（越靠近顶部越不透明）
	var alpha: float = 1.0 - mouse_pos.y / screen_height
	alpha = clamp(alpha, 0.0, 1.0)

	# 应用透明度到节点颜色
	self.modulate.a = alpha


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		self.set_mouse_filter(MOUSE_FILTER_STOP)

	if what == NOTIFICATION_DRAG_END:
		self.set_mouse_filter(MOUSE_FILTER_IGNORE)
		self.modulate = Color.TRANSPARENT


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data == null:
		return false
	if not data.has("item"):
		return false

	var drop_item: ItemUI = data.item
	var origin_slot: Slot = drop_item.get_parent() as Slot

	# 不可以出售商店的物品
	if origin_slot.owner.get_meta("disable_drop", false):
		return false

	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var drop_item: ItemUI = data.item
	sell_requested.emit(drop_item)
	