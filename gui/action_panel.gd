extends Panel


func set_actions(actions):
	
	for c in range(0,get_child_count()):
		if actions[c] != null:
			get_child(c).set_action(actions[c])
			
func remove_all_highlights():
	for c in get_children():
		c.set_highlighted(false)
		
func set_highlighted(id):
	remove_all_highlights()
	get_child(id).set_highlighted(true)
