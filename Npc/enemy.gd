extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const SPEED = 1.0
const PUSH_FORCE = 6.0

func _ready():
	# Make sure to not await during _ready.
	call_deferred("move_towards_player")

func _physics_process(_delta):
	move_towards_player()
	
func move_towards_player():
	var current_loc = global_position
	
	await get_tree().physics_frame
	var next_loc = nav_agent.get_next_path_position()
	var new_velocity = (next_loc - current_loc).normalized() * SPEED
	
	velocity = velocity.move_toward(new_velocity, 0.25)
	
	move_and_slide()

func update_target_loc(target_loc):
	nav_agent.target_position = target_loc  
	
#func set_og_location(spawn_point):
	#og_location = spawn_point
func get_pushed(target_loc):
	var current_loc = global_position
	var player_loc = target_loc
	var new_velocity2 = (current_loc - player_loc).normalized() * PUSH_FORCE
	
	velocity = new_velocity2 
	
func get_location():
	return global_position
