extends Node2D

const Teams = preload("res://main/teams.gd").Teams

var current_selected_units: Array[Node] = []

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
	for u in get_parent().get_node("Units").get_children():
		u.set_selected(false)
	
	for u in array:
		if u.team == get_parent().my_team:
			u.set_selected(true)
			current_selected_units.push_back(u)
	
