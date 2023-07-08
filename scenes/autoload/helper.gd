extends Node


signal cube_highlighted(position: Vector3, floor: Node3D)
signal cube_dehighlighted(position: Vector3, floor: Node3D)


func cube_highlighted_func(position: Vector3, floor: Node3D) -> void:
	cube_highlighted.emit(position, floor)


func cube_dehighlighted_func(position: Vector3, floor: Node3D) -> void:
	cube_dehighlighted.emit(position, floor)


