extends Node

func angle_in_bounds(angle:float, from:float, to:float) -> bool:
	if from >= to:
		if angle >= from or angle <= to:
			return true
			
	if angle >= from and angle <= to:
		return true
		
	return false

var level:Level
var player:Player
