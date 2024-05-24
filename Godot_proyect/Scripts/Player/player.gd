extends CharacterBody2D

class_name Player

@export var speed: int = 100
@export var typeDamage = 1
@export var maxHealth = 5

@onready var animation = $AnimationPlayer
@onready var sprite = $PlayerSprite
@onready var animationTree = $AnimationTree
@onready var interactionmarker = $Marker2D
@onready var actionArea = $Marker2D/Area2D
@onready var tile_map = $"../DungeonRoom"
@onready var hitboxDamage = $hurtbox
@onready var currentHealth: int = maxHealth
@onready var dataNode = get_node("../../DataController")

var nearestActionable: ActionArea
var moveDirection = Vector2.ZERO
var canMove = true
var hitbox = true
var direccionHitDamage = "DOWN"
var hitboxDamageScript: PlayerHitboxDamage = PlayerHitboxDamage.new()
var bresenham: Vector2
var seen: bool

func _ready():
	animationTree.active = true
	bresenham = tile_map.local_to_map(global_position)
	dataNode.dataChange.connect(_on_data_change)
	_on_data_change()

func _on_data_change():
	currentHealth = dataNode.health

func validateInput():
	moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func animateMovement():
	if velocity.length() == 0:
		animationTree["parameters/conditions/Idleing"] = true
		animationTree["parameters/conditions/Walking"] = false
	else:
		animationTree["parameters/conditions/Idleing"] = false
		animationTree["parameters/conditions/Walking"] = true
		if velocity.y > 0: 
			direccionHitDamage = "DOWN"
			interactionmarker.rotation = deg_to_rad(0)
		if velocity.x < 0:
			direccionHitDamage = "LEFT"
			interactionmarker.rotation = deg_to_rad(90)
		elif velocity.x > 0:
			direccionHitDamage = "RIGHT"
			interactionmarker.rotation = deg_to_rad(-90)
		elif velocity.y < 0:
			direccionHitDamage = "UP"
			interactionmarker.rotation = deg_to_rad(180)
		animationTree["parameters/Idle/blend_position"] = moveDirection
		animationTree["parameters/Walk/blend_position"] = moveDirection
		animationTree["parameters/Shield/blend_position"] = moveDirection
		animationTree["parameters/Attack/blend_position"] = moveDirection

func _physics_process(delta):
	var position = tile_map.local_to_map(global_position)
	var tile_data = tile_map.get_cell_tile_data(0, position)
	if tile_data == null or tile_data.get_custom_data("safe_zone") == true:
		seen = false
	var rng = RandomNumberGenerator.new()
	var random_pos = rng.randi_range(0, 20)
	if random_pos == 5:
		bresenham = tile_map.local_to_map(global_position)
	
	if canMove == true or Input.is_action_pressed("ui_shield"):
		validateInput()
		animateMovement()
		move_and_slide()
		check_accionables()

func check_accionables() -> void:
	var areas: Array[Area2D] = actionArea.get_overlapping_areas()
	var shortDistance: float = INF
	var nextActionable: ActionArea = null
	for area in areas:
		var distance: float = area.global_position.distance_to(global_position)
		if distance < shortDistance:
			shortDistance = distance
			nextActionable = area
			
	if nextActionable != null:
		if nextActionable != nearestActionable or not is_instance_valid(nextActionable):
			nearestActionable = nextActionable
			print(nearestActionable)
	else: 
		nearestActionable = null

func _unhandled_input(event: InputEvent) -> void:
	if canMove == true:
		if event.is_action_pressed("ui_select"):
			attack_animation()
			hitboxDamageScript.setup(self.get_parent(), hitboxDamage, direccionHitDamage, 1)
			hitboxDamageScript.createDamage()
		if event.is_action_pressed("ui_accept") and nearestActionable != null:
			if is_instance_valid(nearestActionable):
				nearestActionable.emit_signal("actionated")
		if event.is_action_pressed("ui_shield"):
			hitbox = false
			shield_animation()
			speed = 30
		if event.is_action_released("ui_shield"):
			hitbox = true
			stop_shield_animation()
			speed = 100

func attack_animation(): 
	animationTree["parameters/conditions/Attacking"] = true
	animationTree["parameters/conditions/Idleing"] = false
	animationTree["parameters/conditions/Walking"] = false
	canMove = false
	await get_tree().create_timer(0.2).timeout
	animationTree["parameters/conditions/Attacking"] = false
	canMove = true

func shield_animation(): 
	animationTree["parameters/conditions/Shielding"] = true
	animationTree["parameters/conditions/Idleing"] = false
	animationTree["parameters/conditions/Walking"] = false

func stop_shield_animation(): 
	animationTree["parameters/conditions/Shielding"] = false
	if moveDirection == Vector2.ZERO:
		animationTree["parameters/conditions/Idleing"] = true
	else:
		animationTree["parameters/conditions/Walking"] = true

func _on_hurtbox_area_entered(area):
	if area.name == "hitbox":
		if currentHealth == 1:
			get_tree().quit()
		dataNode.set_health(dataNode.health - 1)
		if currentHealth < 0:
			currentHealth = maxHealth
		print_debug(currentHealth)
