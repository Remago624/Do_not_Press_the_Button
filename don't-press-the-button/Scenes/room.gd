extends Node3D

@onready var inst_1 = $Node3D/CSGCylinder3D3/inst_1
@onready var inst_2 = $Node3D/CSGCylinder3D2/inst_2
@onready var inst_3 = $Node3D/CSGCylinder3D4/inst_3

var pumpkin = preload("res://Scenes/Pumpkin.tscn")
var instance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = pumpkin.instantiate()
	$Node3D.add_child(instance)
	instance.global_position = inst_1.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
