extends Control

@onready var start: Control = %Start
@onready var animation_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	start.visible = false
	start.modulate = Color.TRANSPARENT

	animation_player.play("default")
	await animation_player.animation_finished

	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.5)
	tween.tween_callback(start.show)
	tween.tween_property(start, "modulate", Color.WHITE, 1.0)


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://game/scenes/main/main.tscn")
