extends Node2D


var in_interaction = false

func _ready():

	pass

func _on_npc_area_body_enter(body):
	if body.get_name() == "player":
		print("Player has entered interaction field of npc")
	