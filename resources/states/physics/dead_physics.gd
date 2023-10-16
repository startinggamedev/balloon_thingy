func physics_process():
	self.set_linear_speed("dead_speed",self.spd_res.acceleration,Vector2(0,1),0.,100.,true)
	physics
