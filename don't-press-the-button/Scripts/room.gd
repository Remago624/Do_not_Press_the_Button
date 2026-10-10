extends Node3D

@onready var inst_1 = $Node3D/Shop/CSGCylinder3D3/display1
@onready var inst_2 = $Node3D/Shop/CSGCylinder3D2/display2
@onready var inst_3 = $Node3D/Shop/CSGCylinder3D4/display3
@onready var player = $Player
@onready var player_SeeCast = $Player/Rot/Camera3D/SeeCast
@onready var monster = $Very_very_scary_monster
var monster_starter_position

var shop_items = [
	load("res://Scenes/bench_decorated.tscn"),
	load("res://Scenes/bench_mark.tscn"),
	load("res://Scenes/candle.tscn"),
	load("res://Scenes/Pumpkin.tscn"),
	load("res://Scenes/lantern.tscn"),
	load("res://Scenes/Post_skull.tscn"),
	load("res://Scenes/Skull_candle.tscn")
]
var spawned_items = []

var instance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_shop()
	monster_starter_position = monster.global_position
	$"Player/CanvasLayer/Timer left".visible = false
	$"Player/CanvasLayer/run".visible = false
	monster.visible = false
	monster.process_mode = Node.PROCESS_MODE_DISABLED
	$"Very_very_scary_monster/Fast Run/Skeleton3D/Ch30/StaticBody3D/CollisionShape3D".disabled = true

func generate_shop() -> void:
	print("betengan")
	var displays = [
		inst_1,
		inst_2,
		inst_3
	]
	for i in range(3):
		print("betengan")
		var index = randi_range(0, 6)
		instance = shop_items[index].instantiate()
		$Node3D.add_child(instance)
		instance.global_position = displays[i].global_position
		spawned_items.append(instance)
		print("betengan", instance,spawned_items)
	SignalBus.spawned_items = spawned_items
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"Player/CanvasLayer/Timer left".text = "%.2f" % $Timer.time_left

func refresh_shop(item_taken):
	SignalBus.coins -= 1
	player_SeeCast.enabled = false
	spawned_items.erase(item_taken)
	for item in spawned_items:
		item.queue_free()
	spawned_items.clear()
	print("betengan, spawned items", spawned_items)
	
	await get_tree().create_timer(0.3).timeout
	$Node3D/AudioStreamPlayer3D.play()
	for i in range(10):
		generate_shop()
		await get_tree().create_timer(0.05).timeout
		clear_shop()
	await get_tree().create_timer(0.5).timeout
	generate_shop()
	player_SeeCast.enabled = true


func clear_shop():
	for item in spawned_items:
		item.queue_free()
	spawned_items.clear()

func monster_spawn():
	monster.visible = true
	monster.process_mode = Node.PROCESS_MODE_INHERIT
	$"Very_very_scary_monster/Fast Run/Skeleton3D/Ch30/StaticBody3D/CollisionShape3D".disabled = false
	


func _on_button_button_pressed() -> void:
	player.global_position = $NavigationRegion3D/Maze/Monster.global_position + Vector3(0,1,0)
	$"Player/CanvasLayer/Timer left".visible = true
	$"Player/CanvasLayer/run".visible = true
	$Timer.start()
	#$"Player/CanvasLayer/Timer left".text = str(ceil($Timer.time_left))


func _on_timer_timeout() -> void:
	$"Player/CanvasLayer/Timer left".visible = false
	$"Player/CanvasLayer/run".visible = false
	monster_spawn()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("a7aaaa")
		player.global_position = $Node3D/CSGCylinder3D/Button.global_position
		$NavigationRegion3D/Maze/Monster.global_position
		monster.visible = false
		monster.process_mode = Node.PROCESS_MODE_DISABLED
		$"Very_very_scary_monster/Fast Run/Skeleton3D/Ch30/StaticBody3D/CollisionShape3D".disabled = true
		SignalBus.coins += 10


func _on_player_etakhed(body: Node3D) -> void:
	if body.is_in_group("player"):
		$AudioStreamPlayer3D.play()
		$Player/Rot/Camera3D.current = false
		$Very_very_scary_monster2/Camera3D.current = true
		player.global_position = $Marker3D.global_position
		$Player/CanvasLayer/Label.visible = false
		await get_tree().create_timer(3.0).timeout
		monster.global_rotation = monster_starter_position
		monster.visible = false
		monster.process_mode = Node.PROCESS_MODE_DISABLED
		$"Very_very_scary_monster/Fast Run/Skeleton3D/Ch30/StaticBody3D/CollisionShape3D".disabled = true
		$Player/Rot/Camera3D.current = true
		$Very_very_scary_monster2/Camera3D.current = false
		SignalBus.coins = 0
		$Player/CanvasLayer/Label.visible = true
		
		
		
		#this is zarting
		#$"Very_very_scary_monster/Fast Run/Skeleton3D/Ch30/StaticBody3D".set_collision_layer_value(1, false)
		#$"Very_very_scary_monster/Fast Run/Skeleton3D/Ch30/StaticBody3D".set_collision_mask_value(1, false)
		#$"Very_very_scary_monster/Fast Run/AnimationPlayer".play("Take 001")
		#$"Fast Run/Skeleton3D/Ch30/StaticBody3D/Area3D/CollisionShape3D".disabled = true
		#$NavigationRegion3D.enabled = false
		#monster.process_mode = Node.PROCESS_MODE_INHERIT
		#player.global_position = $Marker3D.global_position
		#monster.global_position = $Player/Marker3D.global_position
		#monster.global_rotation = $Player/Marker3D.global_rotation
		#$Player/Rot/Camera3D.look_at($Very_very_scary_monster/Marker3D.global_position)
