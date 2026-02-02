extends CharacterBody2D

const Teams = preload("res://main/teams.gd").Teams

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
var movement_speed = 300.0
var target: Vector2 = Vector2(0,0)

@onready var navigation_agent = $NavigationAgent2D

func _ready() -> void:
	state_machine = $StateMachine
	call_deferred("pathfinfing_setup")

func pathfinfing_setup():
	await get_tree().physics_frame

func set_destination(pos: Vector2):
	if pos != Vector2(0,0):
		navigation_agent.target_position = pos
		$TargetPositionMark.position = pos
		state_machine.set_state("Move")
		navigation_agent.avoidance_priority = 1
		
func set_movement_group(group):
	if movement_group: # Leave old group first
		if movement_group!=null && is_instance_valid(movement_group.get_ref()):
			movement_group.get_ref().remove_unit(self)
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
