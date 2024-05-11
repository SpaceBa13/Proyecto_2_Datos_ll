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
	astar_grid.cell_size = Vector2(16 ,16)
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
	var id_path = astar_grid.get_id_path(own_position, player_position).slice(1)
	
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
	
	
