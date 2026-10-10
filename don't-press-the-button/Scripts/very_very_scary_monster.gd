extends Node3D

@onready var anim_player = $"Fast Run/AnimationPlayer"
@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent = $NavigationAgent3D
@onready var betengan_mekhalel = $"."
var speed = 4.0
var monster_position
var player_position

func _ready() -> void:
	anim_player.speed_scale = 0.4
	var run_anim = anim_player.get_animation("mixamo_com")
	run_anim.loop_mode = Animation.LOOP_LINEAR
	anim_player.play("mixamo_com")
func _physics_process(delta: float) -> void:
	
	if player:
		nav_agent.target_position = player.global_position
		print(nav_agent.is_navigation_finished(), "123456789")
		
		monster_position = global_position
		player_position = player.global_position
		monster_position.y = 0
		player_position.y = 0
		var distance_between = monster_position.distance_to(player_position)
		print(distance_between, "distance_between")
		if distance_between <= 25.0:
			anim_player.speed_scale = 0.8
			speed = 7.9
			$"../Player/Rot/Camera3D/MeshInstance3D2/SpotLight3D".light_color = Color.RED
		else:
			$"../Player/Rot/Camera3D/MeshInstance3D2/SpotLight3D".light_color = Color.WHITE
			anim_player.speed_scale = 0.4
			speed = 7.0
		
		if not nav_agent.is_navigation_finished():
			var next_position = nav_agent.get_next_path_position()
			print("Monster: ", global_position)
			print("Next: ", next_position)
			var direction = global_position.direction_to(next_position)
			direction.y = 0
			look_at(Vector3(next_position.x, global_position.y, next_position.z))
			global_position += direction * speed * delta
