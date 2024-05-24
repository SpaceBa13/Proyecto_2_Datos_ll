extends Area2D


class_name Fire_Ball_Sensor
@onready var fire_ball = $".."
@onready var dataNode = get_node("../../../../DataController")
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(set_player_detected_true)
	


func set_player_detected_true(body):
	print(body)
	if body.name == "Player":
		body.currentHealth = body.currentHealth - 1
		dataNode.set_health(body.currentHealth)
		fire_ball.queue_free()
		
		
