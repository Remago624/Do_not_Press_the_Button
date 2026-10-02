extends Node3D

@onready var inst_1 = $Node3D/Shop/CSGCylinder3D3/display1
@onready var inst_2 = $Node3D/Shop/CSGCylinder3D2/display2
@onready var inst_3 = $Node3D/Shop/CSGCylinder3D4/display3


var shop_items = [
	preload("res://Scenes/Pumpkin.tscn"),
	preload("res://Scenes/lantern.tscn"),
	preload("res://Scenes/Post_skull.tscn"),
	preload("res://Scenes/Skull_candle.tscn")
]
var instance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var displays = [
		inst_1,
		inst_2,
		inst_3
	]
	for i in range(3):
		var index = randi_range(0, 3)
		instance = shop_items[index].instantiate()
		$Node3D.add_child(instance)
		instance.global_position = displays[i].global_position
		print(i, "ayaaaa")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
