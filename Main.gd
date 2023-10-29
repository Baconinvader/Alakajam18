extends Node


func _ready():
	g.main = self
	g.player = preload("res://entities/Player.tscn").instantiate()
	g.inventory = $UI/Inventory
	g.overlay = $overlay
	
	add_child(g.player)
	
	var start_screen = preload("res://ui/StartScreen.tscn").instantiate()
	$UI.add_child(start_screen)

func start_game():
	if g.level:
		g.level.queue_free()
		
	g.level = preload("res://level/Level.tscn").instantiate()
	add_child(g.level)
	g.time_left = g.max_time
	g.in_game = true
	
	g.inventory.reset()
	g.player.reset()
	
	move_child(g.player, g.level.get_index()+1)

func gameover():
	g.in_game = false
	g.overlay.start(Color.TRANSPARENT, Color.BLACK, 1.0)
	g.overlay.connect("finished", _on_overlay_finished, CONNECT_ONE_SHOT)
	
func _on_overlay_finished():
	var end_screen = preload("res://ui/EndScreen.tscn").instantiate()
	$UI.add_child(end_screen)

func _process(delta):
	if not g.in_game:
		return
		
	if g.time_left:
		
		if g.player.is_being_chased:
			g.time_decrease_speed = 2.0
		else:
			g.time_decrease_speed = 1.0
		
		g.time_left -= delta*g.time_decrease_speed
			
		if g.time_left <= 0:
			g.time_left = 0
			gameover()
			g.emit_signal("time_out")
