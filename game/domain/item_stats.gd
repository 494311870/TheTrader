class_name ItemStats
extends Resource
const Small_Tag: ItemTag  = preload("res://game/contents/tags/small.tres")
const Medium_Tag: ItemTag = preload("res://game/contents/tags/medium.tres")
const Large_Tag: ItemTag  = preload("res://game/contents/tags/large.tres")
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
var is_level_up: bool: set = _set_is_level_up


func create_instance() -> ItemStats:
	var instance: ItemStats = duplicate()

	if self.abilities:
		instance.abilities = duplicate_abilities()
		for ability in instance.abilities:
			ability.owner = instance

	return instance


func duplicate_abilities() -> Array[ItemAbility]:
	if not abilities:
		return []

	var result: Array[ItemAbility] = []
	for ability: ItemAbility in self.abilities:
		assert(ability != null, "%s has null ability" % self.resource_path)
		var instance: ItemAbility = ability.duplicate()
		result.append(instance)

	return result


func _get_id() -> String:
	return name    # TODO: implement


func _set_price(value: int) -> void:
	price = max(0, value)
	stats_changed.emit()


func _set_bonus(value: int) -> void:
	bonus = value
	stats_changed.emit()


func _set_is_level_up(value: bool) -> void:
	is_level_up = value
	stats_changed.emit()


func has_tag(tag: ItemTag) -> bool:
	if ItemStats.get_size_tag(self.item_size) == tag:
		return true

	return tags.has(tag)


func get_tags() -> Array[ItemTag]:
	var result: Array[ItemTag] = []
	result.append(ItemStats.get_size_tag(self.item_size))
	result.append_array(tags)
	return result


static func get_size_tag(item_size: Item.Size) -> ItemTag:
	match item_size:
		Item.Size.Small: return Small_Tag
		Item.Size.Medium: return Medium_Tag
		Item.Size.Large: return Large_Tag
		_: return null


func get_base_price() -> int:
	var item_level: int = self.level
	var size: int       = self.item_size
	return size * 2 * item_level


func activate_abilities(character: CharacterStats) -> void:
	if not abilities:
		return

	for ability in abilities:
		ability.character = character
		ability.activate()


func deactivate_abilities() -> void:
	if not abilities:
		return

	for ability in abilities:
		ability.deactivate()


func trigger_abilities(trigger: Item.Trigger) -> void:
	if not self.abilities:
		return

	for ability: ItemAbility in self.abilities:
		if ability.trigger == trigger:
			ability.raise_trigger()


func level_up():
	self.level = self.level + 1 as Item.Level
	price += self.item_size


func get_adjacent_items() -> Array[ItemStats]:
	return owner.get_adjacent_items(self)


func get_other_items() -> Array[ItemStats]:
	var result: Array[ItemStats] = []
	result.append_array(owner.items)
	result.erase(self)
	return result






	
	
