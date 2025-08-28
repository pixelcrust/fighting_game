extends Node2D

var player_id = null

@onready var label_hp: Label = $label_hp
@onready var label_state: Label = $label_state

func process(delta):
	label_hp = player_id.hp
	label_state = player_id.state
