extends Control

var time_string:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$progress.max_value = g.max_time
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if g.time_left > 0:
	
		
		var minutes:int = g.time_left/60
		var seconds:int = fmod( g.time_left, 60.)
		var frac_sec = g.time_left-int(g.time_left)
		
		time_string = "%s:%s.%s" % [minutes, seconds, int(frac_sec*10)]
		
	
func _physics_process(_delta):
	$timer_label.text = time_string
	$decrease_speed_label.text = "x%s" % g.time_decrease_speed
	$progress.value = g.time_left
	
	if g.time_left <= 10:
		$progress.modulate = Color.RED
	elif g.time_left <= 30:
		$progress.modulate = Color.YELLOW
	elif g.time_left <= 60:
		$progress.modulate = Color.GREEN_YELLOW
	else:
		$progress.modulate = Color.GREEN

	if g.player.is_being_chased:
		$alert_icon.visible = true
		$alert_icon.texture = preload("res://assets/visual/icons/alert_hud.png")
		
	elif g.player.is_being_searched:
		$alert_icon.visible = true
		$alert_icon.texture = preload("res://assets/visual/icons/warning_hud.png")
		
	else:
		$alert_icon.visible = false
