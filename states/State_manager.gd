class_name state_manager
extends Node
@export var current_state : Node
@onready var setted_state = false; 
func change_state(next_state):
	if next_state == null: return
	print("ok boom")
	if current_state.has_method("exit"): current_state.exit(get_process_delta_time() * 60.)
	setted_state = false
	current_state = next_state
func default_process():
	if current_state.has_method("enter") and !setted_state:
		setted_state = true
		current_state.enter(get_process_delta_time() * 60.)
	if current_state.has_method("exit_state"): current_state.exit_state()
	change_state(current_state.next_state)
	if current_state.has_method("process"): current_state.process(get_process_delta_time() * 60.)
func default_physics_process():
	if current_state.has_method("physics_process"): current_state.physics_process(get_physics_process_delta_time() * 60.)
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()
