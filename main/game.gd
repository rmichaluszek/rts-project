extends Node2D

const Teams = preload("res://main/teams.gd").Teams

@onready var gui_node = $GUI

var time = 0.0

var metal = 20
var metal_income = 5
var oil = 0
var oil_income = 2
var crystal = 0
var crystal_income = 1

var my_team: Teams = Teams.BLUE
	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	
	metal += delta*metal_income/10
	oil += delta*oil_income/10
	crystal += delta*crystal_income/10
	
	gui_node.update_time(time)
	gui_node.update_resources(metal,oil,crystal,metal_income,oil_income,crystal_income)
