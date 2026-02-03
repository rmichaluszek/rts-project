extends Node

@export var initial_state: UnitState

var current_state : UnitState
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is UnitState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
			
	if initial_state:
		current_state = initial_state
		current_state._enter()

func set_state(state_name):
	on_child_transitioned(current_state,state_name)

func _process(delta: float) -> void:
	if current_state:
		current_state._update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update(delta)

func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	
	if new_state == state:
		return
	get_parent().get_node("StateDebug").text = "State: " + new_state_name.to_upper()
		
	if current_state:
		current_state._exit()
		
	new_state._enter()
	
	current_state = new_state
