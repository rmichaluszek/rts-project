extends Node2D

const Teams = preload("res://main/teams.gd").Teams

var current_selected_units: Array = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func move_command(pos):
	if(current_selected_units!=[]):
		var formation_positions = []
		var units_distance_to_destination = []
		for u in range(0,current_selected_units.size()):
			
			# reaaaaaly basic and primitive group formation, takes the closest unit to click location and sets its destination the farthers in formation, and the same for every other unit relative to click
			if(u==0):
				formation_positions.push_back(Vector2(0,0))
			else:
				formation_positions.push_back(Vector2(160*floor((u-1)/6+1),0).rotated(deg_to_rad((u-1)*60)))
			units_distance_to_destination.push_back(await current_selected_units[u].get_length_to_destination(pos))
		
			current_selected_units[u].set_destination(pos+formation_positions[u])
		
		

func set_selected_units(array: Array):
	
	current_selected_units = []
	for u in get_parent().get_node("Units").get_children():
		u.set_selected(false)
	
	for u in array:
		if u.team == get_parent().my_team:
			u.set_selected(true)
			current_selected_units.push_back(u)
	
