extends Control

var player_id = null

@onready var label_hp: Label = $PanelContainer/Panel/label_hp
@onready var label_state: Label = $PanelContainer/Panel/label_state

func _process(delta):
	#label_hp.text = str(player_id.hp)+"%"
	#label_state.text = str(player_id.state)
	pass
