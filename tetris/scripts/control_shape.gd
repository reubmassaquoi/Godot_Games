extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var moveable = false
var r = false
var l = false
var r_l = false
var r_r = false
var pivot = null
func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _fixed_process(delta):
	check_board_collision()
	if moveable:
		pivot=get_child(1).get_pos()
		var pos = get_pos()
		if Input.is_action_pressed("ui_left"):
			if l:
				move(Vector2(-25,0))
		elif Input.is_action_pressed("ui_right"):
			if r:
				move(Vector2(25,0))
		elif Input.is_action_pressed("ui_down"):
				move(Vector2(0,25))
		elif Input.is_key_pressed(KEY_D):
			if r_r:
				for child in get_children():
					var v = child.get_pos()-pivot
					var m = [
					0,1,
					-1,0]
					var t = Vector2((v.x*m[0])+(v.y*m[1]),(v.x*m[2])+(v.y*m[3]))
					child.set_pos(pivot+t)
		elif Input.is_key_pressed(KEY_A):
			if r_l:
				for child in get_children():
					var v = child.get_pos()-pivot
					var m = [
					0,-1,
					1,0]
					var t = Vector2((v.x*m[0])+(v.y*m[1]),(v.x*m[2])+(v.y*m[3]))
					child.set_pos(pivot+t)
	moveable = false
func _input(event):
	if event.type == InputEvent.KEY && event.is_pressed():
		moveable = true
		r_r = true
		r_l = true
		l = true
		r = true


func check_board_collision():
	
	var s = get_parent().get_parent()
	var l_most = null
	var r_most = null
	l_most = get_child(0)
	r_most = get_child(0)
	for c in get_children():
		if l_most.get_pos().x>c.get_pos().x:
				l_most = c
		if r_most.get_pos().x<c.get_pos().x:
				r_most = c
				
		#check leftward collision
	print(l_most.get_pos().x)
	print(r_most.get_pos().x)
	var pos = get_pos()+l_most.get_pos()
	pos =s.get_pos()+pos
	print(pos)
	if pos.x<=s.get_pos().x-120:
		l = false
		r_l = false
		r_r = false
	#check rightward collision
	var pos = get_pos()+r_most.get_pos()
	pos = s.get_pos()+pos
	if pos.x>=s.get_pos().x+125:
		r = false
		r_r = false
		r_l = false
	
	#check bottom collision