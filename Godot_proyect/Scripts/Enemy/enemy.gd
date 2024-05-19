extends CharacterBody2D

@onready var tile_map = $"../DungeonRoom"
@onready var player = $"../Player"
var current_id_path: Array
const speed = 1.3
var spawn_position = Vector2i(0,0)
var chasing: bool
@onready var Astar = $Astar
@onready var Backtrack_path = $Backtraking_path 

func _ready():
	spawn_position = tile_map.local_to_map(global_position)
	chasing = false
	Astar.tile_map = tile_map
	Backtrack_path.tile_map = tile_map

func make_astar_path():
	var own_position = tile_map.local_to_map(global_position)
	var player_position = tile_map.local_to_map(player.global_position)
	
	var id_path = Astar.get_id_path(own_position, player_position, tile_map).slice(1)
	#print(id_path)
	
	if id_path.is_empty() == false:
		current_id_path = id_path

		

func _physics_process(delta):
	var tile_data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(player.global_position))
	if current_id_path.is_empty():
		if tile_data != null:
			if tile_data.get_custom_data("safe_zone") != true and player.seen == true:
				make_astar_path()
				return
			else:
				return
			
	var target_position: Vector2
	if !current_id_path.is_empty():
		target_position = tile_map.map_to_local(current_id_path.front())
	else:
		return
	#Si la informacion de la celda es diferente de null
	if tile_data != null:
		#Obtiene si el jugador esta o no en zona segura
		if tile_data.get_custom_data("safe_zone") != true and player.seen == true:
			chasing = true
			make_astar_path()
			global_position = global_position.move_toward(target_position, speed)
			if global_position.x == target_position.x and global_position.y == target_position.y:
				print(current_id_path)
				current_id_path.pop_front()
				
		else:
			if chasing == true:
				chasing = false
				current_id_path.clear()
				var own_position = tile_map.local_to_map(global_position)
				make_backtrack_path(own_position)
				global_position = global_position.move_toward(target_position, speed)
				if global_position.x == target_position.x and global_position.y == target_position.y:
					current_id_path.pop_front()
			else:
				global_position = global_position.move_toward(target_position, speed)
				if global_position.x == target_position.x and global_position.y == target_position.y:
					current_id_path.pop_front()

	
#Backtraking zone
func make_backtrack_path(own_position):
	# Resuelve el laberinto desde la posición inicial
	current_id_path = Backtrack_path.get_backtrack_path(own_position, spawn_position)
