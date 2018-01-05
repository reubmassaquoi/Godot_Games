extends Node2D

var debris_list = []

signal load_tossable
func _ready():
	
	pass

func load_tossable(t):
	print("Emitting load_tossable")
	emit_signal("load_tossable",t,self)

func add_debris(debris):
	debris_list.append(debris)

func get_count():
	return debris_list.size()
func release_debris():
	#var d = debris_list[0]
	var debris = debris_list[0]
	print("got here")
	var root =get_tree().get_root()
	#root.get_node("root/TileMap").add_child(debris)
	var shoot_ray = get_parent().get_node("shoot_ray")
	var pos = get_parent().get_parent().get_pos()
	pos.y-=20
	debris.set_pos(pos+shoot_ray.get_pos())
	debris.get_node("collision").set_trigger(false)
	debris.show()
	debris.set_linear_velocity(shoot_ray.get_cast_to()*3)
	#shoot_ray.add_exception(debris)
	#debris.connect("resting",root.get_node("root"),"on_resting")
	shoot_ray.set_enabled(false)
	debris_list.remove(0)