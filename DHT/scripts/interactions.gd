extends Node

var in_interaction = false
var target = null

func _ready():
	pass

func _on_player_area_body_enter(body):
	print("interacting with",body.get_name())
	if target !=null:
		if body.is_in_group("interactable"):
			target = body
			print("The players target is",target.get_name())
func _on_player_area_body_exit(body):
	if body == target:
		target = null