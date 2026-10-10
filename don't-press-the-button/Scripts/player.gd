extends CharacterBody3D

var target
var somethinghold
var hold = false
@onready var rot = $Rot
@onready var camera = $Rot/Camera3D
@onready var _2odam = $"Rot/Camera3D/2odam"
var coins = SignalBus.coins
var sensitivity = 0.01
var SPEED = 5.0
var run_speed = 8.0
var normal_speed = 5.0
const JUMP_VELOCITY = 4.5
var flash_ = true
signal item_bought

func _ready() -> void:
	$CanvasLayer/BoxContainer/Label.visible = false
	print("666666")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	
	
	$CanvasLayer/Label.text = "You have " + str(SignalBus.coins) + " coins"
	if Input.is_action_just_pressed("Flash light") and flash_ == true:
		flash_ = false
		$Rot/Camera3D/MeshInstance3D2/SpotLight3D.light_energy = 0.0
	elif Input.is_action_just_pressed("Flash light") and flash_ == false:
		flash_ = true
		$Rot/Camera3D/MeshInstance3D2/SpotLight3D.light_energy = 7.0
	#if Input.is_action_just_pressed("esc"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var from = camera.global_position
	var to = from + -camera.global_transform.basis.z * 1000.0
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var space = get_world_3d().direct_space_state
	var result = space.intersect_ray(query)
	var hit_see_target = to
	
	if !result.is_empty():
		hit_see_target = result.position
		print(result)
		print(hit_see_target)
	else:
		hit_see_target = from + -camera.global_transform.basis.z * 35.0
	
	if Input.is_action_just_pressed("Click") and hold == true:
			hold = false
	
	if %SeeCast.is_colliding():
		target = %SeeCast.get_collider()
		if target != null:
			if target.has_method("interact") or target.has_method("pressed"):
				$CanvasLayer/BoxContainer/Label.visible = true
			else:
				$CanvasLayer/BoxContainer/Label.visible = false
		
		if target != null and target.has_method("interact") and Input.is_action_just_pressed("Click") and !target in SignalBus.spawned_items:
			target.interact(hit_see_target)
			hold = true
			somethinghold = target
		if target != null and target.has_method("interact") and Input.is_action_just_pressed("Click") and SignalBus.coins > 0:
			target.interact(hit_see_target)
			hold = true
			somethinghold = target
			if target in SignalBus.spawned_items:
				print(target,"77777776777")
				if SignalBus.coins > 0:
					item_bought.emit(target)
		if target != null and target.has_method("pressed") and Input.is_action_just_pressed("Click"):
			target.pressed()
	else:
		$CanvasLayer/BoxContainer/Label.visible = false
	
	if hold == true:
		somethinghold.interact(hit_see_target)
		if Input.is_action_just_pressed("esc"):
			hold = false

	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("Run"):
		SPEED = run_speed
	else:
		SPEED = normal_speed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (rot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		rot.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _a7a():
	SignalBus.global_a7a.emit()
func _a7ten(hit_see_target):
	SignalBus.global_a7ten.emit(hit_see_target)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
