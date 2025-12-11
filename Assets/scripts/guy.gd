extends CharacterBody2D


const SPEED = 75.0
const JUMP_VELOCITY = -400.0




var vertical: float = 0.0
var horizontal: float = 0.0

var jumping: bool = false
var crouching: bool = false
var attacking: bool = false
var facing: bool = false #true == left && false == right
var direction := 5.0

var framesList: Array[int]
var directionList: Array[float]
var buttonList = []



@onready var sprite = $AnimatedSprite2D


func _ready() -> void:
	for i in 10:
		buttonList.append([])
		directionList.append(-1)
		framesList.append(-1)
		for j in 6:
			buttonList[i].append(0)


func _physics_process(delta: float) -> void:
	
	#handle gameplay input
	vertical = Input.get_axis("Down", "Up")
	horizontal = Input.get_axis("Left", "Right")
	
	fill_list()
	handle_input()
	handle_attacks()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
func _process(_delta: float) -> void:
	if not attacking:
		if horizontal < 0:
			if facing:
				sprite.play("walk")
			else:
				sprite.play_backwards("walk")
		elif horizontal > 0:
			if facing:
				sprite.play_backwards("walk")
			else:
				sprite.play("walk")
		else:
			sprite.play("stand")
	
	
	
func fill_list() -> void:
	
	var same = true
	
	direction = 5.0
	if vertical:
		direction += 3 * vertical
	if horizontal:
		direction += 1 * horizontal
	
	var newButtons: Array[int] = [0, 0, 0, 0, 0, 0]
	if Input.is_action_pressed("LP"):
		newButtons[0] = 1
	if Input.is_action_pressed("MP"):
		newButtons[1] = 1
	if Input.is_action_pressed("HP"):
		newButtons[2] = 1
	if Input.is_action_pressed("LK"):
		newButtons[3] = 1
	if Input.is_action_pressed("MK"):
		newButtons[4] = 1
	if Input.is_action_pressed("HK"):
		newButtons[5] = 1
		
	if direction != directionList[0]:
		same = false
	if same:
		for i in 6:
			if buttonList[0][i] != newButtons[i]:
				same = false
				break
	if same:
		framesList[0] += 1
	else:
		buttonList.push_front(newButtons)
		framesList.push_front(1)
		directionList.push_front(direction)
	
	for i in 10:
		var printString = "" 
		
		printString += str(framesList[i])
		printString += ", "
		
		printString += str(direction)
		printString += ", "
		
		for j in 6:
			printString += str(buttonList[i][j])
			
		
		
		print(printString)
	

func handle_input() -> void:
	if jumping && is_on_floor():
		jumping = false
		
	if Input.is_action_just_pressed("flip"):
		facing = !facing
		sprite.flip_h = facing
		
		
	
		
	
	#move
	if not attacking && not jumping && not crouching:
		if horizontal:
			velocity.x = horizontal * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if (7.0 <= direction && direction <= 9.0): 
			jumping = true
			velocity.y = JUMP_VELOCITY
	
	
func handle_attacks() -> void:
	
	
	if not jumping && not attacking:
		if (Input.is_action_just_pressed("LP") || Input.is_action_just_pressed("MP") || Input.is_action_just_pressed("HP") || 
		Input.is_action_just_pressed("LK") || Input.is_action_just_pressed("MK") || Input.is_action_just_pressed("HK")):
			check_list()
			attacking = true
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	
	
	

func check_list() -> void:
	#find motion input
	#attach button press to motion input
	#
	pass






func _on_animated_sprite_2d_animation_finished() -> void:
	if attacking:
		attacking = false
