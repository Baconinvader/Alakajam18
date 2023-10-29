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
				old_current_tile.set_nav_disabled(false)
			
		if tile and tile.nav_id != -1:
			tile.set_nav_disabled(true)
		old_current_tile = tile
	
	return tile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setup():
	update_current_tile()

func obscure_nav(disable:bool=true):
	var col_shape:Shape2D = $collision.shape
	var rect:Rect2 = col_shape.get_rect()

	var sx:int = (position.x - ceili(rect.size.x/2)) / g.level.tileset.tile_size.x
	var sy:int = (position.y - ceili(rect.size.y/2)) / g.level.tileset.tile_size.y

	var ex:int = (position.x + ceili(rect.size.x/2)) / g.level.tileset.tile_size.x
	var ey:int = (position.y + ceili(rect.size.y/2)) / g.level.tileset.tile_size.y
	
	sx -= g.level.offset_x
	sy -= g.level.offset_y + 0.5
	ex -= g.level.offset_x
	ey -= g.level.offset_y + 0.5
	
	print(sx,"->",ex," ",sy,"->",ey," ",disable)

	var tile:TileDat
	for x in range(sx,ex):
		for y in range(sy,ey):
			print(x," ",y)
			if sx < 0 or sy < 0 or ex >= g.level.size_x or ey >= g.level.size_y:
				print(x," ",y," cont")
				continue
					
			
			tile = g.level.tiles[x][y]
			print(tile)
			tile.set_nav_disabled(disable)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
