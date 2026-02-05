extends Area2D

var target: WeakRef = null
var velocity: Vector2 = Vector2.ZERO
var damage = 0

func _ready() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	position += velocity*20
	


func _on_body_entered(body: Node2D) -> void:
	if(target!=null && is_instance_valid(target)):
		if body == target.get_ref():
			queue_free()
			body.get_damage(damage)
