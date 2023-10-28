extends Entity

class_name Interactable

var player_can_interact:bool = false:set=_set_player_can_interact


var can_interact:bool = true:get=_get_can_interact#set=_set_can_interact
var old_can_interact:bool = false

func _set_player_can_interact(val:bool):
	player_can_interact = val
	update_interact_icon()
	
func _get_can_interact() -> bool:
	return true
	
#func _set_can_interact(val:bool):
#	can_interact = val
#	update_interact_icon()

func update_interact_icon():
	print(can_interact," ",player_can_interact)
	if can_interact and player_can_interact:
		$icon.visible = true
	else:
		$icon.visible = false

func _physics_process(_delta):
	if old_can_interact != can_interact:
		old_can_interact = can_interact
		update_interact_icon()

func _process(delta):
	if $icon.visible:
		$icon/sprite.position.y = sin($icon/float_timer.time_left * PI) * 32

func _input(event):
	if event.is_action_pressed("interact") and player_can_interact and can_interact:
		interact()
		
func interact():
	pass

func _on_interact_area_body_entered(body):
	print(body)
	if body == g.player:
		player_can_interact = true
		

func _on_interact_area_body_exited(body):
	if body == g.player:
		player_can_interact = false


func _on_interact_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("ah",body)
