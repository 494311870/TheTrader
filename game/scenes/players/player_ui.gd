class_name PlayerUI
extends Control

signal backpack_clicked
@export var stats: CharacterStats: set = _set_stats

@onready var backpack_button: Button = %BackpackButton
@onready var slot_ui: SlotUI = %SlotUI


# Called when the node enters the scene tree for the first time.
func _ready():
	backpack_button.pressed.connect(_on_backpack_button_pressed)


func _set_stats(value: CharacterStats) -> void:
	stats = value

	if not is_node_ready():
		await ready

	slot_ui.stats = stats.desktop


func _on_backpack_button_pressed() -> void:
	backpack_clicked.emit()


