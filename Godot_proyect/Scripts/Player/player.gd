extends CharacterBody2D

class_name Player

@export var speed: int = 100
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var marker = $Marker2D
@onready var actionArea = $Marker2D/Area2D
@onready var tile_map = $"../DungeonRoom"
var seen: bool

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
	var position = tile_map.local_to_map(global_position)
	var tile_data = tile_map.get_cell_tile_data(0, position)
	if tile_data == null or tile_data.get_custom_data("safe_zone") == true:
		seen = false
		
	validateInput()
	animateMovement()
	move_and_slide()
