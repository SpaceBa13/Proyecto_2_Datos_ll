extends Area2D

class_name Trap_Sensor

var player_detected: bool
@onready var Spike_Trap = $".."
@onready var animation = $"../AnimatedSprite2D"
@onready var dataNode = get_node("../../../../DataController")
@onready var timer = $Timer
var activate = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player_detected = false
	body_entered.connect(set_player_detected_true)
	body_exited.connect(set_player_detected_false)

func set_player_detected_true(body):
	print(body)
	if body.name == "Player" and activate == false:
		if body.currentHealth == 1:
			get_tree().reload_current_scene()
		animation.play("default")
		body.currentHealth = body.currentHealth - 1
		dataNode.set_health(body.currentHealth)
		print(body.currentHealth)
		#print("Hizo daño")
		activate = true

func set_player_detected_false(body):
	if body.name == "Player":
		animation.stop()
		timer.start()
	

func _on_timer_timeout():
	get_parent().queue_free()
