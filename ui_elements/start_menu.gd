extends Node3D

@onready var mode = $Menu_Mode/Mode
@onready var num = $Menu_Mode/Number_Players
@onready var arena = $Menu_Mode/Arenas
@onready var roster = $Menu_Mode/Characters
@onready var online = $Menu_Mode/Online_Connect
@onready var videoplayer = $Menu_Clips

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
	$Menu_Mode/Mode/HBoxContainer/Local_btn.grab_focus()
	num.visible = false
	arena.visible = false
	roster.visible = false
	online.visible = false
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Mode.ogv")
	videoplayer.play()
	
func _process(_delta: float) -> void:
	if mode_set_ready == true:
		mode.visible = true
		
	
	if mode_set_local == true:
		mode.visible = false
		
	
	if mode_set_online == true:
		mode.visible = false
		
	
	if num_set_stored == true:
		num.visible = false
		
		
	if arena_ready == true:
		arena.visible = false
		
		
	if connect_ready == true:
		online.visible = false
		
	
#Buttons
func _on_local_btn_pressed() -> void:
	mode_set_ready = false
	mode_set_local = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Num.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(2.7).timeout
	num.visible = true
	
func _on_online_btn_pressed() -> void:
	mode_set_ready = false
	mode_set_online = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Select Character2.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(2.7).timeout
	online.visible = true

func _on_one_player_pressed() -> void:
	player_count = 1
	num_set_stored = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Arena.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(1).timeout
	arena.visible = true
	
func _on_two_player_pressed() -> void:
	player_count = 2
	num_set_stored = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Arena.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(1).timeout
	arena.visible = true
	
func _on_three_player_pressed() -> void:
	player_count = 3
	num_set_stored = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Arena.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(1).timeout
	arena.visible = true
	
func _on_four_player_pressed() -> void:
	player_count = 4
	num_set_stored = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Arena.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(1).timeout
	arena.visible = true

func _on_arena_01_pressed() -> void:
	arena_set = "arena_01"
	arena_ready = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Select Character.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(1.5).timeout
	roster.visible = true

func _on_pass_pressed() -> void:
	connect_ready = true
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Fight.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	

func _on_usher_pressed() -> void:
	roster.visible = false
	videoplayer.stream = load("res://ui_elements/Clips/Menu_Fight.ogv")
	videoplayer.play()
	videoplayer.loop = false
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
