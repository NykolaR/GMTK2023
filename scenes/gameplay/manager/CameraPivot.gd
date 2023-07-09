extends Node3D

var pivoting: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			pivoting = event.pressed
	if pivoting and event is InputEventMouseMotion:
		rotate_y(event.relative.x * 0.005)

