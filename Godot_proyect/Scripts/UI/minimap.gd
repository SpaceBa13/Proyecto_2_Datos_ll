extends SubViewport

@onready var camera = $Camera2D

func _physics_process(delta):
	# Restar las cantidades deseadas a la posición del jugador
	var target_position = owner.find_child("Player").position - Vector2(480, 340)
	camera.position = target_position
