extends CharacterBody2D

@onready var tile_map = $"../../DungeonRoom"
@onready var player = $"../../Player"
var current_id_path: Array
const speed = 1.5
var spawn_position = Vector2i(0,0)
var chasing: bool
@onready var Astar_path = $Astar
@onready var Backtrack_path = $Backtraking_path
var teleport = false
@export var maxHealth = 2
@onready var currentHealth: int = maxHealth
@export var fire_ball : PackedScene


func _ready(): 
	spawn_position = tile_map.local_to_map(global_position)
	chasing = false
	Astar_path.tile_map = tile_map
	Backtrack_path.tile_map = tile_map

func make_astar_path():
	var own_position = tile_map.local_to_map(global_position)
	var player_position = tile_map.local_to_map(player.global_position)
	var heuristic = Astar_path.heuristic(own_position, player_position)
	var id_path = []
	if heuristic < 40:
		id_path = Astar_path.get_id_path(own_position, player_position, tile_map).slice(1)
		if teleport == false:
			var valid_teleport = Astar_path.get_neighbors(tile_map.local_to_map(global_position))
			for dir in [Vector2i(2, 0), Vector2i(-2, 0), Vector2i(0, 2), Vector2i(0, -2)]:
				var neighbor = player_position + dir
				if Astar_path.is_valid_neighbor(neighbor):
					var target_position = Vector2(player.global_position.x + dir.x * 16, player.global_position.y + dir.y * 16)
					global_position = target_position
					break
			teleport = true
	
	if id_path.is_empty() == false:
		current_id_path = id_path

		

func _physics_process(delta):
	var own_position = tile_map.local_to_map(global_position)
	var player_position = tile_map.local_to_map(player.global_position)
	var heuristic = Astar_path.heuristic(own_position, player_position)
	var tile_data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(player.global_position))
	if current_id_path.is_empty():
		if tile_data != null:
			if tile_data.get_custom_data("safe_zone") != true and player.seen == true:
				make_astar_path()
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
			if heuristic > 1:
				global_position = global_position.move_toward(target_position, speed)
				if global_position.x == target_position.x and global_position.y == target_position.y:
					print(current_id_path)
					current_id_path.pop_front()
		else:
			if chasing == true:
				chasing = false
				teleport = false
				current_id_path.clear()
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

func _on_hitbox_area_entered(area):
	if area.name == "Swordbox":
		currentHealth -= 1
		if currentHealth == 0:
			queue_free()


func _on_timer_timeout():
	var instance = fire_ball.instantiate()
	add_sibling(instance)
	instance.global_position = global_position
	var fire_ball = Fire_Ball.new(Vector2i(1,0), tile_map)
	add_child(fire_ball)
	print(fire_ball.global_position)
	
