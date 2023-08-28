extends "res://physics_template.gd"
#children
@onready var damage_detector = $damage_detector
@onready var sprite = $sprite
#onready vars
#state machine vars
@onready var states = {"dead_state" : "dead_state","default_state" : "default_state"}
@onready var current_state = "default_state"
#damage state machine vars
@onready var damage_states = {"damageable" = "damageable","iframe" = "iframe"}
@onready var current_damage_state = "damageable"
@onready var colliding_damagers = null
@onready var iframe_timer = 0.
#export vars
@export var damage_knockback = 0.
@export var hp = 1.
@export var impact_damage = 0.
@export var iframe_length = 0.
#drawing vars
#alpha
@export var target_alpha = 1 # the alpha value you want to reach
@export var target_alpha_speed = 0.033 #the speed it will be reached
#scale
@export var target_scale = Vector2(1.,1.)
@export var target_scale_speed = Vector2(0.0333,0.0333)
#rotation
@export var extra_rotation = 0. #is gonna be added to the direction, contributing to the final rotation
@export var rotation_speed = 1. #is gonna be addeded to extraa rotation
#drawing functions
func set_draw_rotation():
	extra_rotation += rotation_speed* delta_60
	rotation = deg_to_rad(direction + rotation_speed)
func set_alpha(target,reach_speed):
	sprite.modulate.a = move_toward(sprite.modulate.a,target_alpha,reach_speed * delta_60)
func set_draw_scale(target,reach_speed):
	scale = Vector2(move_toward(scale.x,target_scale.x,reach_speed.x),move_toward(scale.y,target_scale.y,reach_speed.y))
#drawing function manager
func run_draw_functions():
	set_alpha(target_alpha,target_alpha_speed)
	set_draw_scale(target_scale,target_scale_speed)
	set_draw_rotation()
# state machine functions
func default_state():
	return 
func dead_state():
	speed = globals.delta_lerp(speed,Vector2(-5.,10.),0.1,delta_60)
#damage state functions
func damageable():
	colliding_damagers = damage_detector.get_overlapping_bodies()
	if colliding_damagers: 
		hp -=colliding_damagers[0].impact_damage
		apply_damage_knockback()
		if iframe_length > 0.:
			current_damage_state = "iframe"
func iframe():
	iframe_timer += delta_60
	if iframe_timer >= iframe_length:
		iframe_timer = 0.
		current_damage_state = "damageable"
#damage state machine functions
func run_damage_state():
	return call(damage_states[current_damage_state])
func apply_damage_knockback():
	speed += (colliding_damagers[0].global_position - global_position).normalized() * -damage_knockback 
# state machine manager functions
func death():
	if hp <= 0:
		current_state = "dead_state"
func run_state(): # run the states
	set_delta()
	death()
	return call(states[current_state])
#func default processes
func default_process():
	run_state()
	run_physics_states()
	run_damage_state()
	run_draw_functions()
func _process(delta):
	default_process()

func _on_damage_detector_body_entered(body):
	run_damage_state()
