extends CharacterBody2D
@onready var speed = Vector2(0.,0.)
@onready var prev_global_position
@onready var physics_states = {"normal_physics" : "normal_physics","intangible_physics" : "intangible_physics"}
@onready var current_physics_state = "normal_physics"
# functions
#physics states
func normal_physics(): #normal
	manage_speed()
	collision()
	return physics_return()
func intangible_physics(): #intangible
	manage_speed()
	return physics_return()
#physics states functions
func run_physics_states(): # run the physics states
	return call(physics_states[current_physics_state])
func collision(): #collide
	move_and_slide()
func manage_speed(): #move the body
	prev_global_position = global_position
	global_position += speed
func physics_return(): #what the physics states functions will return
	return global_position - prev_global_position
func _process(delta):
	run_physics_states()
 
