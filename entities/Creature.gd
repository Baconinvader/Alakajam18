extends "res://entities/Entity.gd"

class_name Creature

@export var speed = 128.0
@export var direction:float = 0.0
@export var fov:float = 80.0
@export var view_range:float = 512.0


var target_path:Array
var state

func get_ray_results(pos:Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, pos)
	var result = space_state.intersect_ray(query)

	return result

func get_ray_entity(entity:Entity) -> bool:
	var results = get_ray_results(entity.position)
	if results and results.collider == entity:
		return true
	else:
		return false

func can_see_point(pos:Vector2) -> bool:
	var diff = pos-self.position
	
	var v1 = direction - (fov/2)
	var v2 = direction + (fov/2)
	var angle = diff.angle()

	var ray_results = get_ray_results(pos)

	if g.angle_in_bounds(angle, v1, v2):
		return true
	else:
		return false

func set_target_pos(pos:Vector2):
	
	var path_raw:PackedInt64Array = g.level.nav.get_id_path(g.level.nav.get_closest_point(position), g.level.nav.get_closest_point(pos))
	print(position," -> ",pos," ",path_raw)
	
	var path:Array = []
	var tile:TileDat
	for id in path_raw:
		tile = g.level.nav_map[id]
		path.append(tile.position)
		
	print(tile.tile_name," ",tile.position)
		
	target_path = path
	$target.position = pos
	
func set_target(entity:Entity):
	return set_target_pos(entity.position)
	
func _draw():
	var v1 = direction - (fov/2)
	var v2 = direction + (fov/2)
	var e1 = Vector2.from_angle((v1))
	var e2 = Vector2.from_angle((v2))
	
	var line_length:float = view_range
	
	draw_line(Vector2.ZERO, e1 * line_length, Color.RED, 2 )
	draw_line(Vector2.ZERO, e2 * line_length, Color.RED, 2 )

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_path:
		var diff:Vector2 = (target_path[0] - position)
		var dist:float = diff.length()
		if dist < 2:
			target_path.remove_at(0)
		else:
			var move_vec:Vector2
			if dist >= speed*delta:
				move_vec = diff.normalized()
			else:
				move_vec = diff.normalized()/(speed*delta)
			move(move_vec, delta)
		
func move(move_vec:Vector2, delta:float):
	if move_vec != Vector2.ZERO:
		direction = move_vec.normalized().angle()
		queue_redraw()
		
		move_vec *= speed*delta
		
		var res = move_and_collide(move_vec)
		
