extends CharacterBody2D

@export var speed: int = 100
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var marker = $Marker2D
@onready var actionArea = $Marker2D/Area2D

func validateInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func animateMovement():
	if velocity.length() == 0:
		animation.stop()
	else:
		var direAnim = "Walk_down"
		marker.rotation = deg_to_rad(0)
		sprite.flip_h = false
		if velocity.x < 0:
			direAnim = "Walk_right"
			marker.rotation = deg_to_rad(90)
			sprite.flip_h = true
		elif velocity.x > 0:
			direAnim = "Walk_right"
			marker.rotation = deg_to_rad(-90)
		elif velocity.y < 0:
			direAnim = "Walk_up"
			marker.rotation = deg_to_rad(180)
		animation.play(direAnim)

func _physics_process(delta):
	validateInput()
	animateMovement()
	move_and_slide()


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
