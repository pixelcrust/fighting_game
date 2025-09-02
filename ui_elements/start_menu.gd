extends Node3D

@onready var open_cam = $Open_Cam2/Open_Cam/Skeleton3D/Camera/Camera
@onready var mode = $Menu_Mode/Mode
@onready var open_anim = $Open_Cam2/AnimationPlayer
@onready var door_anim = $Open_Theater2/AnimationPlayer
@onready var num_player = $Menu_Mode/Number_Players
@onready var arena = $Menu_Mode/Arenas
@onready var characters = $Menu_Mode/Characters
@onready var connect = $Menu_Mode/Online_Connect

var mode_set_local = false
var mode_set_online = false
var mode_set_ready = false
var num_set_stored = false
var arena_ready = false
var connect_ready = false

var  player_count = 0
var arena_set: String

func _ready() -> void:
	mode_set_ready = true
	open_cam.current = true
	
	mode.visible = true
	num_player.visible = false
	arena.visible = false
	connect.visible = false

func _process(_delta: float) -> void:
	if mode_set_ready == true:
		open_anim.play("Select_Mode")
	
	if mode_set_local == true:
		mode.visible = false
		open_anim.play("Select_Num")
	
	if mode_set_online == true:
		mode.visible = false
		open_anim.play("Select_Connection")
		door_anim.play("D02_Open")
	
	if num_set_stored == true:
		num_player.visible = false
		open_anim.play("Select_Arena")
		
	if arena_ready == true:
		arena.visible = false
		open_anim.play("Select_Character")
		door_anim.play("D01_Open")
		
	if connect_ready == true:
		connect.visible = false
		open_anim.play("Select_Online_Character")
#Buttons
func _on_local_btn_pressed() -> void:
	mode_set_ready = false
	mode_set_local = true

func _on_online_btn_pressed() -> void:
	mode_set_ready = false
	mode_set_online = true

func _on_one_player_pressed() -> void:
	player_count += 1
	num_set_stored = true
	
func _on_two_player_pressed() -> void:
	player_count += 2
	num_set_stored = true
	
func _on_three_player_pressed() -> void:
	player_count += 3
	num_set_stored = true
	
func _on_four_player_pressed() -> void:
	player_count += 4
	num_set_stored = true

func _on_arena_01_pressed() -> void:
	arena_set = "arena_01"
	arena_ready = true

func _on_pass_pressed() -> void:
	connect_ready = true
	

#Animation Transitions
func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "Select_Num":
		mode_set_local = false
		num_player.visible = true
	
	if anim_name == "Select_Connection":
		mode_set_online = false
		connect.visible = true
		
	if anim_name == "Select_Arena":
		num_set_stored = false
		arena.visible = true
		
	if anim_name == "Select_Character":
		arena_ready = false
		characters.visible = true
		
	if anim_name == "Select_Online_Character":
		connect_ready = false
		characters.visible = true


func _on_animation_player_door_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
