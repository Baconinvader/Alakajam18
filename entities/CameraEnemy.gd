extends Enemy

@export var alert_range:int = 1024

@export var default_angle:float = 0
@export var turn_fov:float = PI-0.2

var alerting:bool = false

func _ready():
	super._ready()
	$base.rotation = default_angle
	direction = default_angle
	target_direction = default_angle
	$sprite.rotation = direction

func finish_state_change(new_target:Entity, target_state:CreatureState):
	state = target_state
	next_state = CreatureState.NONE
	if state == CreatureState.SUSPICIOUS:
		$sprite/searchlight.color = Color.YELLOW
		$light.color = Color.YELLOW
		
		target = new_target
		
	if state == CreatureState.HOSTILE:
		$sprite/searchlight.color = Color.RED
		$light.color = Color.RED
		suspicion_rate = 0.5
		
		target = new_target
		start_alert()
		
	if state == CreatureState.UNALERTED:
		$sprite/searchlight.color = Color.WHITE
		$light.color = Color.WHITE
		target_direction = default_angle
		
		target = null
		
func start_alert():
	$alarm_sound.play()
	$alarm_light.visible = true
	var light_tween:Tween = create_tween()
	light_tween.tween_property($alarm_light, "energy", 2, 2.0)
	
	light_tween.tween_interval(2.0)
	light_tween.tween_callback(check_continue_alert)
	
	do_alert()
	alerting = true
	
func check_continue_alert():
	if state == CreatureState.HOSTILE:
		do_alert()
		
		var light_tween:Tween = create_tween()
		light_tween.tween_interval(2.0)
		light_tween.tween_callback(check_continue_alert)
	else:
		finish_alert()
		
func _physics_process(delta):
	super._physics_process(delta)
	if alerting:
		$alarm_light.rotation += delta*PI
		
func finish_alert():
	alerting = false
	var light_tween:Tween = create_tween()
	light_tween.tween_property($alarm_light, "energy", 0, 2.0)
	light_tween.tween_property($alarm_light, "visible", false, 0.0)
		
func do_alert():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		
		var dist = (enemy.position - position).length()
		if dist <= alert_range:
			if enemy.state == Enemy.CreatureState.NONE or enemy.state == Enemy.CreatureState.UNALERTED:
				enemy.suspicion = enemy.suspicion_time - 0.01
				enemy.state_change(g.player, Enemy.CreatureState.SUSPICIOUS)
				enemy.set_target(g.player)
		
func on_reached_target():
	pass

func can_turn_to(angle:float) -> bool:
	return g.angle_in_bounds(angle, default_angle-(turn_fov*0.5), default_angle+(turn_fov*0.5))

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
				suspicion += suspicion_rate*delta
				
			elif state == CreatureState.SUSPICIOUS:
				suspicion += suspicion_rate*delta
				
			elif state == CreatureState.HOSTILE:
				suspicion = suspicion_time + hostile_time
				
			#resolve
			if state == CreatureState.UNALERTED:
				if suspicion >= suspicion_time:
					state_change(attention_entity, CreatureState.SUSPICIOUS)
					
			elif state == CreatureState.SUSPICIOUS:
				if suspicion >= suspicion_time + hostile_time:
					state_change(attention_entity, CreatureState.HOSTILE)
				else:
					if target: #hack
						var angle = (target.position-position).angle()
						if can_turn_to(angle):
							target_direction = angle
					
			elif state == CreatureState.HOSTILE:
				var angle = (target.position-position).angle()
				if can_turn_to(angle):
					target_direction = angle
				

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
				if suspicion < suspicion_time:
					state_change(null, CreatureState.SUSPICIOUS)
					
			if state == CreatureState.SUSPICIOUS:
				if suspicion <= 0.0:
					state_change(null, CreatureState.UNALERTED)
