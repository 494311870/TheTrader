class_name PlayerUI
extends Control

signal backpack_clicked
signal before_drop_item(item_ui: ItemUI)
signal show_item_tool_tip_requested(item_ui: ItemUI)
signal hide_item_tool_tip_requested
@export var stats: CharacterStats: set = _set_stats

@onready var backpack_button: Button = %BackpackButton
@onready var slot_ui: SlotUI = %SlotUI
@onready var income_label: Label = %IncomeLabel
@onready var coin_label: Label = %CoinLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	backpack_button.pressed.connect(_on_backpack_button_pressed)
	slot_ui.slot.before_drop_item.connect(_slot_on_before_drop_item)
	slot_ui.slot.show_tool_tip_requested.connect(_show_item_tool_tip)
	slot_ui.slot.hide_tool_tip_requested.connect(_hide_item_tool_tip)


func _set_stats(value: CharacterStats) -> void:
	if stats != null:
		stats.stats_changed.disconnect(_update_stats)
		stats.new_item_added.disconnect(_on_new_item_added)
		

	stats = value
	if stats == null:
		return

	if not stats.stats_changed.is_connected(_update_stats):
		stats.stats_changed.connect(_update_stats)
		stats.new_item_added.connect(_on_new_item_added)

	if not is_node_ready():
		await ready

	slot_ui.stats = stats.desktop
	_update_stats()


func _update_stats() -> void:
#	income_label.text = str(stats.income)
	coin_label.text = str(stats.coin)

func _on_new_item_added(item: ItemStats) -> void:
	if item.owner == slot_ui.stats:
		slot_ui.add_item(item)

func _on_backpack_button_pressed() -> void:
	backpack_clicked.emit()


func _slot_on_before_drop_item(item_ui: ItemUI) -> void:
	before_drop_item.emit(item_ui)


func _show_item_tool_tip(item_ui: ItemUI) -> void:
	show_item_tool_tip_requested.emit(item_ui)


func _hide_item_tool_tip()-> void:
	hide_item_tool_tip_requested.emit()