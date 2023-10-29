extends Interactable

func _ready():
	g.player.position = position + $player_spawn_point.position

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
	Indicator.spawn_indicator("+$"+str(value_sum), self, Color.YELLOW)
	$deposit_sound.play()

func _on_interact_area_body_entered(body):
	if body == g.player:
		player_can_interact = true
		$anims.play("open")
		
func _on_interact_area_body_exited(body):
	if body == g.player:
		player_can_interact = false
		$anims.play_backwards("open")
