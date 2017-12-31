extends Node


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func init_dialogue(target):
	print(target.get_name()," is in a dialog")