extends Area2D

class_name Spike_Trap_Sensor

var player_detected: bool
@onready var Spike_Trap = $".."
@onready var animation = $"../AnimatedSprite2D"
# Called when the node enters the scene tree for the first time.
func _ready():
	player_detected = false
	body_entered.connect(set_player_detected_true)
	body_exited.connect(set_player_detected_false)
	

func set_player_detected_true(body):
	print(body)
	if body.name == "Player":
		animation.play("default")

func set_player_detected_false(body):
	print(body)
	if body.name == "Player":
		animation.stop()
