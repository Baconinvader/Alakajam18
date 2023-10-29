extends Creature

class_name Enemy

enum CreatureState {
	NONE,
	UNALERTED,
	
	TRANSITION, #transition
	
	SUSPICIOUS,
	HOSTILE,
	
	FIRING
}
var state:CreatureState =  CreatureState.UNALERTED
var next_state:CreatureState = CreatureState.NONE
var suspicion = 0.0# 0->1 suspicious, 1->2 hostile

var suspicion_rate = 1.0

var stuck_tween:Tween = null


@export var starting_patrol_point:PatrolPoint
@export var reverse_patrol:bool = false

@export var suspicion_time:float = 0.5
@export var hostile_time:float = 1.0

@export var attack_type:String = "ranged"
@export var min_range:int = 128
@export var fire_cooldown:float = 2.0
@export var fire_time:float = 1.5
@export var alert_time:float = 0.4
@export var damage:int = 1

@export var base_speed = 96
@export var chase_speed = 128

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	$health_bar.max_value = max_health
	$fire_cooldown.wait_time = fire_cooldown
	
	$alert_progress.max_value = suspicion_time + hostile_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func _draw():
	var v1 = direction - (fov/2)
	var v2 = direction + (fov/2)
	var e1 = Vector2.from_angle((v1))
	var e2 = Vector2.from_angle((v2))
	
	var e3 = Vector2.from_angle((target_direction))
	
	var line_length:float = view_range*0.25
	
	var line_colour:Color
	if state == CreatureState.HOSTILE or state == CreatureState.FIRING:
		line_colour = Color.RED
	elif state == CreatureState.SUSPICIOUS:
		line_colour = Color.YELLOW
	elif state == CreatureState.TRANSITION:
		line_colour = Color.TRANSPARENT
	else:
		line_colour = Color.GREEN
	line_colour.a = 0.25
	
	draw_line(Vector2.ZERO, e1 * line_length, line_colour, 2 )
	draw_line(Vector2.ZERO, e2 * line_length, line_colour, 2 )
	
	draw_arc(Vector2.ZERO, line_length, v1, v2, 8, line_colour, 2)
	draw_arc(Vector2.ZERO, line_length*0.5, v1, v2, 8, line_colour, 2)
	draw_arc(Vector2.ZERO, line_length*0.25, v1, v2, 8, line_colour, 2)
	
	if next_state == CreatureState.FIRING:
		var res = get_ray_results(target.position, target)
		if res:
			print(res)
			
			var r = $sprite/muzzle_flash.position.length()
			var phi = $sprite/muzzle_flash.position.angle()
			phi += $sprite.rotation
			var pos = Vector2.from_angle(phi) * (r-16)
			
			draw_line(pos, res.position-position, Color.ORANGE, 2 )
	
	#for point in target_path:
	#	var rel_point = point-position
	#	draw_circle(rel_point, 16, Color.DARK_RED)

func start_patrol():
	if starting_patrol_point:
		set_target(starting_patrol_point)
		pass

func state_change(new_target:Entity, target_state:CreatureState):
	next_state = target_state
	
	$alert_icon.visible = true
	if target_state == CreatureState.SUSPICIOUS:
		$alert_icon.texture = preload("res://assets/visual/icons/alert_question.png")
	elif target_state == CreatureState.HOSTILE:
		$alert_icon.texture = preload("res://assets/visual/icons/alert.png")
	elif target_state == CreatureState.FIRING:
		$alert_icon.texture = preload("res://assets/visual/icons/alert_firing.png")
	else:
		$alert_icon.visible = false
	
	state = CreatureState.TRANSITION
	var tween:Tween = create_tween()
	
	if target_state == CreatureState.FIRING:
		tween.tween_interval(fire_time)
	else:
		tween.tween_interval(alert_time)
		
	var callable = finish_alert.bindv([new_target, target_state])
	tween.tween_callback(callable)
	tween.tween_property($alert_icon, "visible", false, 0.1)
	
func finish_alert(new_target:Entity, target_state:CreatureState):
	state = target_state
	next_state = CreatureState.NONE
	if state == CreatureState.SUSPICIOUS:
		set_target(new_target)
		
	if state == CreatureState.UNALERTED:
		start_patrol()
		
	if state == CreatureState.FIRING:
		state = CreatureState.HOSTILE
		
		$sprite/muzzle_flash.visible = true
		$sprite/muzzle_flash.play("fire")
		#$sprite/muzzle_flash.rotation = direction
		
		#var r = starting_muzzle_flash_pos.length()
		#var phi = starting_muzzle_flash_pos.angle()
		#phi += rotation
		#$muzzle_flash.position = Vector2.from_angle(phi) * r
		
		
		$fire_cooldown.start()
		if get_ray_entity(target):
			target.change_health(-damage)
	
func on_reached_target():
	if target is PatrolPoint:
		if reverse_patrol:
			if target.last_patrol_point:
				set_target(target.last_patrol_point)
			else:
				reverse_patrol = false
				set_target(target.next_patrol_point)
		else:
			if target.next_patrol_point:
				set_target(target.next_patrol_point)
			else:
				reverse_patrol = true
				set_target(target.last_patrol_point)
	else:
		super.on_reached_target()
	
func move(move_vec:Vector2, delta:float):
	var old_vec:Vector2 = position
	super.move(move_vec, delta)
	var diff = position-old_vec
	
	var dist = diff.length()
	if dist < 0.0001:
		if $stuck_timer.is_stopped():
			$stuck_timer.start()
	else:
		$stuck_timer.stop()
	
func update_state(delta):
	var attention_entity:Entity
	
	if state != CreatureState.TRANSITION:
		for alerter in get_tree().get_nodes_in_group("alerters"):
			if can_see(alerter):
				attention_entity = alerter
				break
			
	if state != CreatureState.TRANSITION:
		if attention_entity:
			if state == CreatureState.UNALERTED:
				speed = base_speed
				suspicion += suspicion_rate*delta
				
			elif state == CreatureState.SUSPICIOUS:
				speed = chase_speed
				suspicion += suspicion_rate*delta
				
			elif state == CreatureState.HOSTILE:
				speed = chase_speed
				suspicion = suspicion_time + hostile_time
				
			#resolve
			if state == CreatureState.UNALERTED:
				if suspicion >= suspicion_time:
					state_change(attention_entity, CreatureState.SUSPICIOUS)
					
			elif state == CreatureState.SUSPICIOUS:
				if suspicion >= suspicion_time + hostile_time:
					state_change(attention_entity, CreatureState.HOSTILE)
				else:
					pass
					set_target(attention_entity)
					if target_path.size() > 1:
						target_path.remove_at(0)
					
			elif state == CreatureState.HOSTILE:
				if target and min_range:
					var dist = (target.position - position).length()
					if dist <= min_range:
						target_path.clear()
						var angle = (target.position-position).angle()
						target_direction = angle
						
						if not $fire_cooldown.time_left:
							state_change(attention_entity, CreatureState.FIRING)

					else:
						set_target(attention_entity)
						if target_path.size() > 1:
							target_path.remove_at(0)
							pass
				else:
					set_target(attention_entity)
				
			elif state == CreatureState.FIRING:
				pass
				
		else:
			if suspicion:
				if state == CreatureState.HOSTILE:
					if target_path.is_empty():
						suspicion -= suspicion_rate*delta
					else:
						pass
						
					
				elif state == CreatureState.SUSPICIOUS:
					if target_path.is_empty():
						suspicion -= suspicion_rate*delta
				
				elif state == CreatureState.UNALERTED:
					suspicion -= suspicion_rate*delta
				
			#resolve
			if state == CreatureState.HOSTILE:
				speed = chase_speed
				if suspicion < suspicion_time:
					if target_path.is_empty():
						state_change(null, CreatureState.SUSPICIOUS)
					
			if state == CreatureState.SUSPICIOUS:
				speed = chase_speed
				if suspicion <= 0.0:
					if target_path.is_empty():
						state_change(null, CreatureState.UNALERTED)
					
			if state == CreatureState.UNALERTED:
				speed = base_speed
				if target_path.is_empty():
					start_patrol()
	else:
		if next_state == CreatureState.FIRING:
			var angle = (target.position-position).angle()
			target_direction = angle
	
func _physics_process(delta):
	if not g.in_game:
		return
		
	update_state(delta)
			
	if suspicion < 0.0:
		suspicion = 0.0
	elif suspicion > suspicion_time + hostile_time:
		suspicion = suspicion_time + hostile_time
		
	if suspicion:
		$alert_progress.visible = true
		if suspicion < suspicion_time:
			$alert_progress.value = suspicion
			$alert_progress.max_value = suspicion_time
			$alert_progress.modulate = Color.YELLOW
		else:
			$alert_progress.value = suspicion - suspicion_time
			$alert_progress.max_value = hostile_time
			$alert_progress.modulate = Color.RED
	else:
		$alert_progress.visible = false
	
	if health != max_health:
		$health_bar.visible = true
		$health_bar.value = health
	else:
		$health_bar.visible = false
	
	$state_label.text = CreatureState.find_key(state)
	


func _on_stuck_timer_timeout():
	#panic!
	target_path.clear()
	
	if stuck_tween:
		stuck_tween.stop()
	
	#wait a random amount of time first
	stuck_tween = create_tween()
	stuck_tween.tween_interval(randf_range(1.0, 3.0))
	var state_change_call = state_change.bindv([null, CreatureState.UNALERTED])
	stuck_tween.tween_callback(state_change_call)
	

func _on_muzzle_flash_animation_looped():
	$sprite/muzzle_flash.visible = false
