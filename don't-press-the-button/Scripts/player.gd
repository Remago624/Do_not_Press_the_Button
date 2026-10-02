extends CharacterBody3D


var hold = false
@onready var rot = $Rot
@onready var camera = $Rot/Camera3D
@onready var _2odam = $"Rot/Camera3D/2odam"
var sensitivity = 0.01
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	print(_2odam)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
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
	
	if hold == true:
		_a7ten(hit_see_target)
		
		if Input.is_action_just_pressed("Click"):
			hold = false
	
	if %SeeCast.is_colliding():
		var target = %SeeCast.get_collider()
		if target.has_method("interact") and Input.is_action_just_pressed("Click"):
			target.interact()
			if target.has_method("_on_global_a7ten"):
				_a7ten(_2odam.global_position)
				hold = true
	

	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (rot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
