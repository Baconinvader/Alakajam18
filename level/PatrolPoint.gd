extends Entity

class_name PatrolPoint

@export var next_patrol_point:PatrolPoint
var last_patrol_point:PatrolPoint
var tile:TileDat

func _ready():
	if not next_patrol_point:
		#try to automatically assign
		var patrol = get_parent()
		var next:PatrolPoint = patrol.get_node_or_null( NodePath( str (int(str (name))+1) ) ) as PatrolPoint
		if next:
			next_patrol_point = next
	
	if next_patrol_point:
		next_patrol_point.last_patrol_point = self

func setup():
	tile = g.level.get_tile_at(position)
