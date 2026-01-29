extends Node2D

const Teams = preload("res://main/teams.gd").Teams

var current_selected_units: Array = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func move_command(pos):
	if(current_selected_units!=[]):
		for u in current_selected_units:
			u.set_destination(pos)

func set_selected_units(array: Array):
	
	current_selected_units = []
	for u in get_parent().get_node("Units").get_children():
		u.set_selected(false)
	
	for u in array:
		if u.team == get_parent().my_team:
			u.set_selected(true)
			current_selected_units.push_back(u)
	
