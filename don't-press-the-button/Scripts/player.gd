extends CharacterBody3D

@onready var rot = $Rot
@onready var camera = $Rot/Camera3D
var sensitivity = 0.01
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _physics_process(delta: float) -> void:
	
	if %SeeCast.is_colliding():
		var target = %SeeCast.get_collider()
		if target.has_method("interact") and Input.is_action_just_pressed("Click"):
			target.interact()
	
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
