extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var skeleton_3d: Skeleton3D = $rig_base/Skeleton3D
@onready var hand_left: Area3D = $rig_base/Skeleton3D/hand_left

signal being_hit_to_main_script(dmg : float,stagger : float)

func _process(delta):
	pass

func _on_physical_bone_being_hit(dmg : float, stagger : float) -> void:
	print_debug("bone entered collision shape!!!!!!!!!!!!!")
	print("hallo")
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if is_ancestor_of(body) != true:
		body.get_hit(10,10)
		print_debug("body in hitbox")
