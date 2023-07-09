extends HealthObject


@export var SPEED: float = 2.5
@export var DAMAGE: int = 1

@onready var animation: AnimationPlayer = $MeshInstance3D/grunts/AnimationPlayer as AnimationPlayer
@onready var visual: Node3D = $MeshInstance3D as Node3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D as NavigationAgent3D

var og_position: Vector3 = Vector3.ZERO

var players: Array[Node3D] = []

func _ready() -> void:
	og_position = global_position
	set_physics_process(false)
	# set nav target? no xd


func _physics_process(delta: float) -> void:
	#velocity = Vector3.ZERO
	# if not attacking:
	#	if player in range:
	#		attack
	#	else:
	var ndir: Vector3 = _get_nav_direction()
	nav_agent.velocity = ndir * SPEED
	if velocity.is_zero_approx():
		animation.play("GruntIdle")
		animation.speed_scale = 1.0
	else:
		if players.is_empty():
			animation.play("RoboRun")
		else:
			animation.play("GruntTackle")
		animation.speed_scale = velocity.length()
	_nav_look(velocity)
	super._physics_process(delta)
	move_and_slide()


func _get_nav_direction() -> Vector3:
	if not nav_agent.is_navigation_finished():
		var cap: Vector3 = global_position
		var npp: Vector3 = nav_agent.get_next_path_position()

		var new_vel: Vector3 = npp - cap
		new_vel = new_vel.normalized()
		return new_vel
	else:
		if is_instance_valid(Helper.player):
			nav_agent.target_position = Helper.player.global_position
		else:
			nav_agent.target_position = og_position
		# nav_agent.set_target_position(get_tree().get_nodes_in_group("point").pick_random().global_position)
	
	return Vector3.ZERO


func _nav_look(nav_dir: Vector3) -> void:
	if not Vector2(nav_dir.x, nav_dir.z).is_zero_approx():
		visual.look_at(visual.global_position + nav_dir)


func _on_navigation_agent_3d_velocity_computed(safe_velocity:Vector3) -> void:
	velocity = safe_velocity


func death() -> void:
	#call_deferred("set_collision_layer", 0)
	$CollisionShape3D.global_position = Vector3(0, -100, 0)
	set_physics_process(false)
	animation.play("GruntDed")
	remove_from_group("enemy")
	#super.death()
	#Helper.enemy_count_check()


func big_dead() -> void:
	super.death()
	Helper.enemy_count_check()


func _on_player_detect_body_exited(body:Node3D) -> void:
	players.erase(body)


func _on_player_detect_body_entered(body:Node3D) -> void:
	if not players.has(body):
		players.append(body)


