extends Node

@export var initial_state: Unit_State

var current_state : Unit_State
var states : Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is Unit_State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
			
	if initial_state:
		current_state = initial_state
		current_state.Enter()

func set_state(state_name):
	on_child_transitioned(current_state,state_name)

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.PhysicsUpdate(delta)


func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	
	if new_state == state:
		return
	
	get_parent().get_node("StateDebug").text = "State: " + new_state_name
		
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
