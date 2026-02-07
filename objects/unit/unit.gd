extends CharacterBody2D

const Teams = preload("res://main/teams.gd").Teams
const TeamColor = preload("res://main/teams.gd").TeamColor

var bullet = preload("res://objects/bullet/bullet.tscn")

var isSelected: bool = false
var isHighlighted: bool = false
var isTargeted: bool = false
@export var team: Teams = Teams.BLUE

var state_machine : Node
var movement_group = null

var unit_name = "Gunner Bot"
var max_health = 100
var health = 100
var attack_range = 400
var damage = 5
var movement_speed = 100.0
var attack_cooldown = 1.
var attack_cooldown_left = 0.

var attack_on_sight = true
var target: Vector2 = Vector2(0,0)
var move_unit_target: WeakRef = null
var attack_unit_target: WeakRef = null

var targeted_timeout = 0.1

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
	
	$AttackRange/CollisionShape2D.shape.radius = attack_range
	state_machine = $StateMachine
	call_deferred("pathfinfing_setup")
	
	set_physics_process(true)

func pathfinfing_setup():
	await get_tree().physics_frame
	
func _physics_process(delta: float) -> void:
	$Body/LowerBody.rotation = (velocity.angle()+$Body/LowerBody.rotation*4)/5.
	if(attack_unit_target && attack_unit_target.get_ref()!=null):
		if(global_position.distance_to(attack_unit_target.get_ref().global_position) <= attack_range):
			attack_cooldown_left-=delta
			if(attack_cooldown_left<=0):
				attack_cooldown_left = attack_cooldown
				var new_bullet = bullet.instantiate()
				new_bullet.velocity = Vector2.RIGHT.rotated($Body/UpperBody.rotation)
				new_bullet.set_position($Body/UpperBody/BulletSpawn.global_position)
				new_bullet.target = attack_unit_target
				new_bullet.damage = damage
				add_child(new_bullet)
				
			var last_rotation = $Body/UpperBody.rotation
			$Body/UpperBody.look_at(attack_unit_target.get_ref().position)
			$Body/UpperBody.rotation = ($Body/UpperBody.rotation+last_rotation*5)/6.
		else:
			if(attack_on_sight):
				attack_unit_target = null
				find_closest_target()
	else:
		attack_unit_target = null
		find_closest_target()
		
	if isSelected:
		if(attack_unit_target!=null && attack_unit_target.get_ref()!=null):
			attack_unit_target.get_ref().set_targeted(true)
	
	targeted_timeout -=delta
	if(targeted_timeout<=0 && isTargeted):
		set_targeted(false)

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
		
func set_target_action(unit):
	if(state_machine.current_state != state_machine.states.get("retreat")):
		attack_unit_target = unit
			
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
		
func set_targeted(targeted: bool):
	if(team != get_parent().get_parent().my_team):
		isTargeted = targeted
		if(isTargeted): 
			targeted_timeout = 0.05
			$Body/LowerBody/OutlineTargeted.visible = true
			$Body/UpperBody/OutlineTargeted.visible = true
		else: 
			$Body/LowerBody/OutlineTargeted.visible = false
			$Body/UpperBody/OutlineTargeted.visible = false

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


func _on_attack_range_body_entered(body: Node2D) -> void:
	if(body!= self):
		if(body.team != team):
			if(attack_on_sight):
				if(attack_unit_target==null):
					attack_cooldown_left = attack_cooldown
					attack_unit_target=weakref(body)

func get_damage(amount):
	health-=amount
	if(health<=0 && health > -200):
		health = -1000
		if(is_instance_valid(self)):
			$DeathParticles.finished.connect($DeathParticles.queue_free)
			$DeathParticles.emitting = true
			$DeathParticles.reparent(get_parent().get_parent())
			if(is_instance_valid(movement_group) && movement_group.get_ref()!=null):
				movement_group.get_ref().remove_unit(self)
				
			get_parent().get_parent().get_node("GroupManager").call_deferred("update_selected_units",self)
			queue_free()
	# play damage animation
	
func find_closest_target():
	var bodies = $AttackRange.get_overlapping_bodies()
	var closest_body = null
	for b in bodies:
		if closest_body == null:
			if(b.team != team):
				if(attack_on_sight):
					closest_body = b
		elif global_position.distance_to(b.global_position) < global_position.distance_to(closest_body.global_position):
			if(b.team != team):
				if(attack_on_sight):
					closest_body = b
	if(closest_body):
		attack_unit_target = weakref(closest_body)

func _on_attack_range_body_exited(body: Node2D) -> void:
	if(attack_unit_target!=null && is_instance_valid(attack_unit_target)):
		if(body == attack_unit_target.get_ref()):
			if(body.team != team):
				if(attack_unit_target!=null):
					attack_unit_target=null
					find_closest_target()
