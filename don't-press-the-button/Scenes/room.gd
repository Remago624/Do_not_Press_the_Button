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
var spawned_items = []

var instance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_shop()

func generate_shop() -> void:
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
		spawned_items.append(instance)
	SignalBus.spawned_items = spawned_items
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refresh_shop(item_taken):
	spawned_items.erase(item_taken)
	for item in spawned_items:
		item.queue_free()
	spawned_items.clear()
	
	await get_tree().create_timer(0.3).timeout
	for i in range(10):
		generate_shop()
		await get_tree().create_timer(0.1).timeout
		clear_shop()
	await get_tree().create_timer(0.5).timeout
	generate_shop()


func clear_shop():
	for item in spawned_items:
		item.queue_free()
	spawned_items.clear()
