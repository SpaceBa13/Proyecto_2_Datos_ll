extends CharacterBody2D

class_name Chocobo_Enemy

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var tile_map: TileMap
@onready var Astar_path = $Astar
var player: Player
const speed = 1.2
var current_id_path: Array

func _ready():
	tile_map = $"../../DungeonRoom"
	player = $"../../Player"
	# Inicializar los arrays con vectores nulos
	current_id_path = []
	Astar_path.tile_map = tile_map
	
func _physics_process(delta):
	var own_position = tile_map.local_to_map(global_position)
	var target_position = player.bresenham
	current_id_path = Astar_path.get_id_path(own_position, target_position, tile_map)
	move()

func move():
	if !current_id_path.is_empty() and current_id_path.size() > 2:
		current_id_path.pop_front()
		var target_position = tile_map.map_to_local(current_id_path.front())
		global_position = global_position.move_toward(target_position, speed)
		var direction = (target_position - global_position).normalized()
		animate(direction)
		if tile_map.local_to_map(global_position) == tile_map.local_to_map(target_position) or global_position == target_position:
			current_id_path.pop_front()
	if !current_id_path.is_empty():
		current_id_path.pop_front()
	
func animate(direction: Vector2):
	if direction.x > 0:
			animated_sprite_2d.play("Animation_sides")
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.rotation = 0
	elif direction.x < 0: 
			animated_sprite_2d.play("Animation_sides")
			animated_sprite_2d.flip_h = true
	elif direction.y > 0: 
		animated_sprite_2d.play("Animation_down")
		animated_sprite_2d.rotation = 0
	elif direction.y < 0: 
		animated_sprite_2d.play("Animation_Up")
		animated_sprite_2d.rotation = 0
