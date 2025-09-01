extends Node3D

@onready var open_cam = $Open_Cam2/Open_Cam/Skeleton3D/Camera/Camera
@onready var mode = $Menu_Mode/Mode
@onready var open_anim = $Open_Cam2/AnimationPlayer

var mode_set_local = false
var mode_set_online = false

func _ready() -> void:
	mode.visible = true
	open_cam.current = true


func _process(_delta: float) -> void:
	if mode_set_local == true:
		mode.visible = false
		open_anim.play("Select_Num")
	elif mode_set_local == false:
			open_anim.play("Select_Mode")
		
	if mode_set_online == true:
		mode.visible = false
		open_anim.play("Select_Connection")
	elif mode_set_online == false:
			open_anim.play("Select_Mode")



func _on_local_btn_pressed() -> void:
	mode_set_local = true
