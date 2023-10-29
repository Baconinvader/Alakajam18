extends Control


func _ready():
	g.in_game = false
	
	$money.text = "Money: %s" % g.player.money
	for item in g.inventory.sold_items:
		var cell:InventoryCell = preload("res://ui/InventoryCell.tscn").instantiate()
		cell.item = item
		$sold_items.add_child(cell)

func _on_start_button_pressed():
	g.overlay.start(Color.TRANSPARENT, Color.BLACK, 1.0)
	g.overlay.connect("finished", _on_overlay_finished, CONNECT_ONE_SHOT)
	
func _on_overlay_finished():
	g.overlay.start(Color.BLACK, Color.TRANSPARENT, 1.0)
	
	var start_screen = preload("res://ui/StartScreen.tscn").instantiate()
	g.main.get_node("UI").add_child(start_screen)
	queue_free()
