extends CharacterBody2D

#class_name Guy



const SPEED = 55.0
const JUMP_VELOCITY = -400.0

@export var player: int




var vertical: float = 0.0
var horizontal: float = 0.0

var jumping: bool = false
var crouching: int = 0
var attacking: bool = false
var facing: bool = false #true == left && false == right
var direction := 5.0
var colliding := false
var opposing := false

var hitstunTimer := 0

var currentAttack:= Attack.new("", 0, 0, 0, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0])
var attackTimer := 0
var hitboxStage := 0

var framesList: Array[int]
var directionList: Array[float]
var buttonList = []

var attacks = GuyAttacks.new()
var inputMap: DirectionsResource



@onready var sprite = $AnimatedSprite2D
#@onready var hud = $Camera2D/CanvasLayer/Hud
@onready var hurtbox = $HurtBox/CollisionShape2D
@onready var hitbox = $Hitbox/CollisionShape2D2
@onready var hitboxArea = $Hitbox


func _enter_tree() -> void:
	print("Entering Tree")


func _ready() -> void:
	print("readying")
	hitbox.disabled = true
	for i in 10:
		buttonList.append([])
		directionList.append(-1)
		framesList.append(-1)
		for j in 6:
			buttonList[i].append(0)
	
	
	get_parent().playersReady += 1
	print("player ", get_parent().playersReady, " ready")
	set_physics_process(false)
	set_process(false)
	
	


func _physics_process(delta: float) -> void:
	
	#handle gameplay input
	vertical = Input.get_axis(inputMap.down, inputMap.up)
	horizontal = Input.get_axis(inputMap.left, inputMap.right)
	
	fill_list()
	handle_input()
	handle_attacks()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if crouching:
		print("crouch hitbox " + str(player))
		hurtbox.shape.size = Vector2(18, 35.5)
		hurtbox.position = Vector2(0, 13.5)
	elif jumping:
		print("jumping hitbox " + str(player))
		hurtbox.shape.size = Vector2(18, 47.5)
		hurtbox.position = Vector2(0, 0)
	else:
		print("standing hitbox " + str(player))
		hurtbox.shape.size = Vector2(18, 55)
		hurtbox.position = Vector2(0, 4)
		
	if hitstunTimer == 0:
		if colliding and not jumping:
			if facing:
				velocity.x += 37.5
			else:
				velocity.x -= 37.5
			if opposing:
				velocity.x = 0
				
		if attackTimer != 0: #attacking
			#print("attackTimer")
			if attackTimer <= currentAttack.getTotalFrames():
				#print(str(attackTimer))
				if attackTimer == currentAttack.getFramesAt(hitboxStage):
					#print("advancing in hitbox stage")
					if currentAttack.getHitboxSizeAt(hitboxStage * 2) == 0:
						hitbox.disabled = true
					else:
						hitbox.disabled = false
						hitbox.shape.size = Vector2(currentAttack.getHitboxSizeAt(hitboxStage * 2), currentAttack.getHitboxSizeAt((hitboxStage * 2) + 1 ))
						if !facing:
							hitboxArea.position = Vector2(currentAttack.getHitboxPositionAt(hitboxStage * 2), currentAttack.getHitboxPositionAt((hitboxStage * 2) + 1))
						else:
							hitboxArea.position = Vector2(-currentAttack.getHitboxPositionAt(hitboxStage * 2), currentAttack.getHitboxPositionAt((hitboxStage * 2) + 1))
					hitboxStage += 1
				attackTimer += 1
			else:
				attacking = false
				attackTimer = 0
			
	else:
		hitstunTimer -= 1
		
	

	
	move_and_slide()
	
func _process(_delta: float) -> void:
	if hitstunTimer == 0:
		if not attacking and not jumping:
			if crouching == 0:
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
			elif crouching == 4:
				crouching = 0
				sprite.play("crouch up")
				
			if direction < 4.0:
				if crouching == 1:
					crouching = 2
					sprite.play("crouch down")
				elif crouching == 3:
					if sprite.animation != ("crouch idle"):
						sprite.play("crouch idle")
		elif attacking:
			if(sprite.animation != currentAttack.getName()):
				sprite.play(currentAttack.getName())
	
					
				
			
		if not attacking and jumping:
			if velocity.y < 0:
				if sprite.animation != "jump":
					sprite.play("jump")
			else:
				if sprite.animation != "fall":
					sprite.play("fall")
				
	else:
		sprite.play("m_m_hurt")
		
			
	
	
	
func fill_list() -> void:
	
	var same = true
	
	direction = 5.0
	if vertical:
		direction += 3 * vertical
	if horizontal:
		direction += 1 * horizontal
	
	var newButtons: Array[int] = [0, 0, 0, 0, 0, 0]
	if Input.is_action_pressed(inputMap.lp):
		newButtons[0] = 1
	if Input.is_action_pressed(inputMap.mp):
		newButtons[1] = 1
	if Input.is_action_pressed(inputMap.hp):
		newButtons[2] = 1
	if Input.is_action_pressed(inputMap.lk):
		newButtons[3] = 1
	if Input.is_action_pressed(inputMap.mk):
		newButtons[4] = 1
	if Input.is_action_pressed(inputMap.hk):
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
		#hud.updateListFrame()
	else:
		buttonList.push_front(newButtons)
		framesList.push_front(1)
		directionList.push_front(direction)
		#hud.updateListInput(direction, newButtons)
	
	#for i in 10:
		#var printString = "" 
		#
		#printString += str(framesList[i])
		#printString += ", "
		#
		#printString += str(direction)
		#printString += ", "
		#
		#for j in 6:
			#printString += str(buttonList[i][j])
			#
		#
		#
		#print(printString)
	

func handle_input() -> void:
	if jumping && is_on_floor():
		jumping = false
	
	if Input.is_action_just_pressed("flip"):
		facing = !facing
		sprite.flip_h = facing
		for i in 10:
			var printString = "" 
			
			printString += str(framesList[i])
			printString += ", "
			
			printString += str(directionList[i])
			printString += ", "
			
			for j in 6:
				printString += str(buttonList[i][j])
				
			#print(printString)
	
	#move
	if not attacking && not jumping:
		if direction < 4.0:
			if crouching == 0:
				#print("start crouching")
				crouching = 1
		elif crouching == 3:
			crouching = 4
		if crouching == 0:
			if horizontal:
				velocity.x = horizontal * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				
			if (7.0 <= direction && direction <= 9.0): 
				#print("jumping")
				jumping = true
				velocity.y = JUMP_VELOCITY
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	
func handle_attacks() -> void:
	if not jumping && not attacking:
		if (Input.is_action_just_pressed(inputMap.lp) || Input.is_action_just_pressed(inputMap.mp) || Input.is_action_just_pressed(inputMap.hp) || 
		Input.is_action_just_pressed(inputMap.lk) || Input.is_action_just_pressed(inputMap.mk) || Input.is_action_just_pressed(inputMap.hk)):
			match check_list():
				1:
					if buttonList[0][0]: #punch
						if facing:
							print("light hado")
							print("attack start")
							attacking = true
							sendAttack(attacks.l_hado)
						else:
							print("light firehands")
					elif buttonList[0][1]: #punch
						if facing:
							print("medium hado")
						else:
							print("medium firehands")
					elif buttonList[0][2]: #punch
						if facing:
							print("heavy hado")
						else:
							print("heavy firehands")
					elif buttonList[0][3]: #kick
						if facing:
							print("light demon flip")
						else:
							print("light tatsu")
					elif buttonList[0][4]: #kick
						if facing:
							print("medium demon flip")
						else:
							print("medium tatsu")
					elif buttonList[0][5]: #kick
						if facing:
							print("heavy demon flip")
						else:
							print("heavy tatsu")
				2:
					if buttonList[0][0]: #punch
						if !facing:
							print("light hado")
							print("attack start")
							attacking = true
							sendAttack(attacks.lp)
						else:
							print("light firehands")
					elif buttonList[0][1]: #punch
						if !facing:
							print("medium hado")
						else:
							print("medium firehands")
					elif buttonList[0][2]: #punch
						if !facing:
							print("heavy hado")
						else:
							print("heavy firehands")
					elif buttonList[0][3]: #kick
						if !facing:
							print("light demon flip")
						else:
							print("light tatsu")
					elif buttonList[0][4]: #kick
						if !facing:
							print("medium demon flip")
						else:
							print("medium tatsu")
					elif buttonList[0][5]: #kick
						if !facing:
							print("heavy demon flip")
						else:
							print("heavy tatsu")
				3:
					if buttonList[0]:
						if facing:
							print("light dp")
				4:
					if buttonList[0]:
						if !facing:
							print("light dp")
				_:
					if buttonList[0][0]: #punch
						print("attack start")
						attacking = true
						sendAttack(attacks.lp)
						print("light punch")
					elif buttonList[0][1]: #punch
						print("medium punch")
					elif buttonList[0][2]: #punch
						print("heavy punch")
					elif buttonList[0][3]: #kick
						print("light kick")
					elif buttonList[0][4]: #kick
						print("medium kick")
					elif buttonList[0][5]: #kick
						print("heavy kick")
					else:
						print("no input")
			#attacking = true
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	
	
	

func check_list() -> int:
	var qcl := 3 #return 1
	var qcr := 3 #return 2
	var dpl := 3 #return 3
	var dpr:= 3 #return 4
	var i := 9
	while i >= 0:
		if qcl != -1: # quarter circle left
			if qcl == 3:
				if directionList[i] == 2.0:
					qcl -= 1
				elif directionList[i] == 5.0:
					pass
				else:
					qcl = -1
			elif qcl == 2: # check for down left
				if directionList[i] == 1.0:
					qcl -= 1
				elif directionList[i] == 5.0:
					pass
				else:
					qcl = -1
			elif qcl == 1:
				if directionList[i] == 4.0:
					return 1 # quarter circle left
				elif directionList[i] == 5.0:
					pass
				else:
					qcl = -1
		i -= 1
			
		
		
	return 0


func flip() -> void:
	facing = !facing
	sprite.flip_h = facing



func _on_animated_sprite_2d_animation_finished() -> void:
	
	if crouching == 2:
		print("crouching idle should play")
		crouching = 3
	if sprite.animation == "crouch up":
		sprite.play("stand")
	
	
		
		


func sendAttack(attack: Attack) -> void:
	print("attack sent to main, starting timer")
	get_parent().receiveAttack(attack, player)
	currentAttack = attack
	attackTimer = 1
	hitboxStage  = 0
	
	
	
	

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player2") and player == 1:
		colliding = true
	elif area.is_in_group("player1") and player == 2:
		colliding = true
	if area.is_in_group("player2hitbox") and player == 1:
		match get_parent().attack2.getWeight:
			1:
				hitstunTimer = 10
			2:
				hitstunTimer = 20
			3:
				hitstunTimer = 30
			4: 
				hitstunTimer = 40
			
		attacking = false
		attackTimer = 0
		velocity.x = 0
	elif area.is_in_group("player1hitbox") and player == 2:
		match get_parent().attack1.getWeight:
			1:
				hitstunTimer = 10
			2:
				hitstunTimer = 20
			3:
				hitstunTimer = 30
			4: 
				hitstunTimer = 40
			
		attacking = false
		attackTimer = 0
		velocity.x = 0
		#if facing:
			#velocity.x -= 70
		#else:
			#velocity.x += 70


func doTheThing(numbah: int):
	player = numbah
	inputMap = DirectionsResource.new(player)
	hitbox.add_to_group("player" + str(player) + "hitbox")
	hurtbox.add_to_group("player" + str(player))
	
	if player > 1:
		flip()
	
	set_physics_process(true)
	set_process(true)

func _on_hurt_box_area_exited(area: Area2D) -> void:
	if area.is_in_group("player2") and player == 1:
		colliding = false
	elif area.is_in_group("player1") and player == 2:
		colliding = true
		
		
#func _init(numbah: int):
	#player = numbah
