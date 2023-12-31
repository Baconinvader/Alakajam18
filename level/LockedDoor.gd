extends Interactable

class_name LockedDoor

var locked:bool = true

func interact():
	locked = false
	g.inventory.keys -= 1
	$collision.disabled = true
	$anims.play("open")
	$open_sound.play()
	obscure_nav(false)

func _physics_process(_delta):
	if locked and player_can_interact and not can_interact:
		$label.visible = true
	else:
		$label.visible = false
		
func _get_can_interact() -> bool:
	if locked and g.inventory.keys:
		return true
	else:
		return false
