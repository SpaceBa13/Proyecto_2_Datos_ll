extends Node2D

@onready var enemy = $"../enemy2"

func _process(delta):
	queue_redraw()

func _draw():
	if enemy.current_point_path.is_empty():
		return
	
	draw_polyline(enemy.current_point_path, Color.BLUE)
