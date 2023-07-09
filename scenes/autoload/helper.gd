extends Node

var player: HealthObject

signal cube_highlighted(position: Vector3, floor: Node3D)
signal cube_dehighlighted(position: Vector3, floor: Node3D)
signal open_the_gates

func cube_highlighted_func(position: Vector3, floor: Node3D) -> void:
	cube_highlighted.emit(position, floor)


func cube_dehighlighted_func(position: Vector3, floor: Node3D) -> void:
	cube_dehighlighted.emit(position, floor)


func enemy_count_check() -> void:
	await get_tree().physics_frame
	if get_tree().get_nodes_in_group("enemy").is_empty():
		open_the_gates.emit()

