extends Area2D
@onready var motion_force_types = {"atrraction" = "attraction","direction" = "direction"}
@export var current_motion_force_type = ""
@export var motion_force_scale = 1.
@export var motion_direction = 0.
@onready var field_area = $field_area
