extends Creature

enum CreatureState {
	UNALERTED,
	ALERTING, #transition
	SUSPICIOUS,
	HOSTILE
}
var state:CreatureState =  CreatureState.UNALERTED
var suspicion = 0.0# 0->1 suspicious, 1->2 hostile

var suspicion_rate = 1.0


@export var starting_patrol_point:PatrolPoint
@export var reverse_patrol:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func start_patrol():
	if starting_patrol_point:
		set_target(starting_patrol_point)

func start_alert(new_target:Entity, target_state:CreatureState):
	
	if target_state == CreatureState.SUSPICIOUS:
		$alert_icon.texture = preload("res://assets/visual/icons/alert_question.png")
	elif target_state == CreatureState.HOSTILE:
		$alert_icon.texture = preload("res://assets/visual/icons/alert.png")
	
	$alert_icon.visible = true
	state = CreatureState.ALERTING
	var tween:Tween = create_tween()
	tween.tween_interval(0.5)
	var callable = finish_alert.bindv([new_target, target_state])
	tween.tween_callback(callable)
	tween.tween_property($alert_icon, "visible", false, 0.1)
	
func finish_alert(new_target:Entity, target_state:CreatureState):
	state = target_state
	if state == CreatureState.SUSPICIOUS:
		set_target(new_target)
		
	if state == CreatureState.UNALERTED:
		start_patrol()
	
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
	
func _physics_process(delta):
	var attention_entity:Entity
	
	if state != CreatureState.ALERTING:
		for alerter in get_tree().get_nodes_in_group("alerters"):
			if can_see(alerter):
				attention_entity = alerter
				break
			
	if state != CreatureState.ALERTING:
		if attention_entity:
			if state == CreatureState.UNALERTED:
				suspicion += suspicion_rate*delta
				
			elif state == CreatureState.SUSPICIOUS:
				suspicion += suspicion_rate*delta
				
			elif state == CreatureState.HOSTILE:
				suspicion = 2.0
				
			#resolve
			if state == CreatureState.UNALERTED:
				if suspicion >= 1.0:
					start_alert(attention_entity, CreatureState.SUSPICIOUS)
					
			elif state == CreatureState.SUSPICIOUS:
				if suspicion >= 2.0:
					start_alert(attention_entity, CreatureState.HOSTILE)
					
			elif state == CreatureState.HOSTILE:
				set_target(attention_entity)
				
		else:
			if suspicion:
				if state == CreatureState.HOSTILE:
					if target_path.is_empty():
						suspicion -= suspicion_rate*delta
					
				elif state == CreatureState.SUSPICIOUS:
					if target_path.is_empty():
						suspicion -= suspicion_rate*delta
				
				elif state == CreatureState.UNALERTED:
					suspicion -= suspicion_rate*delta
				
			#resolve
			if state == CreatureState.HOSTILE:
				if suspicion < 1.0:
					start_alert(null, CreatureState.SUSPICIOUS)
					
			if state == CreatureState.SUSPICIOUS:
				if suspicion <= 0.0:
					start_alert(null, CreatureState.UNALERTED)
					
	if suspicion < 0.0:
		suspicion = 0.0
	elif suspicion > 2.0:
		suspicion = 2.0
		
	if suspicion:
		$alert_progress.visible = true
		if suspicion < 1.0:
			$alert_progress.value = suspicion
			$alert_progress.modulate = Color.YELLOW
		else:
			$alert_progress.value = suspicion - 1.0
			$alert_progress.modulate = Color.RED
	else:
		$alert_progress.visible = false
	$state_label.text = CreatureState.find_key(state)
