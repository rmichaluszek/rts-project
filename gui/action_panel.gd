extends Panel


func set_actions(actions):
	
	for c in range(0,get_child_count()):
		if actions[c] != null:
			get_child(c).set_action(actions[c])
