class_name Trader
extends Node

@export var stats: TraderStats: set = _set_stats
@export var customer: CharacterStats: set = _set_customer

var refresh_price: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _set_stats(value: TraderStats) -> void:
	stats = value


func _set_customer(value: CharacterStats) -> void:
	if customer == value:
		return

	if customer != null:
		customer.stats_changed.disconnect(_on_customer_stats_changed)

	customer = value

	if not customer.stats_changed.is_connected(_on_customer_stats_changed):
		customer.stats_changed.connect(_on_customer_stats_changed)


func _on_customer_stats_changed()  -> void:
	if not stats:
		return

	for item in stats.desktop.items:
		item.coin_not_enough = customer.coin < item.price
		print("%s : coin_not_enough => %s" % [item.id, item.coin_not_enough])


func refresh_items() -> void:
	if refresh_price > customer.coin:
		return

	customer.lose_coins(refresh_price)
	refresh_price *= 2
	_refresh_items()


func show_scene() ->void:
	print("trader : show_scene")
	refresh_price = 2
	_refresh_items()


func _refresh_items() -> void:
	stats.refresh_desktop(_is_valid_item)
	for item in stats.desktop.items:
		var customer_item: ItemStats = self.customer.find_same_item(item.id)
		if customer_item:
			item.level = customer_item.level
			item.is_level_up = true
		else:
			item.level = Item.Level.Bronze

		item.price = item.get_base_price()


func _is_valid_item(item: ItemStats) -> bool:
	var customer_item: ItemStats = self.customer.find_same_item(item.id)
	if customer_item:
		return customer_item.level < Item.Level.Diamond

	return true
