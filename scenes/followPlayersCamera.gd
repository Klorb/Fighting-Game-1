extends Camera2D

@export var zoomOffset: float = 3.375
var debug := true
var viewportRect := Rect2()
var cameraRect := Rect2()
var p1lhs := true

var attack1: Attack
var attack2: Attack



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewportRect = get_viewport_rect()
	set_process(get_child_count() > 0)
	
	for i in 2:
		get_child(i).player = i + 1
	
	
func _physics_process(_delta: float) -> void:
	if get_child(0).colliding and get_child(1).colliding:
		if ((get_child(0).direction == 4 and get_child(0).direction == 6) or (get_child(0).direction == 6 and get_child(0).direction == 5)): 
			get_child(0).opposing = true
			get_child(1).opposing = true
		else:
			get_child(0).opposing = false
			get_child(1).opposing = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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



func _on_draw() -> void:
	if not debug:
		return
		
	
	
	
