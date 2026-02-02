extends Unit_State
class_name UnitIdle

@export var state_target : CharacterBody2D

var turretRotationTime : float
var turretRotationTarget : int


func randomizeTurretRotation():
	turretRotationTarget = deg_to_rad(randi_range(0,360))
	turretRotationTime = randf_range(1,3)

func Enter():
	randomizeTurretRotation()
	
func PhysicsUpdate(_delta: float):
	if(state_target):
		state_target.get_node("Body/UpperBody").rotation = (state_target.get_node("Body/UpperBody").rotation*3+turretRotationTarget)/4.

func Update(_delta: float):
	turretRotationTime-=_delta
	if turretRotationTime <= 0:
		randomizeTurretRotation()
