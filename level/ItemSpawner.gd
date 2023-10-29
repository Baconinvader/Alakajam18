extends Node2D


@export var spawn_options:Array[String]
@export var respawn_time:int = 0
var item:Item: set=_set_item

func _set_item(val:Item):
	item = val
	if item:
		$item_sprite.texture = item.texture
		$item_sprite.visible = true
		if item is Key:
			$money_icon.visible = false
		else:
			$money_icon.visible = true
		$light.visible = true
	else:
		$item_sprite.visible = false
		$money_icon.visible = false
		if respawn_time:
			$respawn_timer.start()
		$light.visible = false


func _ready():
	$respawn_timer.wait_time = respawn_time
	spawn()


func spawn():
	var path:String = spawn_options.pick_random()
	item = load(path).instantiate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(_delta):
	if item:
		$band_icon.visible = true
		$band_icon.scale = Vector2.ONE * (2.0+sin($band_stretch.time_left*PI)*0.25)
	else:
		$band_icon.visible = false

func _on_pickup_range_body_entered(body):
	if body == g.player:
		if item is Key:
			g.inventory.keys += 1
			item = null
		elif item and g.inventory.try_add_item(item):
			item = null


func _on_respawn_timer_timeout():
	spawn()
