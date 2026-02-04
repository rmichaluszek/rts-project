extends Panel

const Actions = preload("res://main/actions.gd").Actions

var isHighlighted = false
var current_action: Dictionary = {}

func _ready() -> void:
	set_action(null)

func set_action(action_name,toggled=false):
	if(!action_name):
		return
	current_action = Actions[action_name]
	if(current_action == {}):
		return
	
	elif(action_name == "SET_TARGET"):
		$ActionIcon.texture = ResourceLoader.load("res://assets/textures/ability_1.png")
	
	elif(action_name == "RETREAT"):
		$ActionIcon.texture = ResourceLoader.load("res://assets/textures/ability_3.png")
	elif(action_name == "STOP"):
		$ActionIcon.texture = ResourceLoader.load("res://assets/textures/ability_4.png")
	elif(action_name == "ATTACK_ON_SIGHT"):
		if(toggled):
			$ActionIcon.texture = ResourceLoader.load("res://assets/textures/ability_2_on.png")
		else:
			$ActionIcon.texture = ResourceLoader.load("res://assets/textures/ability_2_off.png")

func _on_gui_input(event: InputEvent) -> void:
	if(current_action!={}):
		if event is InputEventMouseButton:
			if event.button_index == 1 and event.pressed:
				# set mouse command to the action command if its not toggable or requires a target
				
				if(!current_action["requiresTarget"]):
					get_parent().get_parent().get_parent().get_parent().get_node("Camera").set_mouse_action(null)
					for c in get_parent().get_children():
							c.set_highlighted(false)
					get_parent().get_parent().get_parent().get_parent().get_node("Camera").process_action(current_action,null)
				else:
					if(!isHighlighted):
						for c in get_parent().get_children():
							c.set_highlighted(false)
						set_highlighted(true)
						get_parent().get_parent().get_parent().get_parent().get_node("Camera").set_mouse_action(current_action)
					else:
						set_highlighted(false)
						get_parent().get_parent().get_parent().get_parent().get_node("Camera").set_mouse_action(null)


func set_highlighted(highlighted):
	if(current_action!={}):
		isHighlighted = highlighted
		if isHighlighted:
			set_self_modulate(Color(3, 3, 3, 1.0))
		else:
			set_self_modulate(Color.WHITE)

func _on_mouse_entered() -> void:
	if(current_action!={}):
		if !isHighlighted:
			set_self_modulate(Color(2, 2, 2, 1.0))


func _on_mouse_exited() -> void:
	if(current_action!={}):
		if !isHighlighted:
			set_self_modulate(Color.WHITE)
