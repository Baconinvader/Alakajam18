extends Node

class_name TileDat

var nav_id:int = -1
var position:Vector2
var tile_name

static func create_from_tile(id:int) -> TileDat:
	return TileDat.new()
	
