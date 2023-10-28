extends Node

class_name TileDat

var nav_id:int = -1
var position:Vector2
var tile_name
var is_patrol_point: bool

static func create_from_tile_dat(dat:TileData) -> TileDat:
	var tile = TileDat.new()
	
	var tile_name = dat.get_custom_data("name")
	tile.tile_name = tile_name
	
	tile.is_patrol_point = dat.get_custom_data("patrol")
	
	return tile
