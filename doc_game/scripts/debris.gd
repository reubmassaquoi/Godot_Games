extends RigidBody2D

export var ref = ""

signal resting

func _ready():
	set_fixed_process(true)
	
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _fixed_process(delta):
	if get_linear_velocity().length()<=.5:
		set_sleeping(true)
	if is_sleeping():
		emit_signal("resting",self,ref)
