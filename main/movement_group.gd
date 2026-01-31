class_name MovementGroup
extends Node2D

const UnitState = preload("res://objects/unit/unit_state.gd").UnitState

var units: Array[Node] = []
var unitsFinished: Array[Node] = []
var target_position: Vector2

func setup(units_array: Array, target: Vector2):
	target_position = target
	units = units_array.duplicate()
	var self_weakref = weakref(self)
	for unit in units:
		if is_instance_valid(unit):
			unit.set_movement_group(self_weakref)

func check_for_disband():
	for u in units:
		if u.currentState != UnitState.IDLE:
			return
	if is_instance_valid(self):
		disband()

func mark_unit_as_finished(unit):
	for u in range(0,units.size()):
		if units[u] == unit:
			unitsFinished.push_back(unit)
			units.remove_at(u)
			check_for_disband()
			return

func remove_unit(unit: Node):
	units.erase(unit)
	check_for_disband()
	
func disband():
	queue_free()
