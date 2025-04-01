extends Control

signal restart_requested
signal next_requested
@onready var _next: Control = %Next
@onready var _restart: Control = %Restart
@onready var _coin_label: Label = %CoinLabel
@onready var _bonus_label: Label = %BonusLabel
@onready var _sum_label: Label = %SumLabel
@onready var _target_label: Label = %TargetLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func show_settlement(run: RunStats, character: CharacterStats)->void:
	var bouns: int = character.calculate_bonus()
	var sum: int   = character.coin + bouns
	_coin_label.text = str(character.coin)
	_bonus_label.text = str(bouns)
	_sum_label.text = str(sum)
	_target_label.text = str(run.next_day_target)

	if sum >= run.next_day_target:
		_next.visible = true
		_restart.visible = false
	else:
		_next.visible = false
		_restart.visible = true
		
	show()


func _on_restart_button_pressed()->void:
	hide()
	restart_requested.emit()


func _on_next_button_pressed()->void:
	hide()
	next_requested.emit()
