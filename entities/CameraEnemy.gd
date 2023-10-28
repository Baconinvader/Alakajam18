extends Enemy

func finish_alert(new_target:Entity, target_state:CreatureState):
	state = target_state
	next_state = CreatureState.NONE
	if state == CreatureState.SUSPICIOUS:
		target = new_target
		
	if state == CreatureState.HOSTILE:
		target = new_target
		
	if state == CreatureState.UNALERTED:
		target = null
		

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
					var angle = (target.position-position).angle()
					direction = angle
					
			elif state == CreatureState.HOSTILE:
				var angle = (target.position-position).angle()
				direction = angle
				

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
