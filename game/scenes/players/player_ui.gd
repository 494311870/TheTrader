class_name PlayerUI
extends Control

signal backpack_clicked
signal before_drop_item(item_ui: ItemUI)
@export var stats: CharacterStats: set = _set_stats

@onready var backpack_button: Button = %BackpackButton
@onready var slot_ui: SlotUI = %SlotUI
@onready var income_label: Label = %IncomeLabel
@onready var coin_label: Label = %CoinLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	backpack_button.pressed.connect(_on_backpack_button_pressed)
	slot_ui.slot.before_drop_item.connect(_slot_on_before_drop_item)


func _set_stats(value: CharacterStats) -> void:
	if stats != null:
		stats.stats_changed.disconnect(_update_stats)

	stats = value
	if stats == null:
		return

	if not stats.stats_changed.is_connected(_update_stats):
		stats.stats_changed.connect(_update_stats)

	if not is_node_ready():
		await ready

	slot_ui.stats = stats.desktop
	_update_stats()


func _update_stats() -> void:
	income_label.text = str(stats.income)
	coin_label.text = str(stats.coin)


func _on_backpack_button_pressed() -> void:
	backpack_clicked.emit()


func _slot_on_before_drop_item(item_ui: ItemUI) -> void:
	before_drop_item.emit(item_ui)

		
