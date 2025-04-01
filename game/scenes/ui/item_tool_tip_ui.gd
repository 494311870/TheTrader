extends PanelContainer

const Ability_UI := preload("res://game/scenes/ui/ability_ui.tscn")
const Tag_UI     := preload("res://game/scenes/ui/tag_ui.tscn")
@onready var name_label: Label = %NameLabel
@onready var tags: Control = %Tags
@onready var abilities: Control = %Abilities

var _tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func show_item(item_ui: ItemUI)-> void:
	var item: ItemStats = item_ui.stats
	name_label.text = item.name
	_hide_all()
	for tag in item.get_tags():
		var tag_ui: TagUI = _get_tag()
		tag_ui.tag = tag
		tag_ui.show()
	for ability in item.abilities:
		var ability_ui: AbilityUI = _get_ability()
		ability_ui.ability = ability
		ability_ui.show()

	if _tween:
		_tween.kill()

	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_callback(show)
	_tween.tween_property(self, "modulate", Color.WHITE, 0.5)


func hide_tool_tip()-> void:
	if _tween:
		_tween.kill()

	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	_tween.tween_callback(hide)


func _hide_all():
	for tag in tags.get_children():
		if tag is TagUI:
			tag.hide()
	for ability in abilities.get_children():
		if ability is AbilityUI:
			ability.hide()


func _get_tag() -> TagUI:
	for tag in tags.get_children():
		if tag is TagUI and tag.visible == false:
			return tag

	var instance := Tag_UI.instantiate()
	tags.add_child(instance)
	return instance


func _get_ability() -> AbilityUI:
	for ability in abilities.get_children():
		if ability is AbilityUI and ability.visible == false:
			return ability

	var instance := Ability_UI.instantiate()
	abilities.add_child(instance)
	return instance