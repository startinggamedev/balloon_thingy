class_name state_manager
extends Node
@export var current_state : Node
func default_process():
	if current_state.has_method("process"): current_state.process(get_process_delta_time() * 60.)
func default_physics_process():
	if current_state.has_method("physics_process"): current_state.physics_process(get_physics_process_delta_time() * 60.)
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()
