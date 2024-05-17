extends CharacterBody2D

class_name Eye_Enemy


@onready var sensor = $Eye_Sensor
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var tile_map: TileMap
var rng = RandomNumberGenerator.new()
const speed = 0.3
var current_id_path: Array
var positions_path: Array
var prev_step: Vector2
var blink: bool

func _ready():
	tile_map = $"../DungeonRoom"
	# Inicializar los arrays con vectores nulos
	current_id_path = []
	positions_path = []
	prev_step = global_position
	blink = false
	
func _physics_process(delta):
	if sensor.player_detected == true:
		print("jugador detectado")
	if current_id_path.is_empty():
		create_path()
	else:
		move()
	

func create_path():
	var dir = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	var random_pos = rng.randi_range(0, 3)
	var target_direccion = dir[random_pos]
	var target_position = tile_map.local_to_map(global_position) + target_direccion

	
	for i in range(3):
		current_id_path.append(Vector2i(0, 0))
		positions_path.append(Vector2i(0, 0))

	if is_valid_move(target_position):
		current_id_path[0] = target_direccion
		positions_path[0] = target_position
		
		while is_valid_move(target_position):
			positions_path.append(target_position)
			current_id_path.append(target_direccion)
			target_position =  target_position + target_direccion
	
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
	var target_position = Vector2(prev_step.x + next_position.x * 16, prev_step.y + next_position.y * 16)
	animate()
	global_position = global_position.move_toward(target_position, speed)
	if global_position == target_position:
			current_id_path.pop_front()
			prev_step = global_position
	if current_id_path.front() == Vector2i(0,0):
		current_id_path.pop_front()
		prev_step = global_position
	
	
func animate():
	if blink:
		animated_sprite_2d.play("Animation_Blink")
	else:
		animated_sprite_2d.play("Animation")
	if current_id_path.front() == Vector2i(1, 0):
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.rotation = 0
		sensor.rotation = 0
	if current_id_path.front() == Vector2i(-1, 0):
		animated_sprite_2d.rotation = PI
		animated_sprite_2d.flip_v = true
		sensor.rotation = PI
	if current_id_path.front() == Vector2i(0, 1):
		animated_sprite_2d.rotation = PI / 2
		sensor.rotation = PI/2
	if current_id_path.front() == Vector2i(0, -1):
		animated_sprite_2d.rotation = -PI / 2
		sensor.rotation = -PI/2
