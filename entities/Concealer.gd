extends Entity

var concealing_player:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var collision_duplicate = $collision.duplicate()
	$concealer_area.add_child(collision_duplicate)
	
func setup():
	obscure_nav()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_concealer_area_body_entered(body):
	if body == g.player:
		concealing_player = true

func _on_concealer_area_body_exited(body):
	if body == g.player:
		concealing_player = false
		obscure_nav()
