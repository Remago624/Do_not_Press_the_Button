extends Node3D
var makan
var hold = false
var old_R
@onready var bbb = $pumpkin_orange_jackolantern/pumpkin_orange_jackolantern
@onready var player = load("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(SignalBus._2odam)
	SignalBus.global_a7a.connect(_on_global_a7a)
	SignalBus.global_a7ten.connect(_on_global_a7ten)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hold == true:
		global_position = makan
		$CollisionShape3D.disabled = true
		if Input.is_action_pressed("LM"):
			rotate_y(deg_to_rad(1))
		if Input.is_action_pressed("RM"):
			rotate_y(deg_to_rad(-1))
		if Input.is_action_pressed("R"):
			rotate_x(deg_to_rad(1))
		if Input.is_action_pressed("Q"):
			rotate_x(deg_to_rad(-1))
		
		if Input.is_action_just_pressed("R_reset"):
			global_rotation = old_R
			#rotation.x = 0
			#rotation.y = 0
		
		
		if Input.is_action_just_pressed("Click"):
			print("test")
			hold = false
			$CollisionShape3D.disabled = false

func _on_global_a7a() -> void:#not lift but mekhalel gazar
	queue_free()
func _on_global_a7ten(makan_2odam) -> void: #lift
	pass
	#if hold == false:
		#var old_makan = self.global_position
		#global_position = makan_2odam
		#hold = true
		#old_R = global_rotation
	#
	#if hold == true:
		#makan = makan_2odam
	

func interact(makan_2odam):
	if hold == false:
		var old_makan = self.global_position
		global_position = makan_2odam
		hold = true
		old_R = global_rotation
	
	if hold == true:
		makan = makan_2odam
	print("etakhed")
