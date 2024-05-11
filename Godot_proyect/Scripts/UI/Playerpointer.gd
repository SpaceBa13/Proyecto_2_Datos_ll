extends Sprite2D

func _physics_process(delta):
	var player = owner.find_child("Player",true, false)
	if player:
		position = player.position
