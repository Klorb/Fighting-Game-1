class_name DirectionsResource


var left := "Left"
var right := "Right"
var up := "Up"
var down := "Down"

var lp := "LP"
var mp := "MP"
var hp := "HP"

var lk := "LK"
var mk := "MK"
var hk := "HK"

func _init(player: int):
	print("created player " + str(player))
	if player > 1:
		left += "2"
		right += "2"
		up += "2"
		down += "2"
		
		lp += "2"
		mp += "2"
		hp += "2"
		
		lk += "2"
		mk += "2"
		hk += "2"
