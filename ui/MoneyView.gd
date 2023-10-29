extends Control


func _physics_process(_delta):
	$amount_label.text = "Money: %s"  % g.player.money
