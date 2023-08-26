extends Node
var screen_dimensions = Vector2(427.,240.)
var priority = [-1,0,1,2]
var mouse_pos = Vector2(0.,0.)
func delta_lerp(a,b,c,delta_60):
	return lerp(a,b,1. - pow(c,delta_60/60.))
