class_name GuyAttacks

var lp = Attack.new("lp", 12, 5, 3, 1, [0, 0, 21, 9, 0, 0], [0, 0, 16.5, -7.5, 0, 0], [1, 4, 9]) #light high
var mp = Attack.new("mp", 10, 7, 2, 2, [0, 0, 21, 9, 0, 0], [0, 0, 16.5, -7.5, 0, 0], [0, 4, 6]) #medium mid
var hp = Attack.new("hp", 10, 10, 3, 3, [0, 0, 21, 9, 0, 0], [0, 0, 16.5, -7.5, 0, 0], [0, 4, 6]) #heavy high

## Inputs
var l_hado = Attack.new("l_hado", 32, 6, 2, 1, [0, 0, 24.5, 18, 0, 0], [0, 0, 16.5, -7.5, 0, 0], [1, 8, 24]) #light hadoken

func _init():
	pass
