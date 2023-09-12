extends "res://templates/bodies/enemy_template.gd"
#onready vars
@onready var to_destroy = false
#funcs
#default process
func default_bullet_ready():
	current_damage_state = "undamageable"
	current_physics_state = "intangible_physics"
func _ready():
	default_ready()
	default_bullet_ready()
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()
