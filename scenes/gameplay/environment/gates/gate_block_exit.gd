extends StaticBody3D


func _ready() -> void:
	Helper.open_the_gates.connect(_open_the_gates)


func _open_the_gates() -> void:
	collision_layer = 0
	$AnimationPlayer.play_backwards("gate")

