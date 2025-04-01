﻿class_name ItemStats
extends Resource

const Small_Tag  := preload("res://game/contents/tags/small.tres")
const Medium_Tag := preload("res://game/contents/tags/medium.tres")
const Large_Tag  := preload("res://game/contents/tags/large.tres")
signal stats_changed
@export var art: Texture2D
@export var name: String
@export var description: String
@export var item_size: Item.Size = Item.Size.Small
@export var level: Item.Level
@export var price: int: set = _set_price
@export var bonus: int: set = _set_bonus
@export var tags: Array[ItemTag]
@export var abilities: Array[ItemAbility]

var id: String: get = _get_id
var id_in_slot: int
var owner: SlotStats
var coin_not_enough: bool


func create_instance() -> ItemStats:
	var instance: ItemStats = duplicate()
	return instance


func _get_id() -> String:
	return name    # TODO: implement


func _set_price(value: int) -> void:
	price = value
	stats_changed.emit()


func _set_bonus(value: int) -> void:
	bonus = value
	stats_changed.emit()


func has_tag(tag: ItemTag) -> bool:
	if _get_size_tag() == tag:
		return true

	return tags.has(tag)


func get_tags() -> Array[ItemTag]:
	var result: Array[ItemTag] = []
	result.append(_get_size_tag())
	result.append_array(tags)
	return result


func _get_size_tag() -> ItemTag:
	match item_size:
		Item.Size.Small: return Small_Tag
		Item.Size.Medium: return Medium_Tag
		Item.Size.Large: return Large_Tag
		_: return null


func activate_abilities() -> void:
	if not abilities:
		return

	for ability in abilities:
		ability.owner = self
		ability.activate()


func deactivate_abilities() -> void:
	if not abilities:
		return

	for ability in abilities:
		ability.deactivate()
		ability.owner = null


func trigger_abilities(trigger: Item.Trigger) -> void:
	if not self.abilities:
		return

	for ability: ItemAbility in self.abilities:
		if ability.trigger == trigger:
			ability.owner = self
			ability.raise_trigger()


func get_adjacent_items() -> Array[ItemStats]:
	return owner.get_adjacent_items(self)


func get_other_items() -> Array[ItemStats]:
	var result: Array[ItemStats] = []
	result.append_array(owner.items)
	result.erase(self)
	return result