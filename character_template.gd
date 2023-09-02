extends "res://physics_template.gd"
#resource vars
@export var alpha_res = Resource
@export var scale_res = Resource
@export var rotation_res = Resource
@export var damage_res = Resource 
@export var health_res = Resource
#children
@onready var damage_detector = $damage_detector
@onready var sprite = $sprite
#onready vars
#state machine vars
@onready var states = {"dead_state" : "dead_state","default_state" : "default_state"}
@onready var current_state = "default_state"
#damage vars
#state machine vars
@onready var damage_states = {"damageable" = "damageable","iframe" = "iframe"}
@onready var current_damage_state = "damageable"
@onready var colliding_damagers = null
@onready var colliding_damager_to_check = 0
@onready var iframe_timer = 0.
#damage vars
@onready var weight = 0.
@onready var impact_damage = 0.
@onready var iframe_length = 0.
func set_damage_vars():
	weight = damage_res.weight
	impact_damage = damage_res.impact_damage
	iframe_length = damage_res.iframe_length
#health vars
@onready var hp = 0.
@onready var defense = 0.
func set_health_vars():
	hp = health_res.hp
	defense = health_res.defense
#drawing vars functions
#alpha
@onready var target_alpha = 0.
@onready var target_alpha_speed = 0.
func set_alpha_vars():
	sprite.modulate.a = alpha_res.alpha
	target_alpha = alpha_res.target_alpha # the alpha value you want to reach
	target_alpha_speed = alpha_res.target_alpha_speed #the speed it will be reached
#scale
@onready var target_scale = Vector2(0.,0.)
@onready var target_scale_speed = Vector2(0.,0.)
func set_draw_scale_vars():
	scale = scale_res.scale
	var target_scale = scale_res.target_scale
	var target_scale_speed = scale_res.target_scale_speed
#rotation
@onready var extra_rotation = 0. #is gonna be added to the direction, contributing to the final rotation
@onready var rotation_speed = 0. #is gonna be addeded to extra rotation
func set_rotation_vars():
	extra_rotation  = rotation_res.extra_rotation
	rotation_speed = rotation_res.rotation_speed
#drawing functions
func set_draw_rotation():
	extra_rotation += rotation_speed* delta_60
	rotation = deg_to_rad(direction + extra_rotation)

func set_alpha(target,reach_speed):
	sprite.modulate.a = move_toward(sprite.modulate.a,target_alpha,reach_speed * delta_60)

func set_draw_scale(target,reach_speed):
	scale = Vector2(move_toward(scale.x,target_scale.x,reach_speed.x * delta_60),move_toward(scale.y,target_scale.y,reach_speed.y * delta_60))
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
#damage functions
func take_damage(base_damage : float,defense_effectiviness):
	hp -= base_damage - (defense * defense_effectiviness)
#damage state functions
func damageable():
	colliding_damagers = damage_detector.get_overlapping_bodies()
	if colliding_damagers: 
		take_damage(colliding_damagers[colliding_damager_to_check].impact_damage,1)
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
	if colliding_damagers[colliding_damager_to_check].current_state != "dead_state":
		speed += (colliding_damagers[colliding_damager_to_check].global_position - global_position) * (colliding_damagers[colliding_damager_to_check].weight / -weight)
# state machine manager functions
func death():
	if hp <= 0:
		current_state = "dead_state"
func run_state(): # run the states
	set_delta()
	death()
	return call(states[current_state])
#func default processes
func default_ready():
	#set drawing vars
	set_rotation_vars()
	set_draw_scale_vars()
	set_alpha_vars()
	set_damage_vars()
	set_health_vars()
	print(hp)
func default_process():
	run_state()
	run_physics_states()
	run_damage_state()
	run_draw_functions()
func _ready():
	default_ready()
func _process(delta):
	default_process()


