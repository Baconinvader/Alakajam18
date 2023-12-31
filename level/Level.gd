extends Node2D

class_name Level

var tiles

var offset_x = 0
var offset_y = 0

var size_x = 0
var size_y = 0

var nav = AStar2D.new()
var nav_map = {}
var tileset:TileSet

# Called when the node enters the scene tree for the first time.
func _ready():
	tileset = $tiles.tile_set
	generate_nav()
	setup_entities()
	setup_patrols()
	
func generate_nav():
	var tile_indices = $tiles.get_used_cells(0)
	for index in tile_indices:

		if index.x < offset_x:
			offset_x = index.x
		if index.y < offset_y:
			offset_y = index.y
			
	for index in tile_indices:
		if index.x > offset_x + size_x -1:
			size_x = index.x - offset_x +1
		if index.y > offset_y + size_y -1:
			size_y = index.y - offset_y +1
			
	tiles = []

	for x in range(offset_x, size_x+offset_x):
		tiles.append([])
		for y in range(offset_y, size_y+offset_y):
			var dat:TileData = $tiles.get_cell_tile_data (0, Vector2i(x,y) )
			
				
			var tile:TileDat = TileDat.create_from_tile_dat(dat)
			tiles[-1].append(tile)
			
			var tile_pos:Vector2 = Vector2(tileset.tile_size.x*(x+0.5), tileset.tile_size.y*(y+0.5) )
			tile.position = tile_pos
			
			
			var debug_sprite:Sprite2D = tile.get_node("sprite")
			add_child(tile)
			
			if tile.is_patrol_point:
				debug_sprite.texture = preload("res://assets/visual/tile_patrol.png")
			else:
				debug_sprite.texture = preload("res://assets/visual/target.png")
			#debug_sprite.position = tile_pos
			

			

	var tile:TileDat
	var point_id:int = 0
	for x in size_x:
		for y in size_y:
			tile = tiles[x][y]
			if tile:
				var pos = tile.position
				
				nav.add_point(point_id, pos)
				nav_map[point_id] = tile
				
				var dat:TileData = $tiles.get_cell_tile_data (0, Vector2i(x+offset_x,y+offset_y) )
				if not dat or dat.get_collision_polygons_count(0):
					continue
				
				tile.nav_id = point_id
				
				#hook up
				var check_tile:TileDat
				var cx:int
				var cy:int
				for check_vec in [Vector2(x-1, y), Vector2(x, y-1), Vector2(x+1, y), Vector2(x, y+1)]:
					cx = check_vec.x
					cy = check_vec.y
					#for cx in randi_range(x-1, x+1):
					#for cy in randi_range(y-1, y+1):
					if cx < 0 or cy < 0 or cx >= size_x or cy >= size_y:
						continue
					check_tile = tiles[cx][cy]
					if check_tile and check_tile.nav_id != -1:
						nav.connect_points(point_id, check_tile.nav_id )

				point_id += 1
	
func setup_patrols():
	for patrol_point in get_tree().get_nodes_in_group("patrol_points"):
		patrol_point.setup()
		
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.start_patrol()
	
func setup_entities():
	for entity in get_tree().get_nodes_in_group("entities"):
		entity.setup()
	
func get_tile_at(pos:Vector2) -> TileDat:
	var tile:TileDat
	if tileset:
		var tx:int = (pos.x/tileset.tile_size.x) - offset_x
		var ty:int = (pos.y/tileset.tile_size.y) - offset_y
		
		tile = tiles[tx][ty]
	else:
		tile = null
	return tile
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
