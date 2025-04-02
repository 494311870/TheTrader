class_name ItemGenerator
extends Resource

@export var generate_amount: int = 3
@export var pool: ItemPool
@export var filter_tags: Array[ItemTag]


func generate(is_valid: Callable) -> Array[ItemStats]:
	var result: Array[ItemStats] = []

	var available_items: Array[ItemStats] = pool.filter_with_tags(filter_tags)\
											.filter(is_valid)
	
	var count: int       = self.generate_amount
	var remain_size: int = SlotStats.Max_Slot_Quantity
	while count > 0:
		if available_items.is_empty():
			break
		var item: ItemStats = available_items.pick_random()
		available_items.erase(item)
		if remain_size < item.item_size:
			continue

		result.append(item.create_instance())
		remain_size -= item.item_size
		count -=1

	return result

	
