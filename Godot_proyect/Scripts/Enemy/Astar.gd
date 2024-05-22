extends Node

class_name Astar

var INFINITY = 1000000
var cell_size = Vector2i(16,16)
var tile_map: TileMap

func _ready():
	pass

func get_id_path(start_pos: Vector2i, end_pos: Vector2i, tile_map: TileMap) -> Array:
	# Convertir las posiciones iniciales y finales a posiciones de celda en el TileMap
	var start_cell = start_pos
	var end_cell = end_pos
	
	# Lista abierta de nodos por explorar
	var not_visited = [start_cell]
	
	# Diccionario para almacenar el nodo padre de cada nodo
	var came_from = {}
	
	# Diccionario para almacenar el costo acumulado desde el inicio hasta cada nodo
	var cost = {start_cell: 0}
	
	# Diccionario para almacenar el costo estimado desde el inicio hasta cada nodo, más una estimación del costo desde el nodo hasta el objetivo
	var cost_with_heuristic = {start_cell: heuristic(start_cell, end_cell)}
	
	# Mientras haya nodos por explorar en la lista abierta
	while not_visited.size() > 0:
		# Obtener el nodo actual como el nodo con el menor f_score
		var current = get_lowest_f_score(not_visited, cost_with_heuristic)
		# Si el nodo actual es igual al nodo objetivo, reconstruir y devolver la ruta
		if current == end_cell:
			return reconstruct_path(came_from, current)
		# Remover el nodo actual de la lista abierta
		not_visited.erase(current)
		# Explorar los vecinos del nodo actual
		for neighbor in get_neighbors(current):
			# Calcular el costo acumulado desde el inicio hasta el vecino
			var tentative_g_score = cost[current] + 1
			# Si el vecino no ha sido visitado o el nuevo costo es menor que el anteriormente calculado
			if !cost.has(neighbor) or tentative_g_score < cost[neighbor]:
				# Actualizar el nodo padre y el costo acumulado del vecino
				came_from[neighbor] = current
				cost[neighbor] = tentative_g_score
				# Calcular el costo estimado desde el inicio hasta el vecino, más una estimación del costo desde el vecino hasta el objetivo
				cost_with_heuristic[neighbor] = cost[neighbor] + heuristic(neighbor, end_cell)
				# Agregar el vecino a la lista abierta si no está presente
				if !not_visited.has(neighbor):
					not_visited.append(neighbor)
	
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
	var neighbor = Vector2i(0,0)
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
