extends Node2D

class_name TileDat

var nav_id:int = -1
#var position:Vector2
var tile_name
var is_patrol_point: bool
var requires_prone:bool = false

func _ready():
	pass
	#$sprite.position = position

func set_nav_disabled(val:bool):
	#print(nav_id," ",val)
	g.level.nav.set_point_disabled(nav_id, val)
	#$sprite.visible = not val

static func create_from_tile_dat(dat:TileData) -> TileDat:
	var tile = preload("res://level/TileDat.tscn").instantiate()
	if dat:
		var tile_name = dat.get_custom_data("name")
		tile.tile_name = tile_name
		
		tile.is_patrol_point = dat.get_custom_data("patrol")
		
		if dat.get_collision_polygons_count(1):
			tile.requires_prone = true
	
	return tile
