extends HealthObject

const SPEED: float = 2.0

@onready var visual: Node3D = $MeshInstance3D as Node3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D as NavigationAgent3D


func _ready() -> void:
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	nav_agent.set_target_position(Vector3(0, 0, -5))


func _physics_process(delta: float) -> void:
	var ndir: Vector3 = _get_nav_direction()
	#velocity = ndir * SPEED
	nav_agent.velocity = ndir * SPEED
	_nav_look(velocity)
	move_and_slide()


func _get_nav_direction() -> Vector3:
	if not nav_agent.is_navigation_finished():
		var cap: Vector3 = global_position
		var npp: Vector3 = nav_agent.get_next_path_position()

		var new_vel: Vector3 = npp - cap
		new_vel = new_vel.normalized()
		return new_vel
	else:
		nav_agent.set_target_position(get_tree().get_nodes_in_group("point").pick_random().global_position)

	return Vector3.ZERO


func _nav_look(nav_dir: Vector3) -> void:
	if not nav_dir.is_zero_approx():
		visual.look_at(visual.global_position + nav_dir)


func _on_navigation_agent_3d_velocity_computed(safe_velocity:Vector3) -> void:
	velocity = safe_velocity
