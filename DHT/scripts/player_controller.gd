extends KinematicBody2D
#Player script for regular controls

signal interact

var moveable = false
var interactable = false
var interact_field = null

var direction = Vector2(0,0)
var acceleration = Vector2(0,0)
var speed = 3
var velocity = Vector2(0,0)
var player_area = null

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	player_area = get_node("player_area")
	interact_field = player_area.get_child(0)
	pass
	
func _fixed_process(delta):
	control_player()
	interact_field.set_pos(player_area.get_pos()+(direction.normalized()*50))
	#print(interact_field.get_pos())
	
func _input(event):
	if event.type == InputEvent.KEY && event.is_pressed():
		interactable = true
	
func control_player():
	if Input.is_action_pressed("ui_up"):
		acceleration+=Vector2(0,-speed)
		direction = acceleration
	if Input.is_action_pressed("ui_right"):
		acceleration+=Vector2(speed,0)
		direction = acceleration
	if Input.is_action_pressed("ui_left"):
		acceleration+=Vector2(-speed,0)
		direction = acceleration
	if Input.is_action_pressed("ui_down"):
		acceleration+=Vector2(0,speed)
		direction = acceleration
	if Input.is_action_pressed("ui_select"):
		if interactable:
			emit_signal("interact")
			interactable = false
			
	move(acceleration.normalized()*speed)
	acceleration = Vector2(0,0)
	
	
	
func _on_player_area_body_enter(body):
	#if body.is_in_group("interactable"):
		#print("player can interact with ",body.get_name())
	