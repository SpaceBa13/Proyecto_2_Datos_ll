extends CharacterBody2D

@export var speed: int = 100
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

func validateInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func animateMovement():
	if velocity.length() == 0:
		animation.stop()
	else:
		var direAnim = "Walk_down"
		sprite.flip_h = false
		if velocity.x < 0:
			direAnim = "Walk_right"
			sprite.flip_h = true
		elif velocity.x > 0:
			direAnim = "Walk_right"
		elif velocity.y < 0:
			direAnim = "Walk_up"
		animation.play(direAnim)

func _physics_process(delta):
	validateInput()
	animateMovement()
	move_and_slide()
