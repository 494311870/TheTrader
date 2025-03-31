class_name Ability
extends Resource

var is_activated: bool

func activate() -> void:
	if is_activated:
		return

	is_activated = true
	_on_activate()


func deactivate() -> void:
	if not is_activated:
		return

	is_activated = false
	_on_deactivate()


func _on_activate() -> void:
	pass


func _on_deactivate() -> void:
	pass