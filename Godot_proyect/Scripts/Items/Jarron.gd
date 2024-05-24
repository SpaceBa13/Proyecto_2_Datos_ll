extends Node2D

@onready var anim = $AnimatedSprite2D
var currentHealth = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("deafult")




func _on_area_2d_area_entered(area):
	if area.name == "Swordbox":
		currentHealth -= 1
		if currentHealth == 0:
			anim.play("breaking")
			await get_tree().create_timer(0.6).timeout
			queue_free()
			
