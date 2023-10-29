extends Control

@export var tutorial_slides:Array[Texture2D]
var tutorial_slide_index = 0:set=_set_tutorial_slide_index

func _set_tutorial_slide_index(val:int):
	tutorial_slide_index = val
	if not tutorial_slides.is_empty():
		$tutorial/slide.texture = tutorial_slides[tutorial_slide_index]

func _ready():
	g.in_game = false
	tutorial_slide_index = 0

func _on_start_button_pressed():
	$start_button.disabled = true
	g.overlay.start(Color.TRANSPARENT, Color.BLACK, 1.0)
	g.overlay.connect("finished", _on_overlay_finished, CONNECT_ONE_SHOT)
	Sound.play_sound("button1")
	
func _on_overlay_finished():
	g.overlay.start(Color.BLACK, Color.TRANSPARENT, 1.0)
	g.main.start_game()
	queue_free()


func _on_tutorial_button_pressed():
	$tutorial.visible = true


func _on_right_pressed():
	tutorial_slide_index = (tutorial_slide_index + 1)%tutorial_slides.size()


func _on_left_pressed():
	tutorial_slide_index = (tutorial_slide_index - 1)%tutorial_slides.size()


func _on_exit_pressed():
	$tutorial.visible = false
