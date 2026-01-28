extends Node2D

const UnitState = preload("res://objects/unit/unit_state.gd").UnitState

@export var isSelected: bool = false
@export var currentState: UnitState = UnitState.IDLE


func _ready() -> void:
	set_state(UnitState.IDLE)

func _process(delta: float) -> void:
	pass
	
	
func set_state(state: UnitState):
	$StateDebug.text = "STATE: " + str(UnitState.keys()[state])
	currentState = state

# for now this is outline
func set_selected(selected: bool):
	isSelected = selected
	if(isSelected): $Selected.visible = true
	else: $Selected.visible = false
