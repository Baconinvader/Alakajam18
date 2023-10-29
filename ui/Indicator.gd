extends Node2D

class_name Indicator

static func spawn_indicator(text:String, entity:Entity, colour:Color):
	var indicator = preload("res://ui/Indicator.tscn").instantiate()
	indicator.get_node("label").text = text
	indicator.get_node("label").modulate = colour
	entity.add_child(indicator)
	
@export var speed = 128

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed*delta


func _on_life_timer_timeout():
	queue_free()
