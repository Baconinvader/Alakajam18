extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	g.connect("player_set", _on_player_set, CONNECT_ONE_SHOT)
	
func _on_player_set():
	for i in g.player.max_health:
		var health_point = TextureRect.new()
		health_point.texture = preload("res://assets/visual/icons/health_point.png")
		
		$list.add_child(health_point)

func _physics_process(delta):
	var i:int = 0
	for icon in $list.get_children():
		if i < g.player.health:
			icon.visible = true
		else:
			icon.visible = false
		i += 1
		
