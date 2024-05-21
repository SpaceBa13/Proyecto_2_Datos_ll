extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var particles = $AnimatedSprite2D2
func _ready():
	animation.play("default")
	particles.play("default")
	
