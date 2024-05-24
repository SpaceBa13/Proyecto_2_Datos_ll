extends CharacterBody2D

class_name Fire_Ball

var dir: Vector2i
const speed = 1
var current_id_path: Array
var tile_map: TileMap
@onready var animated_sprite_2d = $AnimatedSprite2D

# Constructor
func _init(_dir: Vector2i, _tile_map: TileMap):
	dir = _dir
	tile_map = _tile_map
	create_path()

func _physics_process(delta):
	move()
	

func create_path():
	current_id_path.append(dir)
	var target_position = tile_map.local_to_map(global_position) + dir
	print(target_position)
	print("true")
	if is_valid_move(target_position):
		current_id_path[0] = dir
		while is_valid_move(target_position):
			current_id_path.append(dir)
			target_position =  target_position + dir
		current_id_path.pop_front()

# Función para verificar si un vecino es válido
func is_valid_move(neighbor) -> bool:
	# Obtener el valor de la capa personalizada "walkable" en la celda vecina
	var tile_data = tile_map.get_cell_tile_data(0, neighbor)
	if tile_data == null or tile_data.get_custom_data("walkable") == false:
		return false
	else:
		return true

func move():
	if current_id_path.is_empty():
		return
	var next_position = current_id_path.front()
	var target_position = Vector2(global_position.x + next_position.x * 16, global_position.y + next_position.y * 16)
	animate()
	global_position = global_position.move_toward(target_position, speed)
	if global_position == target_position:
			current_id_path.pop_front()
	if !current_id_path.is_empty():
		if current_id_path.front() == Vector2i(0,0):
			current_id_path.pop_front()
	
	
func animate():
	pass
