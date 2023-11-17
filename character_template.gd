class_name character_template
extends "res://physics_template.gd"
#resource vars
@export var alpha_res = Resource
@export var scale_res = Resource
@export var rotation_res = Resource
@export var damage_res = Resource 
@export var health_res = Resource
#export vars
@export var current_death_condition = "hp_death_condition"
#children
@onready var sprite = $sprite
#onready vars
#state machine vars
@onready var state_timer = {}
@export var states = {"dead_state" : "dead_state","default_state" : "default_state"}
@onready var current_state = "default_state"
#damage vars
#state machine vars
@onready var death_condition = {"hp_death_condition" = "hp_death_condition","death_when_attacking" = "death_when_attacking","no_death" = "no_death"}
#damage vars
@onready var did_damage = false
@onready var can_damage = true
@onready var impact_damage = 0.
@onready var iframe_length = 0.
@onready var iframe_timer = 0.
#collider damagers
@onready var colliding_damagers = null
@onready var colliding_damager_to_check = 0.
@onready var current_collider_damager = null
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
#drawing functions"alpha_res"
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
#damage functions
#death conditions
func no_death():
	return false
func hp_death_condition():
	if hp <= 0.: return true
	elif hp > 0.: return false 
func death_when_attacking():
	if did_damage: return true
	elif not did_damage: return false
#damage state machine functions
# state machine manager functions
func death():
	if call(death_condition[current_death_condition]):
		can_damage = false
		bumpable = false
		current_state = "dead_state"
func run_state(): # run the states
	return call(states[current_state])
func switch_state(next_state : String):
	current_state = next_state
func switch_state_timer(time_limit,next_state):
	if not state_timer.has(current_state): #check if current state has a corresponding timer 
		state_timer[current_state] = 0. #create one if it doesnt
	state_timer[current_state] += 1. * delta_60
	if state_timer[current_state] >= time_limit:
		state_timer[current_state] = 0.
		switch_state(next_state)
		return true
	else:
		return false
#func default processes
func default_ready():
	#set drawing vars
	set_rotation_vars()
	set_draw_scale_vars()
	set_alpha_vars()
	set_health_vars()
	add_speed_dict_entry(["damage_knockback","dead_speed"])
	set_collision_polygons()
func default_process():
	set_process_delta()
	run_state()
	run_draw_functions()
	set_physics_delta()
func _ready():
	default_ready()
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()

