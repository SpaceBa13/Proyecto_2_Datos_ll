extends CharacterBody2D

class_name Player

@export var speed: int = 100
@onready var animation = $AnimationPlayer
@onready var sprite = $PlayerSprite
@onready var marker = $Marker2D
@onready var actionArea = $Marker2D/Area2D
@onready var tile_map = $"../DungeonRoom"
@onready var hitboxDamage = $DamageHitbox
var direccionHitDamage = "DOWN"
var hitboxDamageScript: PlayerHitboxDamage = PlayerHitboxDamage.new()

var bresenham: Vector2
var seen: bool

func _ready():
	bresenham = tile_map.local_to_map(global_position)

func validateInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func animateMovement():
	if velocity.length() == 0:
		animation.stop()
	else:
		var direAnim = "Walk_down"
		direccionHitDamage = "DOWN"
		marker.rotation = deg_to_rad(0)
		hitboxDamage.rotation = deg_to_rad(0)
		sprite.flip_h = false
		if velocity.x < 0:
			direAnim = "Walk_right"
			direccionHitDamage = "LEFT"
			marker.rotation = deg_to_rad(90)
			hitboxDamage.rotation = deg_to_rad(90)
			sprite.flip_h = true
		elif velocity.x > 0:
			direAnim = "Walk_right"
			direccionHitDamage = "RIGHT"
			marker.rotation = deg_to_rad(-90)
			hitboxDamage.rotation = deg_to_rad(-90)
		elif velocity.y < 0:
			direAnim = "Walk_up"
			direccionHitDamage = "UP"
			marker.rotation = deg_to_rad(180)
			hitboxDamage.rotation = deg_to_rad(180)
		animation.play(direAnim)

func _physics_process(delta):
	var position = tile_map.local_to_map(global_position)
	var tile_data = tile_map.get_cell_tile_data(0, position)
	if tile_data == null or tile_data.get_custom_data("safe_zone") == true:
		seen = false
	var rng = RandomNumberGenerator.new()
	var random_pos = rng.randi_range(0, 20)
	if random_pos == 5:
		bresenham = tile_map.local_to_map(global_position)
	
	validateInput()
	animateMovement()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		hitboxDamageScript.setup(self, direccionHitDamage, 1)
		hitboxDamageScript.createDamage()
