extends Node2D

@onready var HousePlayer = $HousePlayer

func _ready():
	remove_child(HousePlayer)
