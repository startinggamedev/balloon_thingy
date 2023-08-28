extends Node2D
#onready
@onready var shooter_timer = 0.
@onready var delta_60 = null
@onready var current_state = "shooting"
@onready var is_projectile_shot = []
@onready var projectile_instance = null
#for loop var
@onready var n = 1.

#states
@onready var states = {"shooting" = "shooting","cooldown" = "cooldown"}
@onready var aiming_states = {"enemy_aim" = "enemy_aim","mouse_aim" = "mouse_aim","random_aim" = "random_aim"}
#export
@export var current_aiming_state = "enemy_aim"
@export var aim_time = 60.
@export var cooldown_time = 60
@export var projectile = Resource
@export var ammo = 1.
@export var is_rechargeable = true
@export var projectiles_angle_dif = 0.
#functions
func reset_is_projectile_shot():
	is_projectile_shot.fill(false)
func increase_timer():
	shooter_timer += delta_60
func shoot_projectile():
	while n <= ammo:
		if ((shooter_timer/aim_time) * ammo) >= n:
			if not is_projectile_shot[n - 1]:
				is_projectile_shot[n-1] = true
				projectile_instance = projectile.instantiate()
				projectile_instance.global_position = Vector2(randf_range(0.,100.),randf_range(0.,100.))
				add_sibling(projectile_instance)
		n+=1
	n = 1.
func set_delta():
	delta_60 = globals.get_delta_60()
#state machine manager functions
func change_state(next_state):
		current_state = next_state
		shooter_timer = 0.
func run_states():
	return call(states[current_state])
#state functions
func shooting():
	increase_timer()
	shoot_projectile()
	if shooter_timer >= aim_time: 
		change_state("cooldown")
		reset_is_projectile_shot()
func cooldown():
	increase_timer()
	if shooter_timer >= cooldown_time:
		change_state("shooting")
#process functions
func _ready():
	is_projectile_shot.resize(int(ammo))
func _process(delta):
	set_delta()
	run_states()
	
