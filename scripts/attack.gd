


##This is a class that contains information about attacks.
##It holds the name [which will be the same as the animation name],
##the damage, the hitbox information, the hit type [low(1)/mid(2)/high(3)/overhead(4)],
##the weight of the hit [light(1)/medium(2)/heavy(3)/special(4)], etc.

##More on weight: 
#the number used as the weight will decide these things:
#	- hitstun
#	- hitstop (The amount of frames the whole game pauses on hit, will be different based on block or 
class_name Attack

var name := "none"

var total_frames := 0

var damage := 0

var hit_type := 0

var weight := 0

var hitbox_size: Array[float]

var hitbox_position: Array[float]

var frames: Array[int]

func getName() -> String:
	return name
	
func getTotalFrames() -> int:
	return total_frames
	
func getDamage() -> int:
	return damage
	
func getHitType() -> int:
	return hit_type
	
func getWeight() -> int:
	return weight
	
func getHitboxSizeAt(pos: int) -> float:
	return hitbox_size[pos]
	
func getHitboxSize() -> Array[float]:
	return hitbox_size
	
func getHitboxPositionAt(pos: int) -> float:
	return hitbox_position[pos]
	
func getFramesAt(pos: int) -> int:
	if pos >= frames.size():
		return -1
	return frames[pos]

func toString() -> String:
	var theString = "Name: " + name + " Damage: " + str(damage)
	
	theString += " Hit Type: "
	
	match damage:
		1:
			theString += "Low"
		2:
			theString += "Mid"
		3:
			theString += "High"
		4:
			theString += "Overhead"
		_:
			theString += "none"
	
	theString += " Weight: "
	
	match weight:
		1:
			theString += "Light"
		2:
			theString += "Medium"
		3:
			theString += "Heavy"
		4:
			theString += "Special"
		_:
			theString += "none"
			
	return theString
	
func _init(_name: String, _total: int, _dmg: int, _hit: int, _weight: int, _size: Array[float], _position: Array[float], _frames: Array[int]):
	print("constructedAttack")
	name = _name
	total_frames = _total
	damage = _dmg
	hit_type = _hit
	weight = _weight
	hitbox_size = _size
	hitbox_position = _position
	frames = _frames
	
