class_name TagUI
extends PanelContainer

@export var tag: ItemTag: set = _set_tag

@onready var _label: Label = %Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set_tag(value: ItemTag) -> void:
	tag = value
	if not is_node_ready():
		await ready
	if value == null:
		return
		
	_label.text = tag.name
		
	

