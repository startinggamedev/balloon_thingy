class_name exit_condition
extends Node
static func change_state(next_state : Node):
	var state_manager = next_state.get_parent()
	next_state.get_tree().reload_current_scene()
	state_manager.current_state = next_state
static func on_false(next_state : Node,boolean : bool):
	if boolean == false:
		print(boolean)
		print("yay")
		change_state(next_state)
