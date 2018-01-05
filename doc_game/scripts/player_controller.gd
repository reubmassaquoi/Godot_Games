extends KinematicBody2D


var acceleration = Vector2(0,0)
var speed = 3
var velocity = Vector2(0,0)
var currentScale = Vector2(0,0)
var equipped = false
var move_right = false
var move_left = false
var move_jump = false
var use_weapon = false
var use_weapon2 = false
var aim_up_angle = false
var aim_down_angle = false
var equip_pressed = false
var direction = 1
var flip = true
onready var gun = get_node("weapon")
onready var shoot_ray = gun.get_node("shoot_ray")
onready var chamber = gun.get_node("chamber")
onready var player_sprite = get_node("bone_sprite")

# Member variables
const GRAVITY = 900.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const MAX_WALKABLE_SLOPE = 70
const WALK_FORCE = 750
const WALK_MIN_SPEED = 20
const WALK_MAX_SPEED = 350
const STOP_FORCE = 2000
const JUMP_SPEED = 450
const FALL_SPEED = 500
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel


var on_air_time = 100
var jumping = false
var stop = true
var running = false

var prev_jump_pressed = false


func _ready():
	set_fixed_process(true)
	set_process_input(true)
	currentScale = get_scale()
	pass
	
func _fixed_process(delta):
	control_player(delta)
	
func _input(event):
	equip_pressed =event.is_action_pressed("ui_equip")
	use_weapon = event.is_action_pressed("use_weapon")
	use_weapon2 = event.is_action_pressed("use_weapon2")

func set_direction():
	var wep_offset = 50
	gun.set_pos(Vector2(gun.get_pos().x*-1,gun.get_pos().y))
	#set_scale(currentScale.x*direction,currentScale.y)
	gun.get_node("Sprite").set_flip_h(flip)
	player_sprite.flip()
	shoot_ray.set_pos(Vector2(wep_offset*direction,0))
	shoot_ray.set_cast_to(Vector2(shoot_ray.get_cast_to().x*-1,0))
	pass

func aim():
	gun.set_rot(0)
	if aim_up_angle:
		gun.set_rot(45*(3.141592/180)*direction)
		shoot_ray.set_cast_to(shoot_ray.get_cast_to())
	elif aim_down_angle:
		gun.set_rot(-45*(3.141592/180)*direction)
		
func shoot():
	if chamber.get_count()>0:
		#move(Vector2(50*(-1*direction),0))
		chamber.release_debris()
		
		
func shoot2():
	if chamber.get_count()<3:
		if shoot_ray.is_colliding():
			var c = shoot_ray.get_collider()
			if c.is_in_group("tossable"):
				if  not c.get_node("collision").is_trigger():
					c.get_node("collision").set_trigger(true)
					c.hide()
					#c.set_pos(Vector2(0,0))
					chamber.add_debris(c)
		
func control_player(delta):
	var force = Vector2(0,GRAVITY)
	stop = true
	if move_left:
		running = true
		if velocity.x <= WALK_MIN_SPEED and velocity.x >-WALK_MAX_SPEED:
			force.x -=WALK_FORCE
			stop = false
			flip = true
			if direction == 1:
				direction = -1;
				set_direction()
			
			#acceleration+=Vector2(speed,0)
			#direction = acceleration
	if move_right:
		running = true
		if velocity.x >= -WALK_MIN_SPEED and velocity.x <WALK_MAX_SPEED:
			force.x +=WALK_FORCE
			stop = false 
			flip = false
			if direction == -1:
				direction = 1;
				set_direction()
	if running :
		player_sprite.run()
	else:
		player_sprite.rest()
			#shoot_ray.set_cast_to(shoot_ray.get_cast_to()*direction)
			#acceleration+=Vector2(-speed,0)
			#direction = acceleration
	if equip_pressed:
		if equipped:
			gun.hide()
			#shoot_ray.set_enabled(false)
			equipped = false
		else:
			gun.show()
			
			equipped = true
		equip_pressed = false
	#	move(Vector2(0,-50))
	aim()
	if equipped:
		if use_weapon2:
			shoot2()
		use_weapon2 = false
		if use_weapon:
			shoot()
		use_weapon = false
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		vlen-=STOP_FORCE*delta
		if(vlen<0):
			vlen = 0
		velocity.x = vlen*vsign
		
		
	#integrate forces to velocity
	velocity+= force*delta
	#integrate velocity into motion and move
	var motion = velocity*delta
	motion = move(motion)
	var old_x = get_global_pos().x;
	var old_velocity_x = velocity.x;
	var floor_velocity = Vector2(0,0)
	
	if is_colliding():
		var n = get_collision_normal()
		var slope_angle =rad2deg(acos(n.dot(Vector2(0, -1))))
		if (slope_angle < MAX_WALKABLE_SLOPE):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
			# Since this formula will always slide the character around, 
			# a special case must be considered to to stop it from moving 
			# if standing on an inclined floor. Conditions are:
			# 1) Standing on floor (on_air_time == 0)
			# 2) Did not move more than one pixel (get_travel().length() < SLIDE_STOP_MIN_TRAVEL)
			# 3) Not moving horizontally (abs(velocity.x) < SLIDE_STOP_VELOCITY)
			# 4) Collider is not moving
			
			revert_motion()
			velocity.y = 0.0
		else:
			# For every other case of motion, our motion was interrupted.
			# Try to complete the motion by "sliding" by the normal
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			motion = move(motion)
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)
	
	if (jumping and velocity.y > 0):
		# If falling, no longer jumping
		jumping = false
	
	if (on_air_time < JUMP_MAX_AIRBORNE_TIME and move_jump and not prev_jump_pressed and not jumping):
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = move_jump
	move_left = Input.is_action_pressed("ui_left")
	move_right = Input.is_action_pressed("ui_right")
	move_jump = Input.is_action_pressed("ui_up")
	aim_up_angle = Input.is_action_pressed("aim_up_angle")
	aim_down_angle = Input.is_action_pressed("aim_down_angle")
	running = false
	shoot_ray.set_enabled(true)
	#move(acceleration.normalized()*speed)
	#acceleration = Vector2(0,0)

func _on_collision_buffer_body_enter( body ):
	var v = Vector2()
	v =get_global_pos()-body.get_pos()
	
	move(v.normalized()*10)
	#move(get_pos()-get_collision_pos())
	pass # replace with function body
