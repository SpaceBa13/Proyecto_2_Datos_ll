extends CanvasLayer

@onready var Player = $AudioStreamPlayer

func _physics_process(delta):
	if Input.is_action_just_pressed("pressed"):
		Player.play()
		get_tree().paused = not get_tree().paused
		$ColorRect.visible = not $ColorRect.visible
		$Label.visible = not $Label.visible
