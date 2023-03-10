extends CharacterBody3D
#extends KinematicBody


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var FirstPerson = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _spring_arm := $SpringArm3D
@onready var _model := $CollisionShape3D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (_spring_arm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		_model.rotation.y = look_direction.angle()
	
	if Input.is_action_just_pressed("SwitchCam"):
		if FirstPerson:
			_spring_arm.spring_length = 7
			FirstPerson = false
		else:
			_spring_arm.spring_length = 0.0
			FirstPerson = true
			
func _process(_delta: float):
	_spring_arm.position = position
