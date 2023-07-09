class_name HealthObject
extends CharacterBody3D


@export var max_health: int = 5
@onready var health: int = max_health: set = set_health


var _impulse: Vector3 = Vector3.ZERO


func set_health(new: int) -> void:
	if health == 0 or new <= 0:
		health = 0
		death()
		return
	
	if new > health:
		# healing, maybe do some visual effect
		health = min(max_health, new)
	else:
		# hurt, maybe do some visual effect
		health = max(1, new)
		hit()


func _physics_process(delta: float) -> void:
	velocity += _impulse
	_impulse = _impulse.move_toward(Vector3.ZERO, delta * 5.0)


# to be overwridden
# mostly for visual effects on hit
func hit(impulse: Vector3 = Vector3.ZERO) -> void:
	_impulse += impulse


# to be overwridden
func death() -> void:
	queue_free()

