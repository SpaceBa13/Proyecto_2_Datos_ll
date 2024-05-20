extends CharacterBody2D


@onready var tile_map = $"../DungeonRoom"
@onready var player = $"../Player"
var current_path: Array
const speed = 2

func _ready():
	make_backtrack_path()
	

func make_backtrack_path():
	var own_position = tile_map.local_to_map(global_position)
	var player_position = tile_map.local_to_map(player.global_position)
	# Resuelve el laberinto desde la posición inicial
	current_path = get_backtrack_path(own_position, player_position)


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

func _physics_process(delta):
	if current_path.is_empty():
		return

	var target_position = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, speed)
	
	if global_position.x == target_position.x and global_position.y == target_position.y:
		current_path.pop_front()
