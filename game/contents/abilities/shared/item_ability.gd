class_name ItemAbility
extends Ability

@export var trigger: Item.Trigger

var owner: ItemStats


func raise_trigger() -> void:
	_on_trigger()


func _on_trigger()-> void:
	pass	