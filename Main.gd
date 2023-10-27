extends Node


func _ready():
	g.level = preload("res://level/Level.tscn").instantiate()
	add_child(g.level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
