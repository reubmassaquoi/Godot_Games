extends Node

var in_interaction = false
var target = null
var next_target = null
var dialog_scene = preload("res://subscenes/dialog_contoller.tscn")
var dialog = null

func _ready():
	set_fixed_process(true)
	get_tree().get_root().get_node("game/room/player").connect("interact",self,"on_interact")
	pass
	
func on_interact():
	if !in_interaction:
		if target:
			in_interaction = true
			dialog = dialog_scene.instance()
			dialog.connect("dialog_done",self,"on_dialog_done")
			get_parent().get_node("CanvasLayer").add_child(dialog)
			get_parent().get_node("dialog_manager").init_dialogue(target)
			
func on_dialog_done():
	in_interaction = false
	dialog.queue_free()
	
func _on_player_area_body_enter(body):
	if body.is_in_group("interactable"):
		if body.get_name()!="player":
			if target ==null:
					target = body
					print("The players target is",target.get_name())
			else:
				next_target = body
func _on_player_area_body_exit(body):
	if body == target:
		print("no longer interacting with ", target.get_name())
		target = next_target
	if body== next_target:
		next_target = null
		
