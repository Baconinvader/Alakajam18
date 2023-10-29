extends Entity

class_name Interactable

var player_can_interact:bool = false:set=_set_player_can_interact

@export var max_hold_time:float = 0.0
var hold_time:float = 0.0

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
	if can_interact and player_can_interact:
		$icon.visible = true
	else:
		$icon.visible = false

func _physics_process(delta):
	if old_can_interact != can_interact:
		old_can_interact = can_interact
		update_interact_icon()
		
	if max_hold_time:
		if Input.is_action_pressed("interact") and player_can_interact and can_interact:
			if not hold_time:
				$start_interact_sound.play()
			hold_time += delta
			if hold_time >= max_hold_time:
				interact()
				hold_time = 0
		else:
			hold_time = 0
			
		if hold_time:
			$hold_bar.visible = true
			$hold_bar.value = hold_time
		else:
			$hold_bar.visible = false

func _ready():
	if max_hold_time:
		$hold_bar.max_value = max_hold_time
	else:
		$hold_bar.visible = false

func _process(delta):
	if $icon.visible:
		$icon/sprite.position.y = sin($icon/float_timer.time_left * PI) * 32

func _input(event):
	if not max_hold_time:
		if event.is_action_pressed("interact") and player_can_interact and can_interact:
			$start_interact_sound.play()
			interact()
		
func interact():
	pass

func _on_interact_area_body_entered(body):
	if body == g.player:
		player_can_interact = true
		

func _on_interact_area_body_exited(body):
	if body == g.player:
		player_can_interact = false


