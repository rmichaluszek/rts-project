extends CharacterBody2D

const UnitState = preload("res://objects/unit/unit_state.gd").UnitState
const Teams = preload("res://main/teams.gd").Teams

@export var isSelected: bool = false
@export var currentState: UnitState = UnitState.IDLE
@export var team: Teams = Teams.BLUE


var movement_speed = 100.0
var target: Vector2 = Vector2(0,0)

@onready var navigation_agent = $NavigationAgent2D

func _ready() -> void:
	set_state(UnitState.IDLE)
	call_deferred("pathfinfing_setup")

func _physics_process(delta: float) -> void:
	
	if !navigation_agent.is_navigation_finished():
		var next_agent_position = navigation_agent.get_next_path_position()
		
		#change it to smooth speeding up later
		velocity = global_position.direction_to(next_agent_position) * movement_speed
	else:
		# idle if nothing to do
		set_state(UnitState.IDLE)
		velocity = Vector2(0,0)
	move_and_slide()

func pathfinfing_setup():
	await get_tree().physics_frame

func set_destination(pos: Vector2):
	if pos != Vector2(0,0):
		navigation_agent.target_position = pos
		set_state(UnitState.MOVE)

func set_state(state: UnitState):
	$StateDebug.text = "STATE: " + str(UnitState.keys()[state])
	currentState = state

# for now this is outline
func set_selected(selected: bool):
	isSelected = selected
	if(isSelected): $Selected.visible = true
	else: $Selected.visible = false
