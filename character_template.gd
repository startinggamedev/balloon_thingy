extends "res://physics_template.gd"
@onready var states = {"dead_state" : "dead_state","default_state" : "default_state"}
@onready var current_state = "default_state"
@export var hp = 1.
@export var impact_damage = 0.
# state machine functions
func default_state():
	return
func dead_state():
	speed = lerp(speed,Vector2(-5.,10.),0.1)
# state machine manager functions
func death():
	if hp <= 0:
		current_state = "dead_state"
func run_state(): # run the states
	death()
	return call(states[current_state])
func _process(delta):
	run_state()
	run_physics_states()





















