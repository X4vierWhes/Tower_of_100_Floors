extends Resource
class_name ItemStats

var stats: Array = []

func set_item_stats(new_stats: Array) -> void:
	if new_stats:
		stats = new_stats

func get_item_stats() -> Array:
	return stats
