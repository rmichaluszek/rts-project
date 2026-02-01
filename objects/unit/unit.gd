extends CharacterBody2D

const UnitState = preload("res://objects/unit/unit_state.gd").UnitState
const Teams = preload("res://main/teams.gd").Teams

@export var isSelected: bool = false
@export var isHighlighted: bool = false
@export var currentState: UnitState = UnitState.IDLE
@export var team: Teams = Teams.BLUE

var movement_group = null

var unit_name = "Gunner Bot"
var max_health = 100
var health = 100
var range = 200
var damage = 5
var movement_speed = 300.0
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
		navigation_agent.avoidance_priority = 0.4
		
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is CharacterBody2D:
			if is_instance_valid(movement_group.get_ref()) && is_instance_valid(c.get_collider().movement_group):
				var units = movement_group.get_ref().unitsFinished
				for u in units:
					if u.get_ref()==c.get_collider():
						set_state(UnitState.IDLE)
						velocity = Vector2.ZERO
						navigation_agent.target_position = position
						

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
		set_state(UnitState.MOVE)
		navigation_agent.avoidance_priority = 1
		
func set_movement_group(group):
	# Leave old group first
	if movement_group:
		if movement_group!=null && is_instance_valid(movement_group.get_ref()):
			movement_group.get_ref().remove_unit(self)
	movement_group = group
	
func set_state(state: UnitState):
	$StateDebug.text = "STATE: " + str(UnitState.keys()[state])
	currentState = state
	
	if(state == UnitState.IDLE):
		if movement_group!=null && is_instance_valid(movement_group.get_ref()) :
			movement_group.get_ref().mark_unit_as_finished(self)
	
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
		$Body/LowerBody/OutlineSelected.visible = true
		$Body/UpperBody/OutlineSelected.visible = true
		$TargetPositionMark.visible = true
	else: 
		$Body/LowerBody/OutlineSelected.visible = false
		$Body/UpperBody/OutlineSelected.visible = false
		$TargetPositionMark.visible = false

func set_highlighted(highlighted: bool):
	isHighlighted = highlighted
	if(isHighlighted): 
		$Body/LowerBody/OutlineHighlighted.visible = true
		$Body/UpperBody/OutlineHighlighted.visible = true
		$TargetPositionMark.visible = true
	else: 
		$Body/LowerBody/OutlineHighlighted.visible = false
		$Body/UpperBody/OutlineHighlighted.visible = false
		$TargetPositionMark.visible = false

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
