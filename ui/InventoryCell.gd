extends Control

class_name InventoryCell

var item:Item: set=_set_item

func _set_item(val:Item):
	item = val
	if val:
		$item.visible = true
		$item.texture = val.texture
		Indicator.spawn_indicator("+%s" % item.item_name, g.player, Color.GREEN)
	else:
		$item.visible = false
