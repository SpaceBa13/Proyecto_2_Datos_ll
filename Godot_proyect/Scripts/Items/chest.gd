extends Node2D

@export var objects: Array[PackedScene]
@onready var area = $ActionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	area.actionated.connect(actioned)

# Called when the chest is actioned
func actioned():
	# Assuming you want to spawn the first object in the list
	if objects.size() > 0:
		var obj_scene = objects[0]
		var obj_instance = obj_scene.instantiate()
		add_child(obj_instance)
		
		# Calculate the position in front of the chest
		var spawn_position = global_position + Vector2(50, 0)  # Adjust this vector based on your game
		obj_instance.global_position = spawn_position
		
		print(obj_instance.name)
