extends Area2D

@export var idItem: int = 0
@export var value: int = 0
var minimap
func _ready():
	minimap = get_node("../../Mini Map")
	minimap.hide()
	
	match idItem:
		1: 
			$Sprite2D.texture = preload("res://Resources/Items/Coin.png")
		2:
			$Sprite2D.texture = preload("res://Resources/Items/Heart.png")
		3:
			$Sprite2D.texture = preload("res://Resources/Items/Map.png")

func _on_body_entered(body:Node2D):
	var dataNode = get_node("../../../DataController")
	if(body.name == "Player"):
		match idItem:
			1:
				dataNode.coins = value
			2:
				dataNode.health = value
			3:
				minimap.show()
		queue_free()
