extends "res://entities/Entity.gd"

class_name Creature

@export var speed = 128.0
@export var direction:float = 0.0
@export var fov:float = 80.0

func can_see_point(pos:Vector2):
	var diff = pos-self.position
	
	var v1 = direction - (fov/2)
	var v2 = direction + (fov/2)
	
	

func _draw():
	var v1 = direction - (fov/2)
	var v2 = direction + (fov/2)
	
	var line_length:float = 128.0
	
	
	draw_line(Vector2.ZERO, Vector2.from_angle(v1) * line_length, Color.RED, 2 )
	draw_line(Vector2.ZERO, Vector2.from_angle(v2) * line_length, Color.RED, 2 )

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
