extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var skeleton_3d: Skeleton3D = $rig_base/Skeleton3D
@onready var hand_left: Area3D = $rig_base/Skeleton3D/hand_left


func _process(delta):
	#hand_left.global_position = skeleton_3d.torso_crtl.torso_1.torso_2.shoulder.L.arm_1.L.arm_2.L.hand.L.global_position
	pass
