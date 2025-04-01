class_name AbilityUI
extends HBoxContainer

@export var ability: Ability: set = _set_ability

@onready var _label: Label = %Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set_ability(value: Ability) -> void:
	ability = value
	if not is_node_ready():
		await ready
		
	_label.text = ability.get_description()

