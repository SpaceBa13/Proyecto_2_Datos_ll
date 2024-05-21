extends Area2D


func _on_body_entered(body:Node2D):
	if(body.name == "Player"):  
		body.visible = false

func _on_body_exited(body:Node2D):
	if(body.name == "Player"):
		body.visible = true
