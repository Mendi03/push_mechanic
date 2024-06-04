extends CharacterBody3D

@onready var player = $"."

var enemies = []
var can_push = false

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const PUSH_FORCE = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var mouse_sensitivity = 0.15 / (get_viewport().get_visible_rect().size.x/1152.0)
@onready var cam = $Camera3D


# test stuff:

var enemy

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Code for pushing away npcs
	if Input.is_action_just_pressed("push"):
		if can_push:
			push()

	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y += event.relative.x * -mouse_sensitivity
		cam.rotation_degrees.x += event.relative.y * -mouse_sensitivity
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)



func _on_area_3d_body_entered(body):
	print(body)
	print("colliding")
	enemies.append(body)
	enemy = body
	if body.is_in_group("enemy"):
		can_push = true
		if Input.is_action_just_pressed("push"):
			print("Go away!!!")
 # Replace with function body.


func _on_area_3d_body_exited(body):
	print(body)
	print("Not colliding")
	if body.is_in_group("enemy"):
		can_push = false
	 # Replace with function body.

func push():
	print(enemy.velocity)
	
	# commenting out the rest except the following line works!!!! 
	#enemy.velocity *= -PUSH_FORCE
	
	var player_loc = global_position
	var enemy_loc = enemy.global_position
	
	var new_velocity = (enemy_loc - player_loc).normalized() * PUSH_FORCE
	enemy.velocity = new_velocity
	
	#print(len(enemies))
	#for i in enemies:
		##if i == len(enemies):
			##return
		##elif i < len(enemies):
		#var enemy_loc = enemies[i].global_position
		#var new_velocity = (enemy_loc - player_loc).normalized() * PUSH_FORCE
		##enemy.velocity = velocity.move_toward(new_velocity, 0.25)
		#enemies[i].velocity = new_velocity
	#
	print("Go away!!!")
