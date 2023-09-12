extends Node2D
#onready
@onready var bullets_this_frame = 0.
@onready var shooter_timer = 0.
@onready var delta_60 = null
@onready var current_state = "shooting"
@onready var is_projectile_shot = []
@onready var projectile_instance = null
@onready var shooting_direction = 0.
#for loop var
@onready var n = 1.

#states
@onready var states = {"shooting" = "shooting","cooldown" = "cooldown"}
@onready var aiming_states = {"enemy_aim" = "enemy_aim","mouse_aim" = "mouse_aim","random_aim" = "random_aim"}
#export
@export var max_bullet_per_frame = 0.
@export var max_aiming_distance = INF
@export var current_aiming_state = "enemy_aim"
@export var aim_time = 60.
@export var cooldown_time = 60
@export var projectile = Resource
@export var ammo = 1.
@export var is_rechargeable = true
@export var projectiles_angle_dif = 0.
@export var projectile_angle_offset = 0.
@export var shooting_type = {"auto_shoot" = "auto_shoot","mouse_shoot" = "mouse_shoot"}
@export var current_shooting_type = "auto_shoot"
#functions
#shooting type
func time_condition():
	if shooter_timer >= (aim_time/ammo) * max_bullet_per_frame:
		return true
	else: return false
func auto_shoot():
	if time_condition():
		return true
	else: return false
func mouse_shoot():
	if Input.is_action_pressed(globals.shooting_key) and time_condition():
		return true
	else: return false
func reset_is_projectile_shot():
	is_projectile_shot.fill(false)
func increase_timer():
	shooter_timer += delta_60
func set_up_projectile(bullet_index):
	projectile_instance = projectile.instantiate()
	get_parent().add_sibling(projectile_instance)
	projectile_instance.global_position = global_position
	projectile_instance.direction = shooting_direction + (projectiles_angle_dif * (bullet_index)) + projectile_angle_offset - (0.5 * projectiles_angle_dif * (max_bullet_per_frame - 1))
	projectile_instance.run_draw_functions()
func shoot_projectile():
	run_aiming_states()
	for n in ammo:
		if call(current_shooting_type) and not is_projectile_shot[n]:
			if bullets_this_frame < max_bullet_per_frame :
				is_projectile_shot[n] = true
				set_up_projectile(bullets_this_frame)
				bullets_this_frame+=1
				if bullets_this_frame >= max_bullet_per_frame:
					shooter_timer = 0.
	bullets_this_frame = 0.
func set_delta():
	delta_60 = globals.get_delta_60()
#state machine manager functions
func change_state(next_state):
		current_state = next_state
		shooter_timer = 0.
func run_states():
	return call(states[current_state])
func run_aiming_states():
	return call(aiming_states[current_aiming_state])
#state functions

func shooting():
	increase_timer()
	shoot_projectile()
	if is_projectile_shot[len(is_projectile_shot) - 1]: 
		change_state("cooldown")
		reset_is_projectile_shot()
func cooldown():
	increase_timer()
	if shooter_timer >= cooldown_time:
		change_state("shooting")
#aim states functions
func enemy_aim():
	shooting_direction = globals.get_nearest_node_in_group_angle("balloon_group",global_position,max_aiming_distance)
func mouse_aim():
	shooting_direction = globals.get_cursor_angle_degrees(global_position)
func random_aim():
	shooting_direction = globals.get_random_angle()
#process functions
func _ready():
	is_projectile_shot.resize(int(ammo))
func _process(delta):
	set_delta()
	run_states()
	
