extends CharacterBody2D

class_name Rat_Enemy

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var tile_map: TileMap
var rng = RandomNumberGenerator.new()
const speed = 1.8
var current_id_path: Array

@export var maxHealth = 2
@onready var currentHealth: int = maxHealth

func _ready():
	tile_map = $"../../DungeonRoom"
	# Inicializar los arrays con vectores nulos
	current_id_path = []
	
func _physics_process(delta):
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

	if is_valid_move(target_position):
		current_id_path[0] = target_direccion
		
		while is_valid_move(target_position):
			current_id_path.append(target_direccion)
			target_position =  target_position + target_direccion
	
		
	
	
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
	var target_position = tile_map.map_to_local(current_id_path.front() + tile_map.local_to_map(global_position))
	global_position = global_position.move_toward(target_position, speed)
	animate()
	current_id_path.pop_front()
	
func animate():
	if current_id_path.front() == Vector2i(1, 0):
		animated_sprite_2d.play("Animation_right")
	if current_id_path.front() == Vector2i(-1, 0):
		animated_sprite_2d.play("Animation_left")
	if current_id_path.front() == Vector2i(0, 1):
		animated_sprite_2d.play("Animation_down")
	if current_id_path.front() == Vector2i(0, -1):
		animated_sprite_2d.play("Animation_up")

	

func _on_hitbox_area_entered(area):
	if area.name == "Swordbox":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth
		print_debug(currentHealth)
		print_debug(maxHealth)
