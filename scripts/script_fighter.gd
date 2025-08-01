extends CharacterBody3D


@export var hp : float = 100
@export var stance : float = 100
@export var run_speed : float = 3.0
@export var jump_speed : float = 4.0


@onready var base: RayCast3D = $CollisionShape3D/base
@onready var label_state: Label = $label_state


var state : int = 0
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
	pass

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
			#input
			if Input.is_action_pressed("key_left"):
				velocity.x = - run_speed * delta * 100
			elif Input.is_action_pressed("key_right"):
				velocity.x = run_speed * delta * 100
			else:
				velocity.x = 0
			if Input.is_action_pressed("key_jump") && on_floor:
				velocity.y = jump_speed * delta * 100
				state = 1
			if Input.is_action_pressed("key_duck"):
				state = 4
		1: # ..jumping upward
			if velocity.y <= 0:
				state = 2
		2: # ..falling
			if on_floor:
				state = 0
		3: # ..lying on the floor
			pass
		4: # ..crouched
			if Input.is_action_just_released("key_duck"):
				state = 0
		5: # ..attacking
			#depending what state the player was before what attack is being played
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
	
	move_and_slide()
	
func _attack_normal(delta):
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
