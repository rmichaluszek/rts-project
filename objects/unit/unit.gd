extends CharacterBody2D

const Teams = preload("res://main/teams.gd").Teams
const TeamColor = preload("res://main/teams.gd").TeamColor

@export var isSelected: bool = false
@export var isHighlighted: bool = false
@export var team: Teams = Teams.BLUE

var state_machine : Node
var movement_group = null

var unit_name = "Gunner Bot"
var max_health = 100
var health = 100
var range = 200
var damage = 5
var movement_speed = 100.0

var attack_on_sight = true
var target: Vector2 = Vector2(0,0)
var move_unit_target: WeakRef = null
var attack_unit_target: WeakRef = null

var my_actions = [
	"SET_TARGET",
	"STOP",
	"ATTACK_ON_SIGHT",
	null,
	null,
	"RETREAT"
]


@onready var navigation_agent = $NavigationAgent2D

func _ready() -> void:
	
	$Body/UpperBody.set_self_modulate(TeamColor[team])
	
	state_machine = $StateMachine
	call_deferred("pathfinfing_setup")

func pathfinfing_setup():
	await get_tree().physics_frame

func move_action(pos: Vector2):
	if(state_machine.current_state != state_machine.states.get("retreat")):
		if pos != Vector2(0,0):
			navigation_agent.target_position = pos
			$TargetPositionMark.position = pos
			state_machine.set_state("Move")
			
func stop_action():
	if(state_machine.current_state != state_machine.states.get("retreat")):
		set_movement_group(null)
		velocity = Vector2.ZERO
		navigation_agent.target_position = position
		state_machine.set_state("Idle")
			
func retreat_action(pos: Vector2):
	if(state_machine.current_state != state_machine.states.get("retreat")):
		if pos != Vector2(0,0):
			navigation_agent.target_position = pos
			$TargetPositionMark.position = pos
			state_machine.set_state("Retreat")
		
func set_movement_group(group):
	if movement_group: # Leave old group first
		if movement_group!=null && is_instance_valid(movement_group.get_ref()):
			movement_group.get_ref().remove_unit(self)
	if(group):
		movement_group = group

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
	$Body/LowerBody.rotation = ($Body/LowerBody.rotation*2+velocity.angle())/3.
