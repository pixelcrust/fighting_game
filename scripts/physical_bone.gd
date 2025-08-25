extends PhysicalBone3D

@export var hit_damage_multiplier : float = 1.0
@export var damage_output : float = 10
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

signal bone_hit(dmg,stagger)

func _process(delta):

	pass

func get_hit(dmg : float,stagger : float):
	print_debug("emit signal pls")
	emit_signal("bone_hit()",dmg,stagger)
