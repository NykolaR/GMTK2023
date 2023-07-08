extends CharacterBody3D

@export var speed: float = 2.0
@export var horizontal: bool = true
@export var damage: int = 2

var _positive: bool = true
var _moving: bool = true

func _physics_process(delta: float) -> void:
	if _moving:
		if horizontal:
			if _positive:
				velocity.x = speed
			else:
				velocity.x = -speed
		else:
			if _positive:
				velocity.z = speed
			else:
				velocity.z = -speed

		var col_result: KinematicCollision3D = move_and_collide(velocity * delta)
		if col_result:
			var collider: Object = col_result.get_collider()
			if collider:
				_moving = false
				$Restart.start()
				# turn around
				_positive = not _positive
				if collider is HealthObject:
					collider.health -= damage


func _on_restart_timeout() -> void:
	_moving = true
