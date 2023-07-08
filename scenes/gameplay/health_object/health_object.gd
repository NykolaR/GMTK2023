class_name HealthObject
extends CharacterBody3D


@export var max_health: int = 5
@onready var health: int = max_health: set = set_health


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


# to be overwridden
# mostly for visual effects on hit
func hit() -> void:
	pass


# to be overwridden
func death() -> void:
	queue_free()

