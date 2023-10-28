extends Control

class_name InventoryCell

var item:Item: set=_set_item

func _set_item(val:Item):
	item = val
	if val:
		$item.visible = true
		$item.texture = val.texture
	else:
		$item.visible = false
