extends CharacterBody2D

class_name Entity

var old_current_tile:TileDat = null
var current_tile:TileDat:get=_get_current_tile

func update_current_tile():
	var a = current_tile

func _get_current_tile() -> TileDat:
	var tile = g.level.get_tile_at(position)
	if old_current_tile != tile:
		if old_current_tile:
			if old_current_tile.nav_id != -1:
				old_current_tile.set_nav_enabled(false)
			
		if tile and tile.nav_id != -1:
			tile.set_nav_enabled(true)
		old_current_tile = tile
	
	return tile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setup():
	update_current_tile()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
