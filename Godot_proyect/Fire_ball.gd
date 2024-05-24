extends CharacterBody2D

var dir: Vector2i
const speed = 3
var tile_map: TileMap
@onready var animated_sprite_2d = $AnimatedSprite2D
var prev_step: Vector2
var current_id_path: Array
var rng = RandomNumberGenerator.new()
var activate = false

func _ready():
	tile_map = $"../../DungeonRoom"
	# Inicializar los arrays con vectores nulos
	current_id_path = []
	prev_step = global_position
	
func _physics_process(delta):
	if current_id_path.is_empty() and activate == false:
		create_path()
		activate = true
	if current_id_path.is_empty() and activate == true:
		queue_free()
	else:
		move()
	

func create_path():
	var random_pos = rng.randi_range(0, 3)
	var target_direccion = dir
	var target_position = tile_map.local_to_map(global_position) + target_direccion
	for i in range(3):
		current_id_path.append(dir)

	if is_valid_move(target_position):
		current_id_path[0] = target_direccion
		while is_valid_move(target_position):
			current_id_path.append(target_direccion)
			target_position =  target_position + target_direccion
		
		current_id_path.pop_front()
	
	
# Función para verificar si un vecino es válido
func is_valid_move(neighbor) -> bool:
	# Obtener el valor de la capa personalizada "walkable" en la celda vecina
	var tile_data = tile_map.get_cell_tile_data(0, neighbor)
	if tile_data == null or tile_data.get_custom_data("walkable") == false or tile_data.get_custom_data("safe_zone") == true:
		return false
	else:
		return true

func move():
	var next_position = current_id_path.front()
	var target_position = Vector2(prev_step.x + next_position.x * 16, prev_step.y + next_position.y * 16)
	animate()
	global_position = global_position.move_toward(target_position, speed)
	if global_position == target_position:
			current_id_path.pop_front()
			prev_step = global_position
	if !current_id_path.is_empty():
		if current_id_path.front() == Vector2i(0,0):
			current_id_path.pop_front()
			prev_step = global_position
	
func animate():
	animated_sprite_2d.play("default")


func _on_timer_timeout():
	queue_free()
