extends Node
signal dataChange
@onready var player = $"../Nivel_Set/Player"

var coins: int = 000:
	get:
		return coins
	set(value):
		coins += clamp(value, 1, max_coins)
		if (coins >= max_coins):
			coins = max_coins
		dataChange.emit()

var max_coins: int = 999:
	get:
		return max_coins
	set(value):
		max_coins = max(value, max_coins)
		dataChange.emit()

var health: int = 1:
	get:
		return health
	set(value):
		health += clamp(value, 1, max_health)
		if (health >= max_health):
			health = max_health
		dataChange.emit()

var max_health: int = 5:
	get:
		return max_health
	set(value):
		max_health = max(value, max_health)
		dataChange.emit()
