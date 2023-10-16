extends "res://character_template.gd"
# shooting parameter
@export var ammo : int #how many times to shoot
@export var ammo_size : int #how many projectiles per shot
@export var projectile : Resource #the thing that will be shot
@export var shot_spacing : float #how much time between shots
@export var reload_time : float #how long to reload after ammo runs out
#shooting variable
@onready var  ammo_left = ammo #how many shots left
#states 
func reload_state():
	if switch_state_timer(reload_time,"shoot_spacing_state"):
		ammo_left = ammo
func shoot_spacing_state():
	state_timer += 1. * delta_60
	if state_timer >= shot_spacing:
		state_timer = 0.
		current_state = "shoot"
func shoot_state():
	for n in ammo_size:
		var new_proj = projectile.instantiate
		new_proj.direction = randf_range(0.,360.)
		add_sibling(new_proj)
	ammo -= 1
	if ammo > 0:
		switch_state("shoot_spacing_state")
	else:
		switch_state("reload_state")
#mis function
func run_states():
	call(states[current_state])
func set_delta_60():
	delta_60 = globals.get_delta_60()
func _process(delta):
	default_process()
