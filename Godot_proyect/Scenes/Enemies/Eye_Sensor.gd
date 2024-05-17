extends Area2D


class_name Eye_Sensor

var player_detected: bool
@onready var enemy_eye = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	var player_script = load("res://Scripts/Player/player.gd")
	player_detected = false
	body_entered.connect(set_player_detected_true)
	body_exited.connect(set_player_detected_false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player_detected_true(body):
	print(body)
	if body.name == "Player":
		body.seen = true
		enemy_eye.blink = true

func set_player_detected_false(body):
	print(body)
	if body.name == "Player":
		enemy_eye.blink = false
