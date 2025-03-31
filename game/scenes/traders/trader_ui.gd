class_name TraderUI
extends Control

@export var stats: TraderStats: set = _set_stats

@onready var slot_ui: SlotUI = %SlotUI
@onready var trader_art: TextureRect = %TraderArt
@onready var tip_container: Control = %TipContainer
@onready var tip_label: Label = %TipLabel

var _tip_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tip_container.hide()
	
	slot_ui.slot.drag_item_failed.connect(_on_drag_item_failed)


func _set_stats(value: TraderStats) -> void:
	stats = value

	if not is_node_ready():
		await ready

	slot_ui.stats = stats.desktop
	_update_trader()


func _update_trader() -> void:
	trader_art.texture = stats.art


func show_scene() -> void:
	show()


func _on_drag_item_failed(fail_code: ItemUI.FailCode) ->void:
	match fail_code:
		ItemUI.FailCode.Not_Enough_Coin:
			_show_tip("你钱不够。")


func _show_tip(text: String) -> void:
	tip_label.text = text
	tip_container.modulate = Color.WHITE
	tip_container.show()
	

	if _tip_tween:
		_tip_tween.kill()

	_tip_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tip_tween.tween_interval(1.0)
	_tip_tween.tween_property(tip_container, "modulate", Color.TRANSPARENT, 1.0)
	_tip_tween.tween_callback(tip_container.hide)
	