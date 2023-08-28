extends "res://character_template.gd"
func _process(delta):
	speed = Vector2(0.1,0.1)
	run_state()
	run_physics_states()
