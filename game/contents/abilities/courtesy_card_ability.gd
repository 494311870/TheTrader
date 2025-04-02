extends ItemAbility

@export var _value: UpgradableValue

var value:
	get: return _value.get_value(owner.level)


func _on_trigger()-> void:
	var trader: TraderStats = character.current_trader
	for item: ItemStats in trader.desktop.items:
		item.price -= value


func get_description() -> String:
	return description.format([value])
