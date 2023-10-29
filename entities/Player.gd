extends Creature

class_name Player

var money:int = 0
var is_being_chased:bool = false


@onready var base_speed:float = speed
var prone:bool = false:set=_set_prone


func _set_prone(val:bool):
	if not is_concealed():
		prone = val
		$prone_icon.visible = prone
		
		if prone:
			speed = base_speed*0.5
			set_collision_mask_value(2, false)
		else:
			speed = base_speed
			set_collision_mask_value(2, true)

func is_concealed() -> bool:
	for concealer in get_tree().get_nodes_in_group("concealers"):
		if concealer.concealing_player:
			return true
		
	#TODO fix this
	if current_tile.requires_prone:
		return true
		
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not g.in_game:
		return
		
	super._process(delta)
	
	var move_vec:Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		move_vec = Vector2.UP
		
	if Input.is_action_pressed("move_down"):
		move_vec += Vector2.DOWN

	if Input.is_action_pressed("move_left"):
		move_vec += Vector2.LEFT
		
	if Input.is_action_pressed("move_right"):
		move_vec += Vector2.RIGHT
		
	if move_vec != Vector2.ZERO:
		target_direction = move_vec.angle()
		
	if prone:
		$concealer_sprite.visible = false
		for concealer in get_tree().get_nodes_in_group("concealers"):
			if concealer.concealing_player:
				$concealer_sprite.visible = true
				$concealer_sprite.texture = concealer.get_node("sprite").texture
				var offset:Vector2 = concealer.position-position
				$concealer_sprite.position = offset
				break
	else:
		$concealer_sprite.visible = false
	
	move(move_vec.normalized(), delta)
		
func _physics_process(_delta):
	is_being_chased = false
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.state == Enemy.CreatureState.FIRING or Enemy.CreatureState.HOSTILE:
			is_being_chased = true
			break
		
func _unhandled_input(event):
	#var me:InputEventMouseButton = event as InputEventMouseButton
	#if me:
		#var target_pos = get_viewport_transform() * me.position
	#	var target_pos = $camera.get_screen_center_position( ) - (get_viewport_rect().size*0.5) + me.position
	#	set_target_pos(target_pos)# + $camera.position

	if event.is_action_pressed("prone"):
		prone = not prone
		
func reset():
	health = max_health
	#TODO position
		
func die():
	g.main.gameover()
