extends UnitState
class_name UnitMove

@export var state_target : CharacterBody2D

var target_location : Vector2
var movement_speed : float

func _enter():
	pass
	
func _physics_update(_delta: float):
	var new_velocity = Vector2(0,0)
	if !state_target.navigation_agent.is_navigation_finished():
		var next_agent_position = state_target.navigation_agent.get_next_path_position()
		new_velocity = state_target.global_position.direction_to(next_agent_position) * state_target.movement_speed
		state_target.navigation_agent.set_velocity(new_velocity)
		state_target.move_and_slide()
	else:
		transitioned.emit(self,"Idle")

	for i in state_target.get_slide_collision_count():
		var c = state_target.get_slide_collision(i)
		if c.get_collider() is CharacterBody2D:
			if is_instance_valid(state_target.movement_group.get_ref()) && is_instance_valid(c.get_collider().movement_group):
				var units = state_target.movement_group.get_ref().unitsFinished
				for u in units:
					if u.get_ref()==c.get_collider():
						transitioned.emit(self,"Idle")
						state_target.velocity = Vector2.ZERO
						state_target.navigation_agent.target_position = state_target.position
	
func _update(_delta: float):
	pass
	
func _exit():
	if state_target.movement_group!=null && is_instance_valid(state_target.movement_group.get_ref()) :
		state_target.movement_group.get_ref().mark_unit_as_finished(state_target)
