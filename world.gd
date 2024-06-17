extends Node3D

@onready var player = $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	get_tree().call_group("enemy", "update_target_loc", player.global_position)
	
	if Input.is_action_just_pressed("push"):
		get_tree().call_group("pushable", "get_pushed",  player.global_position)
		print("Go away!!!")
	
