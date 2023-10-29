extends CanvasLayer

class_name Overlay

signal finished

var tween:Tween

func _ready():
	$overlay.visible = false

func start(start_colour:Color, end_colour:Color, time:float):
	$overlay.visible = true
	$overlay.modulate = start_colour
	tween = create_tween()
	print(end_colour)
	tween.tween_property($overlay, "modulate", end_colour, time)
	
	var signal_call = emit_signal.bindv(["finished"])
	tween.tween_callback(signal_call)
	tween.tween_property($overlay, "visible", false, 0.1)
