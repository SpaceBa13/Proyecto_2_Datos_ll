extends CharacterBody2D


var astar_grid: AStarGrid2D
@onready var tile_map = $"../DungeonRoom"
@onready var player = $"../Player"
var current_point_path: PackedVector2Array
var current_id_path: Array[Vector2i]
const speed = 1.5



func _on_timer_timeout():
	make_path()

func make_path():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2i(16 ,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(x + tile_map.get_used_rect().position.x,
			y + tile_map.get_used_rect().position.y)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
	
	var own_position = tile_map.local_to_map(global_position)
	var player_position = tile_map.local_to_map(player.global_position)
	

	var id_path = get_id_path(own_position, player_position, tile_map).slice(1)
	print(id_path)
	
	if id_path.is_empty() == false:
		current_id_path = id_path
		current_point_path = astar_grid.get_point_path(
			own_position, player_position)
		


func _physics_process(delta):
	if current_id_path.is_empty():
		return

	var target_position = tile_map.map_to_local(current_id_path.front())
	global_position = global_position.move_toward(target_position, speed)
	
	if global_position.x == target_position.x and global_position.x == target_position.x:
		current_id_path.pop_front()
	

var INFINITY = 1e9

func get_id_path(start_pos: Vector2i, end_pos: Vector2i, tile_map: TileMap) -> Array:
	# Obtener el tamaño de la celda del TileMap
	var cell_size = 16
	
	# Convertir las posiciones iniciales y finales a posiciones de celda en el TileMap
	var start_cell = tile_map.map_to_local(start_pos)
	var end_cell = tile_map.map_to_local(end_pos)
	
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
		for neighbor in get_neighbors(current, tile_map):
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
				if !open_set.contains(neighbor):
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
func get_neighbors(position, tile_map: TileMap):
	var neighbors = []
	for dir in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
		var neighbor = position + dir
		# Verificar si el vecino está dentro de los límites del TileMap y si es transitable
		if is_valid_neighbor(neighbor, tile_map):
			neighbors.append(neighbor)
	return neighbors

# Función para verificar si un vecino es válido
func is_valid_neighbor(neighbor, tile_map: TileMap):
	# Obtener los datos de la celda del TileMap
	var tile_data = tile_map.get_cell_tile_data(0, neighbor)
	
	# Verificar si la celda es transitable (según los datos personalizados)
	if tile_data and tile_data.get_custom_data("walkable") == false:
		return true
		
	
	# Devolver falso si no hay datos de celda o no se especifica la propiedad "walkable"
	return false
	
	
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

