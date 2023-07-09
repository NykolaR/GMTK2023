extends Node3D


func _ready() -> void:
	for i in $FloorGrid.get_children().size():
		for j in $FloorGrid.get_child(i).get_children().size():
			var cfloor: CollisionObject3D = $FloorGrid.get_child(i).get_child(j) as CollisionObject3D
			if cfloor:
				cfloor.mouse_entered.connect(Helper.cube_highlighted_func.bind(cfloor.global_position, cfloor))
				cfloor.mouse_exited.connect(Helper.cube_dehighlighted_func.bind(cfloor.global_position, cfloor))

