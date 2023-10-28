extends Creature

class_name Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	move(move_vec.normalized(), delta)
		
func _input(event):
	var me:InputEventMouseButton = event as InputEventMouseButton
	if me:
		#var target_pos = get_viewport_transform() * me.position
		var target_pos = $camera.get_screen_center_position( ) - (get_viewport_rect().size*0.5) + me.position
		set_target_pos(target_pos)# + $camera.position
