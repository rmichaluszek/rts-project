extends Node2D

const Teams = preload("res://main/teams.gd").Teams

var current_selected_units: Array[WeakRef] = []
var current_highlighted_unit: WeakRef = null # with tab we can cycle trough units in selection and apply commands only to them

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	update_selected_units(null)
	
func stop_action():
	if(current_selected_units!=[]):
		if(current_highlighted_unit!=null):
			current_highlighted_unit.get_ref().stop_action()
		else:
			for u in range(0,current_selected_units.size()):
				current_selected_units[u].get_ref().stop_action()
				
func set_target_action(unit):
	if(current_selected_units!=[]):
		if(is_instance_valid(unit) && unit.get_ref()!=null):
			if(unit.get_ref().team != get_parent().my_team):
				if(current_highlighted_unit!=null):
					current_highlighted_unit.get_ref().set_target_action(unit)
				else:
					for u in range(0,current_selected_units.size()):
						current_selected_units[u].get_ref().set_target_action(unit)

func move_action(pos):
	if(current_selected_units!=[]):
		var group := MovementGroup.new()
		if(current_highlighted_unit!=null):
			var array: Array[WeakRef] = [current_highlighted_unit]
			group.setup(array, pos)
			current_highlighted_unit.get_ref().move_action(pos)
		else:
			group.setup(current_selected_units, pos)
		
		
			for u in range(0,current_selected_units.size()):
				if(is_instance_valid(current_selected_units[u]) && current_selected_units[u].get_ref()!=null):
					current_selected_units[u].get_ref().move_action(pos)

func retreat_action(pos):
	if(current_selected_units!=[]):
		var group := MovementGroup.new()
		if(is_instance_valid(current_highlighted_unit) && current_highlighted_unit.get_ref()!=null):
			var array: Array[WeakRef] = [current_highlighted_unit]
			group.setup(array, pos)
			current_highlighted_unit.get_ref().move_action(pos)
		else:
			group.setup(current_selected_units, pos)
		
			for u in range(0,current_selected_units.size()):
				current_selected_units[u].get_ref().retreat_action(pos)

func set_selected_units(array: Array[Node]):
	
	current_selected_units = []
	current_highlighted_unit = null
	get_parent().get_node("GUI").set_highlighted_unit(null)

	for u in get_parent().get_node("Units").get_children():
		u.set_selected(false)!=null
		u.set_highlighted(false)
	
	for u in array:
		if u.team == get_parent().my_team:
			u.set_selected(true)
			current_selected_units.push_back(weakref(u))

	display_unit()
	
func update_selected_units(to_remove):
	var array: Array[WeakRef] = []
	for u in current_selected_units:

		if(is_instance_valid(u) && u.get_ref()!=null):
			if(is_instance_valid(u.get_ref())):
				if(u.get_ref()!=to_remove):
					array.push_back(u)
	current_selected_units = array
	if(is_instance_valid(current_highlighted_unit) && current_highlighted_unit.get_ref()!=null):
		pass
	else:
		current_highlighted_unit = null
	
	display_unit()
	highlight_unit(current_highlighted_unit)
	
func get_avaible_actions():
	var unit = current_highlighted_unit
	if !unit: 
		if(current_selected_units.size()>=1):
			unit = current_selected_units[0]
	if(unit):
		return unit.get_ref().my_actions
	return [null,null,null,null,null,null]


func highlight_unit(unit_ref):
	for u in current_selected_units:
		if(is_instance_valid(u) && u.get_ref()!=null):
			u.get_ref().set_highlighted(false)
			if(is_instance_valid(unit_ref) && unit_ref.get_ref()!=null):
				if u.get_ref() == unit_ref.get_ref():
					current_highlighted_unit = u
					current_highlighted_unit.get_ref().set_highlighted(true)
					get_parent().get_node("GUI").set_highlighted_unit(unit_ref)
					display_unit()

func display_unit():
	var unit = current_highlighted_unit
	if !unit: 
		if(current_selected_units.size()>=1):
			unit = current_selected_units[0] # there is no cycled or highlighted unit in the selection so we display the first one in group
	# display first one in the gui
	if(is_instance_valid(unit) && unit.get_ref()!=null):
		get_parent().get_node("GUI/Screen/ActionPanel").set_actions(unit.get_ref().my_actions)
	get_parent().get_node("GUI").display_unit(unit)
	get_parent().get_node("GUI").display_units(current_selected_units)
