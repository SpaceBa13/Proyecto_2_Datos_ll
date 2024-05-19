extends Control

var dataNode

@onready var lbCoin = $UIStats/Panel/Label
@onready var health = $UIHealthContainer/FullLife
func _ready():
	dataNode = get_node("../../../DataController")
	dataNode.dataChange.connect(updateData)
	updateData()

func updateData():
	handleActualObject()
	handleHealthContainers()
	handleStats()
	handleMap()

func handleActualObject():
	pass

func handleHealthContainers():
	health.size.x = (dataNode.health * 127)

func handleStats():
	lbCoin.text = str(dataNode.coins)

func handleMap():
	pass
