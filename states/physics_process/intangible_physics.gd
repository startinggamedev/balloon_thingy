extends state
func process(delta_60):
	pass
func physics_process(delta_60):
	actor.default_physics_process()
	actor.intangible_physics()
