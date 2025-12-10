extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0


var facing: bool = true #true == right && false == left

var up: bool = false
var down: bool = false
var left: bool = false
var right: bool = false



func _physics_process(delta: float) -> void:
	
	#handle gameplay input
	if Input.is_action_just_pressed("Up"):
		up = true
	else:
		up = false
		
	if Input.is_action_just_pressed("Down"):
		up = true
	else:
		up = false
		
	if Input.is_action_just_pressed("Left"):
		up = true
	else:
		up = false
		
	if Input.is_action_just_pressed("Right"):
		up = true
	else:
		up = false
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _process(_delta: float) -> void:
	
	pass
