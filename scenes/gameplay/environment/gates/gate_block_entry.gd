extends StaticBody3D


func _ready() -> void:
	$AnimationPlayer.play("gate", -1, 0.0)


func _on_area_3d_body_exited(body:Node3D) -> void:
	$Area3D.collision_mask = 0
	collision_layer = 5
	$AnimationPlayer.play("gate")

