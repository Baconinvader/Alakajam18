extends Control

var time_string:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
