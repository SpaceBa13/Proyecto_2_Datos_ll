extends Area2D

@onready var new_scene_path: String = "$HousePlayer"

func _on_body_entered(body:Node2D):
	if(body.name == "Player"):  
		change_level()
		
func change_level():
	var new_scene = ResourceLoader.load(new_scene_path)
	print("new_scene_path")
	if new_scene:
		get_tree().change_scene_to(new_scene)
	else:
		print("Error: La escena no se pudo cargar")
