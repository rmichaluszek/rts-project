extends Node2D

const Teams = preload("res://main/teams.gd").Teams

var time = 0.0

var metal = 20
var oil = 0
var crystal = 0

var my_team: Teams = Teams.BLUE
	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	$GUI.update_time(time)
