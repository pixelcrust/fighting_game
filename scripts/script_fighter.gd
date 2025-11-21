extends CharacterBody3D

@export var player : int = 0 #starting with zero

@export var hp : float = 100
@export var stance : float = 100
@export var run_speed : float = 3.0
@export var jump_speed : float = 4.0
@export var air_strafe_speed :float = 2.0
@export var crouch_speed : float = 1.5


@onready var animation_player: AnimationPlayer = $RIG.animation_player
@onready var base: RayCast3D = $base
@onready var walljump_raycast: RayCast3D = $RIG/walljump_raycast


@onready var ui_elements = preload("res://ui_elements/life_bar.tscn")
@onready var ui = null

@onready var base_rig: Node3D = $RIG

#controlls
var key_left : String
var key_right : String
var key_jump : String
var key_duck : String
var key_attack1 : String
var key_block : String
var key_parry : String


var state : int = 0
var state_before : int = 0
var is_facing_right : bool = true
var attack_state : int = 0

var being_blocked : bool = false
var being_parried : bool = false


"""
0.. standing
1.. jumping upward
2.. falling
3.. lying on floor
4.. crouched
5.. attacking
6.. being hit
7.. block
8.. parry
9.. being parried
"""
var on_floor : bool = false

func _ready():
	
	if player == 0:
		key_left = "key_left_0"
		key_right = "key_right_0"
		key_jump = "key_jump_0"
		key_duck = "key_duck_0"
		key_attack1 = "key_attack1_0"
		key_block = "key_block_0"
		key_parry = "key_parry_0"
	elif player == 1:
		key_left = "key_left_1"
		key_right = "key_right_1"
		key_jump = "key_jump_1"
		key_duck = "key_duck_1"
		key_attack1 = "key_attack1_1"
		key_block = "key_block_1"
		key_parry = "key_parry_1"
	
	#create ui elements with position.x player* 128 
	var new_ui = ui_elements.instantiate()
	new_ui.global_position.x = 32+player*256
	new_ui.player_id = self
	add_child(new_ui)
	
func _physics_process(delta):
	
	#on floor
	on_floor = base.is_colliding()
	
	if on_floor:
		velocity.y = 0
	else:
		velocity.y -= 9.8 * delta

	#state machine
	match state:
		0: # ..standing
			attack_state = 0
			#input
			if Input.is_action_pressed(key_left):
				if is_facing_right:
					turn_left(delta)
				velocity.x = - run_speed * delta * 100
			elif Input.is_action_pressed(key_right):
				if !is_facing_right:
					turn_right(delta)
				velocity.x = run_speed * delta * 100
			else:
				velocity.x = 0
			if Input.is_action_pressed(key_jump) && on_floor:
				_jump(delta)
			if Input.is_action_pressed(key_duck):
				state = 4
			if Input.is_action_pressed(key_attack1):
				state = 5
			if Input.is_action_pressed(key_block):
				state = 7
			if Input.is_action_just_pressed(key_parry):
				state = 8
		1: # ..jumping upward
			attack_state = 1
			if velocity.y <= 0:
				state = 2
			if Input.is_action_pressed(key_left):
				if is_facing_right:
					turn_left(delta)
				velocity.x = - air_strafe_speed * delta * 100
			elif Input.is_action_pressed(key_right):
				if !is_facing_right:
					turn_right(delta)
				velocity.x = air_strafe_speed * delta * 100
		2: # ..jump down/falling?
			if Input.is_action_pressed(key_jump) && walljump_raycast.is_colliding():
				_jump(delta)
			attack_state = 2
			if Input.is_action_pressed(key_left):
				if is_facing_right:
					turn_left(delta)
				velocity.x = - air_strafe_speed * delta * 100
			elif Input.is_action_pressed(key_right):
				if !is_facing_right:
					turn_right(delta)
				velocity.x = air_strafe_speed * delta * 100
			if on_floor:
				state = 0
		3: # ..lying on the floor
			attack_state = 3
		4: # ..crouched
			attack_state = 4
			if Input.is_action_just_released(key_duck):
				state = 0
			if Input.is_action_pressed(key_left):
				if is_facing_right:
					turn_left(delta)
				velocity.x = - crouch_speed * delta * 100
			elif Input.is_action_pressed(key_right):
				if !is_facing_right:
					turn_right(delta)
				velocity.x = crouch_speed * delta * 100
			else:
				velocity.x = 0
		5: # ..attacking
			#depending what state the player was before what attack is being played
			match attack_state:
				0:
					_attack_normal(delta)
				1:
					_attack_jump(delta)
				2:
					_attack_jump(delta)
				3:
					pass
				4:
					_attack_crouch(delta)
				_:
					pass
		6: # .. being hit
			_being_hit(delta)
			state = state_before
			pass
		7: # ..blocking
			_block(delta)
			if Input.is_action_just_released(key_block):
				state = 0
		8: #..parrying
			_parry(delta)
		9: #being parried
			_being_parried(delta)
			state = 0
		_:
			pass
	
	#animations
	match state:
		0:
			if velocity.x == 0:
				base_rig.animation_player.play("idle")
			else:
				base_rig.animation_player.play("run")
		1:
			base_rig.animation_player.play("jump_up")
		2: #
			base_rig.animation_player.play("jump_down")
		4:
			if velocity.x != 0:
				base_rig.animation_player.play("crouch_walk")
			else:
				base_rig.animation_player.play("crouch_walk")
				base_rig.animation_player.stop()
			
	move_and_slide()
	
func _attack_normal(delta):
	animation_player.play("attack_01")
	base_rig.current_attack_dmg = 20
	#if animation_player.animation_finished("punch"):
		#state = 0
	#if being_blocked == true:
		#disable dmg
		#pass
	await get_tree().create_timer(1.0667).timeout
	being_blocked = false
	state = 0

func _jump(delta):
	velocity.y = jump_speed * delta * 100
	state = 1
	
func _attack_jump(delta):
	animation_player.play("attack_02")
	base_rig.current_attack_dmg = 10
	#if animation_player.animation_finished("punch"):
		#state = 0
	if being_blocked == true:
		#disable dmg
		pass
	await get_tree().create_timer(1.0667).timeout
	being_blocked = false
	state = 0

func _attack_crouch(delta):
	animation_player.play("crouch_attack")
	#if animation_player.animation_finished("punch"):
		#state = 0
	if being_blocked == true:
		#disable dmg
		pass
	await get_tree().create_timer(1.0667).timeout
	being_blocked = false
	state = 0

func _attack_falling(delta):
	pass

func _attack_lying(delta):
	pass
	
func _block(delta):
	animation_player.queue("block")
	await get_tree().create_timer(1.0667).timeout
	animation_player.queue("block")
	
func _parry(delta):
	animation_player.play("parry")
	await get_tree().create_timer(1.0667).timeout
	state = 0
	
func _being_parried(delta):
	base_rig.animation_player.play("got_parried")
	being_parried = false
	await get_tree().create_timer(1.0667).timeout
	
func _being_hit(delta):
	base_rig.animation_player.play("got_hit")

func turn_left(delta):
	print(str(rad_to_deg(base_rig.rotation.y)))
	base_rig.rotation.y = deg_to_rad(180.0)
	is_facing_right = false

func turn_right(delta):
	print(str(rad_to_deg(base_rig.rotation.y)))
	base_rig.rotation.y = deg_to_rad(0.0)
	is_facing_right = true

func being_hit_to_main_script(dmg: float, stagger: float) -> void:
	print_debug("primary script reached")
	hp -= dmg
	state_before = state
	state = 6

func getting_blocked() -> void:
	being_blocked = true
	base_rig.being_blocked = true
	print_debug("blocked lol")

func getting_parried() -> void:
	being_parried = true
	state = 9
	print_debug("parried lol")
