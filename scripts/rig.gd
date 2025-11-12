extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#@onready var skeleton_3d: Skeleton3D = $rig_base/Skeleton3D

signal being_hit_to_main_script(dmg : float,stagger : float)
signal getting_parried
signal getting_blocked

@onready var current_attack_dmg : float = 0
@onready var current_attack_stagger : float = 0
@onready var current_attack_being_blocked : bool = false

@onready var being_blocked : bool = false

func _process(delta):
	pass

func _on_physical_bone_being_hit(dmg : float, stagger : float) -> void:
	print_debug("bone entered collision shape!!!!!!!!!!!!!")
	print("hallo")
	emit_signal("being_hit_to_main_script",dmg, stagger)
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void: #hit detection
	
	if is_ancestor_of(body) == false:
		
		#if hurtbox/bone
		body.get_hit(current_attack_dmg,current_attack_stagger,current_attack_being_blocked)
		print_debug("body in hitbox")
		


func area_entered(area: Area3D) -> void:
		if area.monitoring:
			if is_ancestor_of(area) == false:
				#if blockbox
				if area.is_in_group("block"):
					emit_signal("getting_blocked")
				#if parrybox
				if area.is_in_group("parry"):
					emit_signal("getting_parried")
			
