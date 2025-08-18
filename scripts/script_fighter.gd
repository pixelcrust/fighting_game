extends CharacterBody3D

@export var player : int = 0 #starting with zero

@export var hp : float = 100
@export var stance : float = 100
@export var run_speed : float = 3.0
@export var jump_speed : float = 4.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var base: RayCast3D = $base
@onready var label_state: Label = $label_state
@onready var base_rig: Node3D = $Base_Rig_003

#controlls
var key_left : String
var key_right : String
var key_jump : String
var key_duck : String
var key_attack1 : String
var key_block : String


var state : int = 0
var attack_state : int = 0

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
"""
var on_floor : bool = false

func _ready():
	if player == 0:
		key_left = "key_left_0"
		key_right = "key_right_0"
		key_jump = "key_jump_0"
		key_duck = "key_duck_0"
		key_attack1 = "key_attack_0"
		key_block = "key_block_0"
	elif player == 1:
		key_left = "key_left_1"
		key_right = "key_right_1"
		key_jump = "key_jump_1"
		key_duck = "key_duck_1"
		key_attack1 = "key_attack_1"
		key_block = "key_block_1"

func _physics_process(delta):
	
	label_state.text = str(state)
	
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
				turn_left(delta)
				velocity.x = - run_speed * delta * 100
			elif Input.is_action_pressed(key_right):
				turn_right(delta)
				velocity.x = run_speed * delta * 100
			else:
				velocity.x = 0
			if Input.is_action_pressed(key_jump) && on_floor:
				velocity.y = jump_speed * delta * 100
				state = 1
			if Input.is_action_pressed(key_duck):
				state = 4
		1: # ..jumping upward
			attack_state = 1
			if velocity.y <= 0:
				state = 2
		2: # ..falling
			attack_state = 2
			if on_floor:
				state = 0
		3: # ..lying on the floor
			attack_state = 3
		4: # ..crouched
			attack_state = 4
			if Input.is_action_just_released(key_duck):
				state = 0
		5: # ..attacking
			#depending what state the player was before what attack is being played
			match attack_state:
				0:
					_attack_normal(delta)
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
				_:
					pass
		6: # .. being hit
			#determine how badly the fighter was hit, with stance
			pass
		7: # ..blocking
			pass
		8: #..parrying
			pass
		_:
			pass
	
	#animations
	if state == 0 and velocity.x != 0:
		base_rig.animation_player.play("run")
	elif state == 0 and velocity.x == 0:
		base_rig.animation_player.play("idle")
	elif state == 1:
		base_rig.animation_player.play("jump")
		
	move_and_slide()
	
func _attack_normal(delta):
	#AnimationPlayer.play("attack_normal")
	pass

func _attack_jump(delta):
	pass

func _attack_crouch(delta):
	pass

func _attack_falling(delta):
	pass

func _attack_lying(delta):
	pass
	
func _block(delta):
	pass

func _being_hit(delta):
	pass

func turn_left(delta):
	if rotation.y == 90:
		rotation.y = 180

func turn_right(delta):
	if rotation.y == 180:
		rotation.y = 90
