extends TextureRect

var unit_ref: WeakRef = null

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("GroupManager").highlight_unit(unit_ref)


func set_highlighted(highlighted):
	if highlighted:
		set_modulate(Color.GREEN)
	else:
		set_modulate(Color.WHITE)
