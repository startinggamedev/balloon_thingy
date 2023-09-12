extends Node2D
@onready var delta_60 = globals.get_delta_60()
@onready var my_enemy
@onready var enemy = preload("res://templates/bodies/enemy_template.tscn")
@onready var timer = 0.
func _process(delta):
	delta_60 = globals.get_delta_60()
	timer += delta_60
	if timer >= 40:
		my_enemy = enemy.instantiate()
		my_enemy.global_position = Vector2(300,100)
		add_child(my_enemy)
		timer = 0
	if my_enemy:
		my_enemy.direction_velocity = randf_range(0.1,1.9)
		my_enemy.direction = 180 + randf_range(-30,30)
