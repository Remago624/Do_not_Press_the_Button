extends StaticBody3D

@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree


func interact():
	anim_tree["parameters/conditions/clicked"] = true
	print("a7a")
	await get_tree().create_timer(0.3).timeout
	anim_tree["parameters/conditions/clicked"] = false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
