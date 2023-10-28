extends Control

class_name Inventory

@export var inventory_size:int = 10
var items:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in inventory_size:
		var cell = preload("res://ui/InventoryCell.tscn").instantiate()
		$cells.add_child(cell)

func try_add_item(item:Item) -> bool:
	if items.size() >= inventory_size:
		return false
	items.append(item)
	update_cells()
	return true
	
func pop_item() -> Item:
	if items.is_empty():
		return null
	
	var popped_item:Item = items.pop_front()
	update_cells()
	return popped_item

func _physics_process(delta):
	pass
	
func update_cells():
	var i = 0
	var cell:InventoryCell
	
	var value_sum = 0
	
	for item in items:
		cell = $cells.get_child(i)
		if cell.item != item:
			cell.item = item
		
		value_sum += item.value
		i += 1
			
	for j in range(i,inventory_size):
		cell = $cells.get_child(i)
		if cell.item:
			cell.item = null
			
		$value_label.text = "Value %s" % value_sum 
