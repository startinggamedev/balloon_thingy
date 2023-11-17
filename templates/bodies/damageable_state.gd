class_name damageable_state
extends state
@onready var iframe = $"../iframe"
@onready var health_manager = $".." as health_manager
@onready var _damage_dealer = $"../../Damage_dealer" 
var damagers = []
var timesrun = []
func process(delta_60):
	health_manager.current_state = iframe
	timesrun = health_manager.current_state
	damagers = _damage_dealer.get_overlapping_areas()
	for i in len(damagers):
		health_manager.health_info.hp -= damagers[i].damage_info.damage
func exit_state():
	next_state = iframe

