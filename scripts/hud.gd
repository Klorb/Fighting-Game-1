extends Control

@onready var frames := $"HBoxContainer/Input List/List 0/frames"
@onready var direction := $"HBoxContainer/Input List/List 0/direction"
@onready var buttons := $"HBoxContainer/Input List/List 0/buttons"

@onready var thingsArray: Array[Label] = [
	$"HBoxContainer/Input List/List 1/frames",
	$"HBoxContainer/Input List/List 2/frames",
	$"HBoxContainer/Input List/List 3/frames",
	$"HBoxContainer/Input List/List 4/frames",
	$"HBoxContainer/Input List/List 5/frames",
	$"HBoxContainer/Input List/List 6/frames",
	$"HBoxContainer/Input List/List 7/frames",
	$"HBoxContainer/Input List/List 8/frames",
	$"HBoxContainer/Input List/List 9/frames",
	$"HBoxContainer/Input List/List 1/direction",
	$"HBoxContainer/Input List/List 2/direction",
	$"HBoxContainer/Input List/List 3/direction",
	$"HBoxContainer/Input List/List 4/direction",
	$"HBoxContainer/Input List/List 5/direction",
	$"HBoxContainer/Input List/List 6/direction",
	$"HBoxContainer/Input List/List 7/direction",
	$"HBoxContainer/Input List/List 8/direction",
	$"HBoxContainer/Input List/List 9/direction",
	$"HBoxContainer/Input List/List 1/buttons",
	$"HBoxContainer/Input List/List 2/buttons",
	$"HBoxContainer/Input List/List 3/buttons",
	$"HBoxContainer/Input List/List 4/buttons",
	$"HBoxContainer/Input List/List 5/buttons",
	$"HBoxContainer/Input List/List 6/buttons",
	$"HBoxContainer/Input List/List 7/buttons",
	$"HBoxContainer/Input List/List 8/buttons",
	$"HBoxContainer/Input List/List 9/buttons"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func updateListFrame():
	var newFrames: String = frames.text
	newFrames = newFrames.replace('[', '')
	newFrames = newFrames.replace('[', '')
	newFrames = str((newFrames as int) + 1)
	newFrames = "[" + newFrames
	newFrames = newFrames + "]"
	frames.text = newFrames
	
	
	
func updateListInput(_direction: int, _buttons: Array[int]):
	var tempFrames: String = thingsArray[0].text
	var tempDirection: String = thingsArray[9].text
	var tempButtons: String = thingsArray[18].text
	
	thingsArray[0].text = frames.text
	thingsArray[9].text = direction.text
	thingsArray[18].text = buttons.text
	
	frames.text = "[1]"
	direction.text = "[" + str(_direction) + "]"
	
	buttons.text = "["
	for i in 6:
		buttons.text = buttons.text + str(_buttons[i]) + ", "
		
	buttons.text = buttons.text + "]"
	
	
	
	
	
	for i in 9:
		if i > 0:
			var tempF: String = thingsArray[i].text
			var tempD: String = thingsArray[i + 9].text
			var tempB: String = thingsArray[i + 18].text
			
			thingsArray[i].text = tempFrames
			thingsArray[i + 9].text = tempDirection
			thingsArray[i + 18].text = tempButtons
			
			tempFrames = tempF
			tempDirection = tempD
			tempButtons = tempB
			
			
			#thingsArray[i + 1].text = thingsArray[i].text
			#thingsArray[i + 9 + 1].text = thingsArray[i + 9].text
			#thingsArray[i + 18 + 1].text = thingsArray[i + 18].text
			
			
		
		
		
	
	
