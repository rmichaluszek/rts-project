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
	
	var new_velocity = Vector2(0,0)
	if !navigation_agent.is_navigation_finished():
		var next_agent_position = navigation_agent.get_next_path_position()
		
		#change it to smooth speeding up later
		new_velocity = global_position.direction_to(next_agent_position) * movement_speed
		
		navigation_agent.set_velocity(new_velocity)
		
		move_and_slide()
	else:
		# idle if nothing to do
		set_state(UnitState.IDLE)
		
		
	


func pathfinfing_setup():
	await get_tree().physics_frame

func get_length_to_destination(pos: Vector2):
	if pos != Vector2(0,0):
		navigation_agent.target_position = pos
		await navigation_agent.path_changed
		var length = get_path_length()
		navigation_agent.target_position = position
		return(length)
			
func set_destination(pos: Vector2):
	if pos != Vector2(0,0):
		navigation_agent.target_position = pos
		$TargetPositionMark.position = pos
		await navigation_agent.path_changed
		set_state(UnitState.MOVE)
		
		print("i am ",get_name(), " and my path length is: ", str(get_path_length()))


func set_state(state: UnitState):
	$StateDebug.text = "STATE: " + str(UnitState.keys()[state])
	currentState = state
	
func get_path_length():
	var path = navigation_agent.get_current_navigation_path()
	if path.is_empty():
		return 0.0

	var length := 0.0
	for i in range(path.size() - 1):
		length += path[i].distance_to(path[i + 1])

	return length

# for now this is outline
func set_selected(selected: bool):
	isSelected = selected
	if(isSelected): 
		$Selected.visible = true
		$TargetPositionMark.visible = true
	else: 
		$Selected.visible = false
		$TargetPositionMark.visible = false

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
