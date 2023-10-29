extends Interactable

func _ready():
	g.player.position = position + $player_spawn_point.position

func _get_can_interact() -> bool:
	if g.inventory.items.is_empty():
		return false
	return true


func interact_indicator1(value_sum:int):
	Indicator.spawn_indicator("Items Value:" % value_sum, self, Color.GOLD)

func interact_indicator2(item_count, multiplier):
	Indicator.spawn_indicator("%s Items -> %sx Multiplier" % [item_count, multiplier], self, Color.GOLD)
	
func interact_indicator3(value_sum:int, multiplier):
	Indicator.spawn_indicator("+$%d" % int(value_sum*multiplier), self, Color.GOLD)

func interact():
	super.interact()
		
	var item:Item
	var value_sum:int = 0
	var item_count = 0
	while true:
		item = g.inventory.pop_item()
		if not item:
			break
		item_count += 1
		value_sum += item.value
		
	
	
	var multiplier:float = 1.0 + (0.2*item_count)
	
	var indicator_tween:Tween = create_tween()
	
	var tc1 = interact_indicator1.bind(value_sum)
	var tc2 = interact_indicator2.bind(item_count, multiplier)
	var tc3 = interact_indicator3.bind(value_sum, multiplier)

	g.player.money += int(value_sum*multiplier)
	
	indicator_tween.tween_callback(tc1)
	indicator_tween.tween_interval(0.75)
	indicator_tween.tween_callback(tc2)
	indicator_tween.tween_interval(0.75)
	indicator_tween.tween_callback(tc3)
	
	$deposit_sound.play()

func _on_interact_area_body_entered(body):
	if body == g.player:
		player_can_interact = true
		$anims.play("open")
		
func _on_interact_area_body_exited(body):
	if body == g.player:
		player_can_interact = false
		$anims.play_backwards("open")
