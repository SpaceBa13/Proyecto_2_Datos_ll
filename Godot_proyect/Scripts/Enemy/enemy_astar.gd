extends CharacterBody2D


@onready var tile_map = $"../DungeonRoom"
@onready var player = $"../Player"
var current_id_path: Array
const speed = 1.3
var spawn_position = Vector2i(0,0)
var chasing: bool

func _ready():
	spawn_position = tile_map.local_to_map(global_position)
	chasing = true
	print(spawn_position)
	make_path()

func make_path():
	var own_position = tile_map.local_to_map(global_position)
	var player_position = tile_map.local_to_map(player.global_position)
	
	var id_path = get_id_path(own_position, player_position, tile_map).slice(1)
	#print(id_path)
	
	if id_path.is_empty() == false:
		current_id_path = id_path

		


func _physics_process(delta):
	if current_id_path.is_empty():
		return

	var tile_data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(player.global_position))
	var target_position = tile_map.map_to_local(current_id_path.front())
	
	if tile_data != null:
		if tile_data.get_custom_data("safe_zone") != true:
			make_path()
			global_position = global_position.move_toward(target_position, speed)
			if global_position.x == target_position.x and global_position.y == target_position.y:
				current_id_path.pop_front()
		else:
			if chasing == true:
				current_id_path.clear()
				make_backtrack_path()
				global_position = global_position.move_toward(target_position, speed)
				current_id_path.pop_front()
			else:
				chasing = false
				current_id_path.clear()
				global_position = global_position.move_toward(target_position, speed)
				current_id_path.pop_front()


	
var INFINITY = 1000000
var cell_size = Vector2i(16,16)

func get_id_path(start_pos: Vector2i, end_pos: Vector2i, tile_map: TileMap) -> Array:
	# Convertir las posiciones iniciales y finales a posiciones de celda en el TileMap
	var start_cell = start_pos

	var end_cell = end_pos
	
	# Lista abierta de nodos por explorar
	var open_set = [start_cell]
	
	# Diccionario para almacenar el nodo padre de cada nodo
	var came_from = {}
	
	# Diccionario para almacenar el costo acumulado desde el inicio hasta cada nodo
	var g_score = {start_cell: 0}
	
	# Diccionario para almacenar el costo estimado desde el inicio hasta cada nodo, más una estimación del costo desde el nodo hasta el objetivo
	var f_score = {start_cell: heuristic(start_cell, end_cell)}
	
	# Mientras haya nodos por explorar en la lista abierta
	while open_set.size() > 0:
		# Obtener el nodo actual como el nodo con el menor f_score
		var current = get_lowest_f_score(open_set, f_score)
		
		# Si el nodo actual es igual al nodo objetivo, reconstruir y devolver la ruta
		if current == end_cell:
			return reconstruct_path(came_from, current)
		
		# Remover el nodo actual de la lista abierta
		open_set.erase(current)
		
		# Explorar los vecinos del nodo actual
		for neighbor in get_neighbors(current):
			# Calcular el costo acumulado desde el inicio hasta el vecino
			var tentative_g_score = g_score[current] + 1
			
			# Si el vecino no ha sido visitado o el nuevo costo es menor que el anteriormente calculado
			if !g_score.has(neighbor) or tentative_g_score < g_score[neighbor]:
				# Actualizar el nodo padre y el costo acumulado del vecino
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				# Calcular el costo estimado desde el inicio hasta el vecino, más una estimación del costo desde el vecino hasta el objetivo
				f_score[neighbor] = g_score[neighbor] + heuristic(neighbor, end_cell)
				# Agregar el vecino a la lista abierta si no está presente
				if !open_set.has(neighbor):
					open_set.append(neighbor)
	
	# Si no se encuentra una ruta, devolver una lista vacía
	return []

# Función para obtener el nodo con el menor f_score
func get_lowest_f_score(open_set, f_score):
	var lowest = INFINITY
	var current = null
	for node in open_set:
		if f_score[node] < lowest:
			lowest = f_score[node]
			current = node
	return current

# Función para obtener los vecinos de un nodo en el TileMap
func get_neighbors(position):
	var neighbors = []
	var neighbor: Vector2i
	for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 1), Vector2i(-1, -1), Vector2i(1, -1),Vector2i(-1, 1)]:
		neighbor.x = position.x + dir.x
		neighbor.y = position.y + dir.y
		# Verificar si el vecino está dentro de los límites del TileMap y si es transitable
		if is_valid_neighbor(neighbor):
			neighbors.append(neighbor)
	return neighbors

# Función para verificar si un vecino es válido
func is_valid_neighbor(neighbor) -> bool:
	# Obtener el valor de la capa personalizada "walkable" en la celda vecina
	var tile_data = tile_map.get_cell_tile_data(0, neighbor)
	if tile_data == null or tile_data.get_custom_data("walkable") == false:
		return false
	else:
		return true

# Función de heurística (distancia Manhattan)
func heuristic(current, goal):
	return abs(current.x - goal.x) + abs(current.y - goal.y)

# Función para reconstruir la ruta desde el nodo final hasta el nodo inicial
func reconstruct_path(came_from, current):
	var total_path = [current]
	while came_from.has(current):
		current = came_from[current]
		total_path.insert(0, current)
	return total_path


#Backtraking zone
func make_backtrack_path():
	var own_position = tile_map.local_to_map(global_position)
	# Resuelve el laberinto desde la posición inicial
	current_id_path = get_backtrack_path(own_position, spawn_position)


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
