extends Node3D
var makan
var hold = false
@onready var bbb = $pumpkin_orange_small2/pumpkin_orange_small
@onready var player = load("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(SignalBus._2odam)
	SignalBus.global_a7a.connect(_on_global_a7a)
	SignalBus.global_a7ten.connect(_on_global_a7ten)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hold == true:
		global_transform = makan

func _on_global_a7a() -> void:#mesh lift
	queue_free()
func _on_global_a7ten(makan_2odam) -> void: #lift
	if hold == false:
		var old_makan = self.global_transform
		global_transform = makan_2odam
		hold = true
	
	if hold == true:
		makan = makan_2odam
	

func interact():
	print("etakhed")
