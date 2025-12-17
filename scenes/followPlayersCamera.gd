extends Camera2D

var guy_scene:= preload("res://scenes/guy.tscn")


@export var player1: String
var player1Scene# := CharacterBody2D

@export var player2: String
var player2Scene#  := CharacterBody2D
var playersReady := -1

@export var zoomOffset: float = 3.375
var debug := true
var viewportRect := Rect2()
var cameraRect := Rect2()
var p1lhs := true

var attack1: Attack
var attack2: Attack



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	#for i in 2:
		#print("Getting child " + str(i))
		#print(get_child(i).to_string())
		#get_child(i).player = i + 1
		
		
	
	
	
func _physics_process(_delta: float) -> void:
	#print(playersReady)
	#if(playersReady == 0):
		#get_child(0).set_script(load("res://scenes/newGuy.tscn"))
		#get_child(1).set_script(load("res://scenes/newGuy.tscn"))
	if(playersReady == 2):
		#print("PLAYERS ARE INSTANTIATED")
		print(get_child(0))
		get_child(0).doTheThing(1)
		get_child(0).global_position = Vector2(-50, 0)
		
		print(get_child(1))
		get_child(1).doTheThing(2)
		get_child(1).global_position = Vector2(50, 0)
		
		playersReady += 1
		
	if playersReady == 3:
		if get_child(0).colliding and get_child(1).colliding:
			print("goobagoo")
			if ((get_child(0).direction == 4 and get_child(0).direction == 6) or (get_child(0).direction == 6 and get_child(0).direction == 5)): 
				get_child(0).opposing = true
				get_child(1).opposing = true
			else:
				get_child(0).opposing = false
				get_child(1).opposing = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if playersReady == -1:
		spawn_players()
	if(playersReady == 3):
		if(p1lhs):
			if get_child(0).global_position > get_child(1).global_position:
				get_child(0).flip()
				get_child(1).flip()
				p1lhs = false
		else:
			if get_child(0).global_position < get_child(1).global_position:
				get_child(0).flip()
				get_child(1).flip()
				p1lhs = true
		
		cameraRect = Rect2(get_child(0).global_position, Vector2())
		for i in get_child_count():
			if i == 0:
				continue
			cameraRect = cameraRect.expand(get_child(i).global_position)
		
		offset = calculateCenter(cameraRect)
		zoom = calculateZoom(cameraRect, viewportRect.size)
	
	#if debug:
		#draw_rect(cameraRect, Color("#ffffff"), true)
		#draw_circle(calculateCenter(cameraRect), 5, Color("#ffffff"))
	
	
func calculateCenter(rectangle: Rect2) -> Vector2:
	return Vector2(
		rectangle.position.x + rectangle.size.x / 2,
		rectangle.position.y + rectangle.size.y / 2)
		
func calculateZoom(camRect: Rect2, viewSize: Vector2) -> Vector2:
	var maxZoom = max(
		max(3.5, camRect.size.x / viewSize.x + zoomOffset),
		max(3.5, camRect.size.y / viewSize.y + zoomOffset))
	
	return Vector2(maxZoom, maxZoom)
	
func receiveAttack(_attack: Attack, from: int):
	if from == 1:
		attack1 = _attack
	else:
		attack2 = _attack
		
func spawn_players():
	playersReady = 0
	match player1:
		"Guy":
			#var scene := load("res://scenes/guy.tscn")
			player1Scene = guy_scene.instantiate()
			print(is_editable_instance(player1Scene))
			set_editable_instance(player1Scene, true)
			
			#player1Scene.player = 1
			print(get_tree().current_scene.get_child(0))
			#player1Scene.set_script(load("res://scripts/guy.gd"))
			player1Scene.name = "Guy1"
			add_child(player1Scene)
			
			#print((get_child(0).get_script()))
			#get_child(0).player = 1
			print("made ", get_child(0).to_string())
			
			
	match player2:
		"Guy":
			#var scene := load("res://scenes/guy.tscn")
			player2Scene = guy_scene.instantiate()
			print(is_editable_instance(player2Scene))
			set_editable_instance(player2Scene, true)
			player2Scene.name = "Guy2"
			#player2Scene.player = 2
			add_child(player2Scene)
			#print((get_child(1).to_string()))
			#get_child(1).player = 2
			print("made ",  get_child(1).to_string())
			
	#player1Scene.global_position = Vector2(-50, 0)
	#player2Scene.global_position = Vector2(50, 0)
	viewportRect = get_viewport_rect()
	set_process(get_child_count() > 0)
	print(str(get_child_count()))
	#playersReady = 0
	



func _on_draw() -> void:
	if not debug:
		return
		
	
	
	
