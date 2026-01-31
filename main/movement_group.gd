class_name MovementGroup
extends Node2D

var units: Array[Node] = []
var target_position: Vector2

func setup(units_array: Array, target: Vector2):
	target_position = target
	units = units_array.duplicate()
	var self_weakref = weakref(self)
	for unit in units:
		if is_instance_valid(unit):
			unit.set_movement_group(self_weakref)
	
func remove_unit(unit: Node):
	units.erase(unit)
	if(units.size()<=0): disband()
	
func disband():
	for unit in units:
		if is_instance_valid(unit):
			unit.set_movement_group(null)
	print("usuwam sie")
	queue_free()
