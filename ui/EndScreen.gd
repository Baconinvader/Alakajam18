extends Control


func _ready():
	g.in_game = false
	
	if g.time_left <= 0:
		$gameover_label.text = "Game Over (Out of Time)"
	
	elif g.player.health <= 0:
		$gameover_label.text = "Game Over (Out of Health)"
	
	else:
		$gameover_label.text = "Game Over"
	
	var reveal_tween:Tween = create_tween()
	
	reveal_tween.tween_property($items_label, "visible", true, 0.0)
	
	for item in g.inventory.sold_items:
		var cell:InventoryCell = preload("res://ui/InventoryCell.tscn").instantiate()
		cell.item = item
		
		reveal_tween.tween_interval(1.0 / g.inventory.sold_items.size())
		var add_child_bind = $sold_items.add_child.bindv([cell])
		reveal_tween.tween_callback(add_child_bind)
		
	reveal_tween.tween_interval(1.0)
	reveal_tween.tween_property($money_label, "text", "Final Earnings: $%s" % g.player.money, 0.0)
	reveal_tween.tween_property($money_label, "visible", true, 0.5)
	

func _on_start_button_pressed():
	g.overlay.start(Color.TRANSPARENT, Color.BLACK, 1.0)
	g.overlay.connect("finished", _on_overlay_finished, CONNECT_ONE_SHOT)
	Sound.play_sound("button1")
	
func _on_overlay_finished():
	g.overlay.start(Color.BLACK, Color.TRANSPARENT, 1.0)
	
	var start_screen = preload("res://ui/StartScreen.tscn").instantiate()
	g.main.get_node("UI").add_child(start_screen)
	queue_free()
