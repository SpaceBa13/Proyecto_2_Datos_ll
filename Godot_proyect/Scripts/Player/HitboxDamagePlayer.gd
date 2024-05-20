extends Node
class_name PlayerHitboxDamage

var parentNode
var direccion: String
var posicion: Vector2
var idDamage: int

func setup(body, direct, id):
	parentNode = body.get_parent()
	posicion = Vector2(body.position)
	direccion = direct
	idDamage = id
	
func createDamage():
		pass
