extends Position2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var block_scene = preload("../scenes/block.tscn")
const OFFSET =25
var control_script = preload("../scripts/control_shape.gd")
var shape_list =[
[0,1,0,
0,1,1,
0,1,0,
0,0,0],
[0,1,0,
0,1,0,
0,1,0,
0,1,0],
[0,0,1,
0,1,1,
0,1,0,
0,0,0]
]

func _ready():
	#set_fixed_process(true)
	
	randomize()
	on_generate()
	#shape.add_ch
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _fixed_process(delta):
#	var a = 10
	
func on_generate():
	var shape = KinematicBody2D.new()
	var i = 0
	var pos = Vector2(0,0)
	var l = floor(rand_range(0,3))
	var s = shape_list[l]
	print(l)
	for n in s:
		if n ==1:
			var b = block_scene.instance()
			b.set_global_pos(pos)
			shape.add_child(b)
		pos.x+=OFFSET
		i+=1
		if i>2:
			pos.x = 0
			pos.y+= OFFSET
			i = 0
	#shape.set_pos(get_pos())
	shape.set_script(control_script)
	shape.set_name("shape")
	var p = get_parent()
	add_child(shape)
		
		
	