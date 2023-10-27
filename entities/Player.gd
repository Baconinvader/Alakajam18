extends Creature

class_name Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		
		direction = move_vec.angle() + PI
		queue_redraw()
		
		move_vec *= speed*delta
		
		var res = move_and_collide(move_vec)
