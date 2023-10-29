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

func rotate_to(from:float, to:float, amount:float):
	var increased_from:bool = false
	var increased_to:bool = true
	while from < 0 :
		from += (2*PI)
		increased_from = true
	while to < 0:
		to += (2*PI)
		increased_to = true
		
	var diff_forward:float
	var diff_backward:float
	if to > from: #|a->b|
		diff_forward = to-from
	else: #|->b a->|
		diff_forward = (2*PI) - from + to
		
	if from > to: #|b<-a|
		diff_backward = from-to
	else: #|<-a b<-|
		diff_backward = from + ((2*PI) - to)
		

	if increased_from:
		while from > 0:
			from -= (2*PI)
	if increased_to:
		while to > 0:
			to -= (2*PI)
	
	
	if diff_forward < diff_backward:
		if diff_forward <= amount:
			return to
			
		return from + amount
	else:
		if diff_backward <= amount:
			return to
		return from - amount

func angles_similar(a1:float, a2:float)->bool:
	var epsilon:float = 0.00001
	
	if abs(a1 - a2) < epsilon:
		return true
		
	if abs(a1+(2*PI) - a2) < epsilon:
		return true
		
	if abs(a1 - a2+(2*PI)) < epsilon:
		return true

	return false

func _set_player(val:Player):
	player = val
	emit_signal("player_set")

var main
var overlay:Overlay
var level:Level
var player:Player: set=_set_player
var inventory:Inventory

var time_left:float = 0
var time_decrease_speed = 1.0

var in_game:bool = false
