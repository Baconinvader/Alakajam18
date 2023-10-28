extends Interactable

func _get_can_interact() -> bool:
	if g.inventory.items.is_empty():
		return false
	return true

func interact():
	super.interact()
		
	var item:Item
	var value_sum:int = 0
	while true:
		item = g.inventory.pop_item()
		if not item:
			break
		
		value_sum += item.value
		
	g.player.money += value_sum
			
