extends Node
class_name PlayerHitboxDamage

var parentNode
var direccion: String
var posicion: Vector2
var idDamage: int
var instance

var hit = preload("res://Scenes/Player/ally_slash.tscn")

func setup(parent, body, direct, id):
	parentNode = parent
	posicion = Vector2(body.global_position)
	direccion = direct
	idDamage = id
	
func createDamage():
	match idDamage:
		1: 
			instance = hit.instantiate()
			instance.timer = 0.2
			instance.canMove = false
		2:
			pass
	instance.direccion  = direccion
	instance.position = posicion
	parentNode.add_child(instance)
