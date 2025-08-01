extends CharacterBody3D


@export var hp : float = 100
@export var stance : float = 100
@export var run_speed : float = 3.0
@export var jump_speed : float = 4.0


@onready var base: RayCast3D = $CollisionShape3D/base

var state : int = 0
"""
0.. standing
1.. jumping upward
2.. falling
3.. lying on floor
4.. crouched
5.. attacking
6.. being hit
"""
var on_floor : bool = false

func _ready():
	pass

func _physics_process(delta):
	
	#on floor
	on_floor = base.is_colliding()
	
	if on_floor:
		velocity.y = 0
	else:
		velocity.y -= 9.8 * delta

	#state machine
	match state:
		0:
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
		1:
			if velocity.y <= 0:
				state = 2
		2:
			if on_floor:
				state = 0
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass
		_:
			pass
	
	move_and_slide()
	
