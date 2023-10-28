extends Node

signal player_set
signal time_out

func angle_in_bounds(angle:float, from:float, to:float) -> bool:
	if from < 0 :
		from += (2*PI)
	if to < 0:
		to += (2*PI)
	if angle < 0:
		angle += (2*PI)
		
	if from >= to:
		if angle >= from or angle <= to:
			return true
			
	if angle >= from and angle <= to:
		return true
	
	return false

func _set_player(val:Player):
	player = val
	emit_signal("player_set")

var level:Level
var player:Player: set=_set_player
var inventory:Inventory

var time_left:float = 0
var time_decrease_speed = 1.0
