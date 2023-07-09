extends HealthObject

const SPEED: float = 2.0

var end_aiming: bool = false

@onready var animation: AnimationPlayer = $MeshInstance3D/ai_player/AnimationPlayer as AnimationPlayer
@onready var visual: Node3D = $MeshInstance3D as Node3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D as NavigationAgent3D


var enemies: Array[Node3D] = []


func _ready() -> void:
	Helper.player = self
	Helper.open_the_gates.connect(aim_for_end)
	set_physics_process(false)
	animation.play("RoboIdle")
	await get_tree().create_timer(0.5).timeout#physics_frame
	set_physics_process(true)
	nav_agent.target_desired_distance = 0.01


func _physics_process(delta: float) -> void:
	if not animation.current_animation == "RoboAttack":# and animation.is_playing():
		if enemies.size() > 0:
			animation.speed_scale = 1.0
			animation.play("RoboAttack")
		else:
			var ndir: Vector3 = _get_nav_direction()
			#velocity = ndir * SPEED
			nav_agent.velocity = ndir * SPEED
			_nav_look(velocity)
			move_and_slide()
			if velocity.is_zero_approx():
				animation.play("RoboIdle")
			else:
				if not animation.is_playing() or not animation.current_animation == "RoboRun":
					animation.play("RoboRun")
			if animation.current_animation == "RoboRun":
				animation.speed_scale = velocity.length()
			else:
				animation.speed_scale = 1.0


func _get_nav_direction() -> Vector3:
	if not nav_agent.is_navigation_finished():
		var cap: Vector3 = global_position
		var npp: Vector3 = nav_agent.get_next_path_position()

		var new_vel: Vector3 = npp - cap
		new_vel = new_vel.normalized()
		return new_vel
	elif end_aiming:
		nav_agent.target_position = Vector3(0, 0, -5)
		# nav_agent.set_target_position(get_tree().get_nodes_in_group("point").pick_random().global_position)
	else:
		var enemies: Array = get_tree().get_nodes_in_group("enemy")
		if not enemies.is_empty():
			var closest: Node3D = enemies.pop_front()
			var closest_dist: float = global_position.distance_squared_to(closest.global_position)
			for enemy in enemies:
				var dist: float = global_position.distance_squared_to(enemy.global_position)
				if global_position.distance_squared_to(enemy.global_position) < closest_dist:
					closest = enemy
					closest_dist = dist
			nav_agent.target_position = closest.global_position

	return Vector3.ZERO


func _nav_look(nav_dir: Vector3) -> void:
	if not Vector2(nav_dir.x, nav_dir.z).is_zero_approx():
		visual.look_at(visual.global_position + nav_dir)


func _on_navigation_agent_3d_velocity_computed(safe_velocity:Vector3) -> void:
	velocity = safe_velocity


func aim_for_end() -> void:
	end_aiming = true
	#nav_agent.target_position = Vector3(0, 0, -5)


func robo_hit() -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			if enemy is HealthObject:
				enemy.health -= 3
				enemy.hit(global_position.direction_to(enemy.global_position) * 3.0)


func _on_detection_body_entered(body:Node3D) -> void:
	if not enemies.has(body):
		enemies.append(body)


func _on_detection_body_exited(body:Node3D) -> void:
	enemies.erase(body)

