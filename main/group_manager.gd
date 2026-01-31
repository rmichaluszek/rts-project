extends Node2D

const Teams = preload("res://main/teams.gd").Teams

var current_selected_units: Array[Node] = []
var current_selected_unit: Node # with tab we can cycle trough units in selection and apply commands only to them

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func move_command(pos):
	if(current_selected_units!=[]):
		var group := MovementGroup.new()
		group.setup(current_selected_units, pos)
		for u in range(0,current_selected_units.size()):
			current_selected_units[u].set_destination(pos)


func set_selected_units(array: Array[Node]):
	current_selected_units = []
	current_selected_unit = null

	for u in get_parent().get_node("Units").get_children():
		u.set_selected(false)
	
	for u in array:
		if u.team == get_parent().my_team:
			u.set_selected(true)
			current_selected_units.push_back(u)
	if(current_selected_units!=[]):
		display_unit()
	
func display_unit():
	var unit = current_selected_unit
	if !unit: unit = current_selected_units[0] # there is no cycled or highlighted unit in the selection so we display the first one in group
	# display first one in the gui
	print(unit)
	get_parent().get_node("GUI").display_unit(weakref(unit))
