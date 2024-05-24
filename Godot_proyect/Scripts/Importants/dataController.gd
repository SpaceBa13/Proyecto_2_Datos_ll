extends Node
signal dataChange
@onready var player = $"../Nivel_Set/Player"

@export var coins: int = 0
@export var max_coins: int = 999
@export var health: int = 5
@export var max_health: int = 5

func _ready():
	# Emitimos una señal inicial para asegurarnos de que la UI se actualice al inicio
	emit_signal("dataChange")

func set_coins(value):
	coins = clamp(value, 0, max_coins)
	emit_signal("dataChange")

func set_health(value):
	health = clamp(value, 1, max_health)
	emit_signal("dataChange")
