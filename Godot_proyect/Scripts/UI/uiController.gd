extends Control

@onready var lbCoin = $UIStats/Panel/Label
@onready var health = $UIHealthContainer/FullLife
@onready var dataNode = get_node("../../../DataController")

func _ready():
	dataNode.dataChange.connect(updateData)
	updateData()

func updateData():
	handleHealthContainers()
	handleStats()

func handleHealthContainers():
	health.size.x = (dataNode.health * 127)

func handleStats():
	lbCoin.text = str(dataNode.coins)
