extends "res://templates/bodies/enemy_template.gd"
func _ready():
	states["homing"] = "homing"
func _process(delta):
	default_process()
