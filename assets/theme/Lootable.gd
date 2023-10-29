extends Interactable

var looted:bool = false
var item:Item
@export var spawn_options:Array[String]

@export var unlooted_texture:Texture2D
@export var looted_texture:Texture2D

func _ready():
	super._ready()
	$light.visible = true
	if unlooted_texture:
		$sprite.texture = unlooted_texture

func _get_can_interact() -> bool:
	if looted or g.inventory.items.size() == g.inventory.inventory_size:
		return false
	return true

func _physics_process(delta):
	super._physics_process(delta)
	if not looted:
		$band_icon.visible = true
		$band_icon.scale = Vector2.ONE * (2.0+sin($band_stretch.time_left*PI)*0.25)
	else:
		$band_icon.visible = false

func spawn():
	var path:String = spawn_options.pick_random()
	item = load(path).instantiate()
	
func interact():
	spawn()
	if g.inventory.try_add_item(item):
		looted = true
		$light.visible = false
		$open_sound.play()
		$sprite.texture = looted_texture
