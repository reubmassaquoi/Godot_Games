extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var anim_player = get_node("AnimationPlayer")
func _ready():
	# Called every time the node is added to the scene.
	# Initialization hereif !anim_player.is_playing():if !anim_player.is_playing():
	pass

func flip():
	set_scale(Vector2(get_scale().x*-1,get_scale().y))

func run():
	if anim_player.is_playing() and anim_player.get_current_animation()== "rest":
		anim_player.play("run")
func rest():
	anim_player.play("rest")