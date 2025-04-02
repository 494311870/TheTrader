class_name TraderUI
extends Control

signal leave_requested
signal item_level_up_requested(item_ui: ItemUI)
signal show_item_tool_tip_requested(item_ui: ItemUI)
signal hide_item_tool_tip_requested
@export var stats: TraderStats: set = _set_stats
@export var customer: CharacterStats: set = _set_customer

@onready var _trader: Trader = %Trader
@onready var slot_ui: SlotUI = %SlotUI
@onready var trader_art: TextureRect = %TraderArt
@onready var refresh_price_label: Label = %RefreshPriceLabel
@onready var tip_container: Control = %TipContainer
@onready var tip_label: Label = %TipLabel

var _tip_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tip_container.hide()

	slot_ui.slot.drag_item_failed.connect(_on_drag_item_failed)
	slot_ui.slot.item_level_up_requested.connect(_on_item_level_up_requested)
	slot_ui.slot.show_tool_tip_requested.connect(_show_item_tool_tip)
	slot_ui.slot.hide_tool_tip_requested.connect(_hide_item_tool_tip)


func _set_stats(value: TraderStats) -> void:
	stats = value

	if not is_node_ready():
		await ready

	_trader.stats = stats
	slot_ui.stats = stats.desktop
	_update_trader()


func _update_trader() -> void:
	trader_art.texture = stats.art


func _set_customer(value: CharacterStats) -> void:
	customer = value
	if not is_node_ready():
		await ready

	_trader.customer = value


func show_scene() -> void:
	if not is_node_ready():
		await ready

	_trader.show_scene()
	_update_refresh_price()
	show()


func _on_drag_item_failed(fail_code: ItemUI.FailCode) ->void:
	match fail_code:
		ItemUI.FailCode.Not_Enough_Coin:
			show_tip("你钱不够。")


func _on_item_level_up_requested(item_ui: ItemUI)->void:
	item_level_up_requested.emit(item_ui)


func show_tip(text: String) -> void:
	tip_label.text = text
	tip_container.modulate = Color.WHITE
	tip_container.show()

	if _tip_tween:
		_tip_tween.kill()

	_tip_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tip_tween.tween_interval(1.0)
	_tip_tween.tween_property(tip_container, "modulate", Color.TRANSPARENT, 1.0)
	_tip_tween.tween_callback(tip_container.hide)


func _on_refresh_button_pressed():
	if _trader.refresh_price > customer.coin:
		show_tip("你钱不够。")

	_update_refresh_price.call_deferred()


func _update_refresh_price():
	refresh_price_label.text = str(_trader.refresh_price)


func _on_leave_button_pressed():
#	hide()
	leave_requested.emit()


func _on_backpack_clicked():
	visible = not visible


func _show_item_tool_tip(item_ui: ItemUI) -> void:
	show_item_tool_tip_requested.emit(item_ui)


func _hide_item_tool_tip()-> void:
	hide_item_tool_tip_requested.emit()

