class_name ItemGenerator
extends Resource

@export var generate_amount: int = 3
@export var pool: ItemPool
@export var filter_tags: Array[ItemTag]


func generate() -> Array[ItemStats]:
	var result: Array[ItemStats] = []

	var available_items: Array[ItemStats] = pool.filter_with_tags(filter_tags)

	for i in range(self.generate_amount):
		if available_items.is_empty():
			break
		var item: ItemStats = available_items.pick_random()
		result.append(item.create_instance())
		available_items.erase(item)

	return result

	