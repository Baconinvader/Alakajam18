extends "res://entities/Entity.gd"

class_name Creature

@export var speed = 128.0
@export var direction:float = 0.0:set=_set_direction
@onready var target_direction:float = direction
@export var turn_speed = PI

@export var fov:float = 80.0
@export var view_range:float = 512.0

@export var max_health:int = 5
@onready var health:int = max_health

var moving = false

var stacked_target_path:Array
var stacked_target:Entity

var target_path:Array
var last_target_pos: set=_set_last_target_pos
var target:Entity

func _set_last_target_pos(val):
	
	if val:
		if target_path.size() > 1:
			target_direction = (target_path[1]-val).normalized().angle()
		else:
			target_direction = 0
	else:
		pass
		#target_direction = 0
			
			
	last_target_pos = val

func _set_direction(val:float):
	direction = val
	queue_redraw()

func get_ray_results(pos:Vector2, entity:Entity):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, pos)
	if entity is Player:
		var collision_mask:int = entity.collision_mask
		if entity.prone:
			collision_mask -= 2
		else:
			collision_mask += 2
		query.collision_mask = collision_mask

	var result = space_state.intersect_ray(query)

	return result

func get_ray_entity(entity:Entity) -> bool:
	var results = get_ray_results(entity.position, entity)
	if results and results.collider == entity:
		return true
	else:
		return false

func can_see_point(pos:Vector2) -> bool:
	var diff = pos-self.position
	
	var dist:float = diff.length()
	if dist >= view_range:
		return false
	
	var v1 = direction - (fov/2)
	var v2 = direction + (fov/2)
	var angle = diff.angle()

	if g.angle_in_bounds(angle, v1, v2):
		return true
	else:
		return false

func can_see(entity:Entity) -> bool:
	
	if not can_see_point(entity.position):
		return false
		
	if not get_ray_entity(entity):
		return false
		
	return true

func set_target_pos(pos:Vector2):
	
	
	#g.level.nav.get_closest_point(position)
	var is_nav_disabled:bool = g.level.nav.is_point_disabled(current_tile.nav_id)
	if is_nav_disabled:
		current_tile.set_nav_disabled(true)
	var path_raw:PackedInt64Array = g.level.nav.get_id_path(current_tile.nav_id, g.level.nav.get_closest_point(pos))
	if is_nav_disabled:
		current_tile.set_nav_disabled(false)
	
	#print(position," -> ",pos," ",path_raw)
	
	var path:Array = []
	var tile:TileDat
	for id in path_raw:
		tile = g.level.nav_map[id]
		path.append(tile.position)
		

	#path.remove_at(0)
	#print(target_path)
	target_path = path

func stack_target():
	stacked_target = target
	stacked_target_path = target_path
	target = null
	target_path = []

func unstack_target():
	if stacked_target:
		target = stacked_target
		stacked_target = null
	
	if stacked_target_path:
		target_path = stacked_target_path
		stacked_target_path = [null]

func set_target(entity:Entity):
	if target != entity:
		last_target_pos = null
		
	var new_target:bool = false
	if not target and entity:
		new_target = true
		
	target = entity
	if target:
		
		var res = set_target_pos(entity.position)
		
		return res
	else:
		target_path.clear()
		return null
		


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not g.in_game:
		moving = false
		return
	moving = false
		
	if not g.angles_similar(direction, target_direction):
		direction = g.rotate_to(direction, target_direction, turn_speed *delta)
		$sprite.rotation = direction
	
	if target_path:
		
		var diff:Vector2 = (target_path[0] - position)
		var dist:float = diff.length()
		
		
		var close_dist:float = 1.5
		if dist < close_dist:
			last_target_pos = target_path[0]
			target_path.remove_at(0)
			if target_path.is_empty():
				on_reached_target()
			#else:
				#refresh path
				#set_target_pos(target_path[-1])
				#target_path.remove_at(0)
		else:
			var move_vec:Vector2
			
			#if last_target_pos and target_path[0] != last_target_pos:
			#	diff = target_path[0] - last_target_pos
				
			#no diag
			if abs(diff.x):
				diff.y = 0
			else:
				diff.x = 0
				
			target_direction = diff.normalized().angle()
			
			if false and not g.angles_similar(direction, target_direction):
				pass
			else:
				dist = diff.length()
				
				if dist >= close_dist*speed*delta:
					move_vec = diff.normalized()
				else:
					move_vec = (dist*diff.normalized()) /(speed*delta)
				move(move_vec, delta)
			
func on_reached_target():
	target = null
	last_target_pos = null
		
func move(move_vec:Vector2, delta:float):
	if move_vec != Vector2.ZERO:
		moving = true
		
		queue_redraw()
		
		move_vec *= speed*delta
		
		var res:KinematicCollision2D = move_and_collide(move_vec, true)
		if res and res.get_collider():
			pass
		else:
			position += move_vec
		
		update_current_tile()
		
func change_health(amount:int):
	health += amount
	health = clampi(health, 0, max_health)
	
	
	var text_colour:Color
	if amount <= 0:
		$hit_sound.play()
		text_colour = Color.RED
		modulate = Color.WHITE
		var damage_colour:Color = Color.FIREBRICK
		var damage_tween:Tween = create_tween()
		damage_tween.tween_property(self, "modulate", damage_colour, 0.5)
		damage_tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		
		var overlay_colour:Color = Color.RED
		overlay_colour.a = 0.25
		g.overlay.start(Color.TRANSPARENT, overlay_colour, 0.5)
	else:
		text_colour = Color.GREEN
		
	Indicator.spawn_indicator(str(amount), self, text_colour)
	
	if not health:
		die()
		
func die():
	queue_free()


func _on_footstep_timer_timeout():
	if moving:
		play_footsteps()
		
func play_footsteps():
	var rval:int = randi_range(1,3)
	get_node("footstep%s_sound" % rval).play()
