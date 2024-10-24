extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	
	if abs(velocity.x) > .1 and $AnimatedSprite2D.animation != "Run":
		$AnimatedSprite2D.play("Run")
	elif abs(velocity.x) < .1 and $AnimatedSprite2D.animation != "Idle":
		$AnimatedSprite2D.play("Idle")
		
		
	if(velocity.x > 0):
		$AnimatedSprite2D.scale.x = 2.25
	elif (velocity.x < 0):
		$AnimatedSprite2D.scale.x = -2.25

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Backward", "Forward")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#
		
	

	move_and_slide()
