extends Node

class_name Backtraking_path

var cell_size = Vector2i(16,16)
var tile_map: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Función para verificar si un vecino es válido
func is_valid_move(neighbor) -> bool:
	# Obtener el valor de la capa personalizada "walkable" en la celda vecina
	var tile_data = tile_map.get_cell_tile_data(0, neighbor)
	if tile_data == null or tile_data.get_custom_data("walkable") == false:
		return false
	else:
		return true


func get_backtrack_path(start: Vector2i, goal: Vector2i) -> Array:
	var path = []
	get_backtrack_path_aux(start, goal, [], path)
	return path

func get_backtrack_path_aux(pos: Vector2i, goal: Vector2i , current_path: Array, path: Array) -> bool:
	if pos == goal:
		for point in current_path:
			path.append(point)
		path.append(pos)
		return true
	
	if is_valid_move(pos):
		current_path.append(pos)
		if  pos.x < goal.x and pos.y < pos.y:
			if get_backtrack_path_aux(pos + Vector2i(1,1), goal, current_path, path):
				return true
		if  pos.x > goal.x and pos.y > pos.y:
			if get_backtrack_path_aux(pos + Vector2i(-1,-1), goal, current_path, path):
				return true
		if  pos.x > goal.x and pos.y < pos.y:
			if get_backtrack_path_aux(pos + Vector2i(-1,1), goal, current_path, path):
				return true
		if pos.x < goal.x and pos.y > pos.y:
			if get_backtrack_path_aux(pos + Vector2i(1,-1), goal, current_path, path):
				return true
		if pos.x < goal.x:
			if get_backtrack_path_aux(pos + Vector2i(1,0), goal, current_path, path):
				return true
		if pos.x > goal.x:
			if get_backtrack_path_aux(pos + Vector2i(-1,0), goal, current_path, path):
				return true		
		if pos.y > goal.y:
			if get_backtrack_path_aux(pos + Vector2i(0,-1), goal, current_path, path):
				return true			
		if pos.y < goal.y:
			if get_backtrack_path_aux(pos + Vector2i(0,1), goal, current_path, path):
				return true

		current_path.pop_back()
	
	return false

