extends Node2D
onready var child_list = get_node("TileMap").get_children()
var debris_ref = {}


#func init_root():
#	for child in child_list:
#		if child.is_in_group("tossable"):
#			var pre = load(String("res://subscenes/"+child.get_name()+"_tossable.tscn"))
#			debris_ref[child.get_name()]=pre
#			print("preloaded ",pre)
#	get_node("TileMap/player/weapon/chamber").connect("load_tossable",self,"on_load_tossable")
#	print("Got here in root")

func _ready():
	#init_root()
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	"""
func on_load_tossable(t,chamber):
	print("Debris added ", t)
	chamber.add_debris(debris_ref[t])
	"""
#func on_resting(body,name):
#	print("resting")
#	var p = "TileMap/"+name
#	var n =get_node(p)
#	n.set_pos(body.get_pos())
#	body.queue_free()
#	n.get_node("collision").set_trigger(false)
#	n.show()
	