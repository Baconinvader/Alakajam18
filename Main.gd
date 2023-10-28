extends Node


func _ready():
	start_game()
	
	g.player = preload("res://entities/Player.tscn").instantiate()
	g.inventory = $UI/Inventory
	
	add_child(g.player)

func start_game():
	g.level = preload("res://level/Level.tscn").instantiate()
	add_child(g.level)
	g.time_left = 120

func _process(delta):
	if g.time_left:
		
		if g.player.is_being_chased:
			g.time_decrease_speed = 2.0
		else:
			g.time_decrease_speed = 1.0
		
		g.time_left -= delta*g.time_decrease_speed
			
		if g.time_left <= 0:
			g.time_left = 0
		
			g.emit_signal("time_out")
