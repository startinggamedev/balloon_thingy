extends "res://physics_template.gd"
#children
@onready var damage_detector = $damage_detector
#onready vars
#state machine vars
@onready var states = {"dead_state" : "dead_state","default_state" : "default_state"}
@onready var current_state = "default_state"
#damage state machine vars
@onready var damage_states = {"damageable" = "damageable","iframe" = "iframe"}
@onready var current_damage_state = "damageable"
@onready var colliding_damagers = null
@onready var iframe_length = 0.
#export vars
@export var hp = 1.
@export var impact_damage = 0.
# state machine functions
func default_state():
	return 
func dead_state():
	speed = globals.delta_lerp(speed,Vector2(-5.,10.),0.1,delta_60)
#damage state functions
func damageable():
	colliding_damagers = damage_detector.get_overlapping_bodies()
	hp -=colliding_damagers[0].impact_damage
	if iframe_length > 0:
		current_damage_state = "iframe"
#damage state machine manager functions
func run_damage_state():
	return call(damage_states[current_damage_state])
# state machine manager functions
func death():
	if hp <= 0:
		current_state = "dead_state"
func run_state(): # run the states
	set_delta()
	death()
	return call(states[current_state])
func _process(delta):
	run_state()
	run_physics_states()


func _on_damage_detector_body_entered(body):
	run_damage_state()
