class_name MovementGroup
extends Node2D

var units: Array[WeakRef] = []
var unitsFinished: Array[WeakRef] = []
var target_position: Vector2

func setup(units_array: Array, target: Vector2):
	target_position = target
	units = units_array.duplicate()
	var self_weakref = weakref(self)
	for unit in units:
		if is_instance_valid(unit) && unit.get_ref() != null:
			unit.get_ref().set_movement_group(self_weakref)

func check_for_disband():
	for u in units:
		if(is_instance_valid(u) && u.get_ref()!=null):
			if u.get_ref().get_node("StateMachine").current_state != UnitIdle:
				return
	if is_instance_valid(self):
		disband()

func mark_unit_as_finished(unit):
	for u in range(0,units.size()):
		if units[u].get_ref() == unit:
			unitsFinished.push_back(weakref(unit))
			units.remove_at(u)
			check_for_disband()
			return

func remove_unit(unit: Node):
	for u in units:
		if u.get_ref() == unit:
			units.erase(u)
	check_for_disband()
	
func disband():
	queue_free()
