extends Control

class_name Inventory

@export var inventory_size:int = 5
var keys:int = 0:set=_set_keys
var items:Array = []

var sold_items:Array[Item] = []

func _set_keys(val:int):
	if val > keys:
		Sound.play_sound("pickup")
	keys = val

func reset():
	keys = 0
	items.clear()
	sold_items.clear()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in inventory_size:
		var cell = preload("res://ui/InventoryCell.tscn").instantiate()
		$cells.add_child(cell)

func try_add_item(item:Item) -> bool:
	if items.size() >= inventory_size:
		return false
	items.append(item)
	Sound.play_sound("pickup")
	update_cells()
	
	if items.size() == inventory_size:
		Indicator.spawn_indicator("Inventory Full", g.player, Color.ORANGE)
	
	return true
	
func pop_indicator(item_name:String):
	Indicator.spawn_indicator("-%s"% item_name, g.player, Color.RED)
	
func pop_item(destroy:bool=false) -> Item:
	if items.is_empty():
		return null
	
	var popped_item:Item = items.pop_front()
	if destroy:
		var indicator_tween:Tween = create_tween()
		var spawn_indicator_call = pop_indicator.bind(popped_item.item_name)
		indicator_tween.tween_interval(1.0)
		indicator_tween.tween_callback(spawn_indicator_call)

	else:
		sold_items.append(popped_item)
	update_cells()
	return popped_item


func _physics_process(delta):
	$keys/label.text = "x%s" % keys
	
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
