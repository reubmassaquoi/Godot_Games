extends Node

var is_active = true
var interact = false
var display_rate = 3
var timer = display_rate
var text_label = null 
var text = ""
var line_done = false
signal dialog_done

func _ready():
	get_tree().get_root().get_node("game/room/player").connect("interact",self,"on_interact")
	
	set_fixed_process(true)
	set_text("Hello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am humanHello, I am human")
	show()
	pass
	
func set_text(t):
	text = t
	
	
	
func _fixed_process(delta):
	if timer >1:
		timer-=1
	else:
		display_text()
		timer = display_rate

func display_text():
	if text_label == null:
		text_label = get_node("Label")
	else:
		text_label.set_text(text)
		var text_count = text_label.get_total_character_count()
		var visible_text_count = text_label.get_visible_characters()
		if visible_text_count !=text_count:
			if line_done:
				visible_text_count = text_count
			text_label.set_visible_characters(visible_text_count+1)
			
func on_interact():
		if is_active:
			if line_done:
				emit_signal("dialog_done")
			else:
				line_done = true
