extends Node2D

@export var objects: Array[PackedScene]
@onready var area = $ActionArea
@onready var anim = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area.actionated.connect(actioned)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func actioned():
	anim.play("open")
	await get_tree().create_timer(0.6).timeout
	queue_free()
