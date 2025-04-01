class_name ItemVisuals
extends Control

const Bronze_Border: Texture2D  = preload("res://game/art/borders/bronze.png")
const Silver_Border: Texture2D  = preload("res://game/art/borders/silver.png")
const Gold_Border: Texture2D    = preload("res://game/art/borders/gold.png")
const Diamond_Border: Texture2D = preload("res://game/art/borders/diamond.png")
@export var stats: ItemStats: set = _set_stats

@onready var _icon: TextureRect = %Icon
@onready var _price_label: Label = %PriceLabel
@onready var _income: Control = %Income
@onready var _income_label: Label = %IncomeLabel
@onready var _border: NinePatchRect = %Border
@onready var _animation_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set_stats(value: ItemStats) -> void:
	if stats == value:
		return

	if stats != null:
		stats.stats_changed.disconnect(update_stats)

	stats = value

	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_item()


func update_stats() -> void:
	if not is_node_ready():
		await ready

	_price_label.text = str(stats.price)
	_income.visible = stats.bonus > 0
	_income_label.text = str(stats.bonus)
	_border.texture = get_border_texture(stats.level)

	if stats.is_level_up:
		_animation_player.play("level_up")


func update_item() -> void:

	if not is_node_ready():
		await ready

	_icon.texture = stats.art
	_animation_player.stop()

	update_stats()


func get_border_texture(level: Item.Level)-> Texture2D:
	match level:
		Item.Level.Bronze:
			return Bronze_Border
		Item.Level.Silver:
			return Silver_Border
		Item.Level.Gold:
			return Gold_Border
		Item.Level.Diamond:
			return Diamond_Border
		Item.Level.Legendary:
			return null
		_:
			return null
