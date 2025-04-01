extends Control

signal restart_requested
@onready var _title: Label = %Title


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func show_result(result: String):
	_title.text = result
	show()


func _on_restart_button_pressed():
	restart_requested.emit()
